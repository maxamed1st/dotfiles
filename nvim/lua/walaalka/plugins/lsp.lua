return {

  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig")

      -- Setup diagnostics
      local diagnostic_config = {
        virtual_text = { prefix = "●" }, -- icons or any other prefix
        signs = true,
        underline = true,
        update_in_insert = false,
      }
      vim.diagnostic.config(diagnostic_config)

      -- Function to show diagnostics in a floating window
      function Show_line_diagnostics()
        local opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          source = 'always',
          prefix = ' ',
        }

        vim.diagnostic.open_float(nil, opts)
      end

      -- Map the function to a key, e.g., <leader>d
      vim.api.nvim_set_keymap('n', '<leader>cd', '<cmd>lua Show_line_diagnostics()<CR>', { noremap = true, silent = true })
    end,
  },

  -- mason.nvim
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- mason-lspconfig.nvim
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        require("cmp_nvim_lsp").default_capabilities(),
        require("lspconfig").util.default_config.capabilities
      )

      require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup({
        ensure_installed = { "bashls", "lua_ls", "tsserver", "html", "cssls", "tailwindcss" },
        automatic_installation = true,
        handlers = {
          -- default handlers
          function(server)
            require("lspconfig")[server].setup({
              capabilities = capabilities,
              on_attach = require("walaalka.utils").onAttach,
            })
          end,

          -- targeted handler
          ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              on_attach = require("walaalka.utils").onAttach,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                },
              },
            })
          end,
        },
      })
    end,
  },

  -- neodev.nvim for enhanced Lua development
  { "folke/neodev.nvim", opts = {} },

  	-- set up snippets and completions
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "rafamadriz/friendly-snippets" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
		},
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "lua_snip" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
