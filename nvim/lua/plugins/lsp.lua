return {

  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        require("cmp_nvim_lsp").default_capabilities(),
        lspconfig.util.default_config.capabilities
      )


      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = require("utils").onAttach,
      })

      lspconfig["lua_ls"].setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "love" },
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                [vim.fn.expand("~/.local/share/love-api")] = true,
              },
            },
          },
        },
      })

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

      -- Function to toggle diagnostics
      local function toggle_diagnostics()
        if vim.diagnostic.is_enabled() then
          vim.diagnostic.enable(false)
        else
          vim.diagnostic.enable()
        end
      end

      -- Map the function to a key, e.g., <leader>d
      vim.api.nvim_set_keymap('n', '<leader>cd', '<cmd>lua Show_line_diagnostics()<CR>',
        { noremap = true, silent = true, desc = "Show diagnostics" })
      -- toggle diagnostic
      vim.keymap.set('n', '<leader>ct', toggle_diagnostics,
        { noremap = true, silent = true, desc = "Toggle diagnostics" })
    end,
  },

  -- mason.nvim
  {
    "mason-org/mason.nvim",
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

  -- mason-lspconfig.nvim old version
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "tailwindcss", "bashls" },
        automatic_enable = true,
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
