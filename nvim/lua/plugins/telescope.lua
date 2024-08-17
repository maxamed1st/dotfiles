return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local actions = require("telescope.actions")
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

		-- Function to call the buffers picker with custom mappings
		local function custom_buffers_picker()
			builtin.buffers({
				attach_mappings = function(_, map)
			    map("n", "d", delete_buffer, { desc = "delete buffer" })
					return true
				end,
			})
		end

		-- Keybinding to invoke buffers picker
		vim.keymap.set("n", "<leader>fb", custom_buffers_picker, { desc = "Buffers" })
	end,
}
