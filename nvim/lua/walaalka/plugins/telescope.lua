return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local actions = require("telescope.actions")
		local actions_set = require("telescope.actions.set")
		local actions_utils = require("telescope.actions.utils")
		local builtin = require("telescope.builtin")

		require("telescope").setup({
			defaults = {
				initial_mode = "normal",
				mappings = {
					n = {
						["q"] = actions.close,
					},
				},
			},
		})

		local delete_buffer = function(prompt_bufnr)
			actions.delete_buffer(prompt_bufnr)
		end

		local function buffer_mappings(prompt_bufnr, map)
			-- delete a buffer
			map("n", "d", delete_buffer, { desc = "delete buffer" })

      -- assign number to open each buffer
			actions_utils.map_entries(prompt_bufnr, function(_, index)
				print(index)
				map("n", tostring(index), function()
					-- move upwards
					actions_set.shift_selection(prompt_bufnr, -index)
					-- open file in current buffer
					actions.select_default(prompt_bufnr)
				end)
			end)
		end

		-- Function to call the buffers picker with custom mappings
		local function custom_buffers_picker()
			builtin.buffers({
				attach_mappings = function(prompt_bufnr, map)
					buffer_mappings(prompt_bufnr, map)
					return true
				end,
			})
		end

		-- Keybinding to invoke buffers picker
		vim.keymap.set("n", "<leader>b", custom_buffers_picker, { desc = "Buffers" })
	end,
}
