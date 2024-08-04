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
      local project, task, duration = line:match("([^,]+),([^,]+),(%d+)")
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
        file:write(string.format("%s,%s,%d\n", project_name, task_name, task.duration))
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

function M.list_tasks(project_name)
  if not M.projects[project_name] then
    print("Project does not exist: " .. project_name)
    return
  end

  print("Tasks in project: " .. project_name)
  for task_name, task in pairs(M.projects[project_name].tasks) do
    print(task_name .. ": " .. M.format_time(task.duration))
  end
end

function M.list_projects()
  print("Projects:")
  for project_name, _ in pairs(M.projects) do
    if project_name == M.current_project then
      print(project_name .. " (current)")
    else
      print(project_name)
    end
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
          display = entry .. ": " .. M.format_time(task.duration) .. status,
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

      -- Map both insert and normal mode
      map('i', '<C-n>', create_new_task)
      map('n', '<C-n>', create_new_task)
      map('i', '<C-d>', delete_task)
      map('n', '<C-d>', delete_task)
      map('i', '<CR>', start_stop_task)
      map('n', '<CR>', start_stop_task)
      map('i', '<C-b>', go_back_to_projects)
      map('n', '<C-b>', go_back_to_projects)

      return true
    end,
  }):find()
end

-- Load data when the plugin is loaded
M.load_data()

-- Create a single user command to open the GUI
vim.api.nvim_create_user_command("TimeTracker", function()
  M.project_picker()
end, {})

vim.api.nvim_set_keymap("n", "<leader>t", ":TimeTracker<CR>", { desc = "Time Tracker", noremap = true, silent = true })

return M
