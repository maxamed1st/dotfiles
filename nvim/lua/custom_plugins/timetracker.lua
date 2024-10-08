local M = {}
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

M.projects = {}
M.current_project = nil
M.current_task = nil
M.data_file = vim.fn.stdpath('data') .. '/time_tracker.csv'

function M.load_data()
  local file = io.open(M.data_file, 'r')
  if file then
    for line in file:lines() do
      local project, task, duration = line:match("([^,]+)::([^,]+)::(%d+)")
      if project and task and duration then
        if not M.projects[project] then
          M.projects[project] = { tasks = {} }
        end
        M.projects[project].tasks[task] = {
          name = task,
          duration = tonumber(duration)
        }
      end
    end
    file:close()
  end
end

function M.save_data()
  local file = io.open(M.data_file, 'w')
  if file then
    for project_name, project in pairs(M.projects) do
      for task_name, task in pairs(project.tasks) do
        file:write(string.format("%s::%s::%d\n", project_name, task_name, task.duration))
      end
    end
    file:close()
  end
end

function M.create_project(project_name)
  if not M.projects[project_name] then
    M.projects[project_name] = { tasks = {} }
    M.save_data()
    print("Project created: " .. project_name)
  else
    print("Project already exists: " .. project_name)
  end
end

function M.delete_project(project_name)
  if M.projects[project_name] then
    M.projects[project_name] = nil
    if M.current_project == project_name then
      M.current_project = nil
    end
    if M.current_task and M.current_task.project == project_name then
      M.current_task = nil
    end
    M.save_data()
    print("Project deleted: " .. project_name)
  else
    print("Project does not exist: " .. project_name)
  end
end

function M.create_task(project_name, task_name)
  if not M.projects[project_name] then
    print("Project does not exist: " .. project_name)
    return
  end

  if not M.projects[project_name].tasks[task_name] then
    M.projects[project_name].tasks[task_name] = {
      name = task_name,
      duration = 0
    }
    M.save_data()
    print("Task created: " .. task_name .. " in project: " .. project_name)
  else
    print("Task already exists: " .. task_name .. " in project: " .. project_name)
  end
end

function M.delete_task(project_name, task_name)
  if not M.projects[project_name] then
    print("Project does not exist: " .. project_name)
    return
  end

  if M.projects[project_name].tasks[task_name] then
    M.projects[project_name].tasks[task_name] = nil
    if M.current_task and M.current_task.project == project_name and M.current_task.name == task_name then
      M.current_task = nil
    end
    M.save_data()
    print("Task deleted: " .. task_name .. " from project: " .. project_name)
  else
    print("Task does not exist: " .. task_name .. " in project: " .. project_name)
  end
end

function M.start_task(project_name, task_name)
  if M.current_task then
    M.stop_task()
  end

  if not M.projects[project_name] or not M.projects[project_name].tasks[task_name] then
    print("Task or project does not exist")
    return
  end

  M.current_project = project_name
  M.current_task = {
    project = project_name,
    name = task_name,
    start_time = os.time(),
  }

  print("Started task: " .. task_name .. " in project: " .. project_name)
end

function M.stop_task()
  if M.current_task then
    local end_time = os.time()
    local duration = end_time - M.current_task.start_time

    M.projects[M.current_task.project].tasks[M.current_task.name].duration =
        M.projects[M.current_task.project].tasks[M.current_task.name].duration + duration

    print("Stopped task: " .. M.current_task.name ..
      " in project: " .. M.current_task.project ..
      " (Duration: " .. M.format_time(duration) .. ")")

    M.current_task = nil
    M.save_data()
  else
    print("No task is currently running")
  end
end

function M.edit_task_name(project_name, old_task_name)
  if not M.projects[project_name] or not M.projects[project_name].tasks[old_task_name] then
    print("Task or project does not exist")
    return
  end

  local new_task_name = vim.fn.input("New task name: ", old_task_name) -- Prompt for new name, default to old name
  if new_task_name ~= "" and new_task_name ~= old_task_name then
    M.projects[project_name].tasks[new_task_name] = M.projects[project_name].tasks
        [old_task_name]                                 -- Copy the task data to the new task name
    M.projects[project_name].tasks[old_task_name] = nil -- Remove the old task
    M.save_data()                                       -- Save changes to the CSV file
    print("Task renamed from '" .. old_task_name .. "' to '" .. new_task_name .. "' in project: " .. project_name)
  elseif new_task_name == "" then
    print("Task name cannot be empty")
  else
    print("No changes made to the task name")
  end
end

function M.edit_task_duration(project_name, task_name)
  if not M.projects[project_name] or not M.projects[project_name].tasks[task_name] then
    print("Task or project does not exist")
    return
  end
  local new_duration = tonumber(vim.fn.input("New duration (in seconds): ",
    M.projects[project_name].tasks[task_name].duration))
  if new_duration and new_duration >= 0 then
    M.projects[project_name].tasks[task_name].duration = new_duration
    M.save_data()
    print("Task duration updated to " .. M.format_time(new_duration) .. " in project: " .. project_name)
  else
    print("Invalid duration")
  end
end

function M.format_time(seconds)
  local hours = math.floor(seconds / 3600)
  local minutes = math.floor((seconds % 3600) / 60)
  local secs = seconds % 60
  return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- Telescope picker for projects
function M.project_picker(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Projects",
    finder = finders.new_table {
      results = vim.tbl_keys(M.projects),
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry .. (entry == M.current_project and " (current)" or ""),
          ordinal = entry,
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      local create_new_project = function()
        local new_project = vim.fn.input("New project name: ")
        if new_project ~= "" then
          M.create_project(new_project)
          actions.close(prompt_bufnr)
          M.project_picker(opts)
        end
      end

      local delete_project = function()
        local selection = action_state.get_selected_entry()
        if selection then
          M.delete_project(selection.value)
          actions.close(prompt_bufnr)
          M.project_picker(opts)
        end
      end

      local open_task_picker = function()
        local selection = action_state.get_selected_entry()
        if selection then
          actions.close(prompt_bufnr)
          M.task_picker(selection.value, opts)
        end
      end

      -- Map both insert and normal mode
      map('i', '<C-n>', create_new_project)
      map('n', '<C-n>', create_new_project)
      map('i', '<C-d>', delete_project)
      map('n', '<C-d>', delete_project)
      map('i', '<CR>', open_task_picker)
      map('n', '<CR>', open_task_picker)

      return true
    end,
  }):find()
end

function M.task_picker(project_name, opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Tasks in " .. project_name,
    finder = finders.new_table {
      results = vim.tbl_keys(M.projects[project_name].tasks),
      entry_maker = function(entry)
        local task = M.projects[project_name].tasks[entry]
        local status = ""
        if M.current_task and M.current_task.project == project_name and M.current_task.name == entry then
          status = " (running)"
        end
        return {
          value = entry,
          display = entry .. " " .. M.format_time(task.duration) .. status,
          ordinal = entry,
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      local create_new_task = function()
        local new_task = vim.fn.input("New task name: ")
        if new_task ~= "" then
          M.create_task(project_name, new_task)
          actions.close(prompt_bufnr)
          M.task_picker(project_name, opts)
        end
      end

      local delete_task = function()
        local selection = action_state.get_selected_entry()
        if selection then
          M.delete_task(project_name, selection.value)
          actions.close(prompt_bufnr)
          M.task_picker(project_name, opts)
        end
      end

      local start_stop_task = function()
        local selection = action_state.get_selected_entry()
        if selection then
          if M.current_task and M.current_task.project == project_name and M.current_task.name == selection.value then
            M.stop_task()
          else
            M.start_task(project_name, selection.value)
          end
          actions.close(prompt_bufnr)
          M.task_picker(project_name, opts)
        end
      end

      local go_back_to_projects = function()
        actions.close(prompt_bufnr)
        M.project_picker(opts)
      end

      local edit_task_name = function()
        local selection = action_state.get_selected_entry()
        if selection then
          M.edit_task_name(project_name, selection.value)
          actions.close(prompt_bufnr)
          M.task_picker(project_name, opts)
        end
      end

      local function edit_task_duration()
        local selection = action_state.get_selected_entry()
        if selection then
          M.edit_task_duration(project_name, selection.value)
          actions.close(prompt_bufnr)
          M.task_picker(project_name, opts)
        end
      end

      -- Map both insert and normal mode
      map('i', '<C-n>', create_new_task)
      map('n', '<C-n>', create_new_task)
      map('i', '<C-d>', delete_task)
      map('n', '<C-d>', delete_task)
      map('i', '<CR>', start_stop_task)
      map('n', '<CR>', start_stop_task)
      map('i', '<C-b>', go_back_to_projects)
      map('n', '<C-b>', go_back_to_projects)
      map('i', '<C-e>', edit_task_name)
      map('n', '<C-e>', edit_task_name)
      map('i', '<C-f>', edit_task_duration)
      map('n', '<C-f>', edit_task_duration)

      return true
    end,
  }):find()
end

function M.setup(opts)
  opts = opts or { cmd="TimeTracker", mapkey = "t" }
  -- Load data when the plugin is loaded
  M.load_data()
  print("TimeTracker loaded")

  -- Create a user command to open the GUI
  vim.api.nvim_create_user_command(opts.cmd, function()
    M.project_picker()
  end, {})

  -- optionally setup keymap
  if opts.mapkey then
    vim.api.nvim_set_keymap("n", "<leader>" .. opts.mapkey, ":" .. opts.cmd .. "<CR>",
      { desc = "Time Tracker", noremap = true, silent = true })
  end
end

return M
