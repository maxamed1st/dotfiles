return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local function show_macro_recording()
				local recording_register = vim.fn.reg_recording()
				if recording_register == "" then
					return ""
				else
					return "Recording @" .. recording_register
				end
			end
			require("lualine").setup({
				options = {
					theme = "tokyonight",
				},
				sections = {
					lualine_c = {
						"filename",
						{
							"macro-recording",
							fmt = show_macro_recording,
						},
					},
				},
			})
		end,
	},
}
