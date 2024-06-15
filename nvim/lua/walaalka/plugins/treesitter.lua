return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
				indent = { enable = true },
				ensure_installed = {
					"bash",
					"lua",
					"vim",
					"html",
					"typescript",
					"javascript",
					"html",
					"css",
					"markdown",
					"markdown_inline",
					"regex",
				},
				auto_install = true,
			})
		end,
	},
}
