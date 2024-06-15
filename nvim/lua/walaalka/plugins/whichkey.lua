return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    config = function()
      local wk = require("which-key")
      local builtin = require("telescope.builtin")
      wk.register({
        f = {
          name = "Files",
          b = { "<cmd>Telescope buffers<cr>", "Buffers" },
          n = { "<cmd>enew<cr>", "New File" },
          r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
        },
        i = {
          name = "Interface",
          c = { "<cmd>Telescope colorscheme<cr>", "Color Scheme" },
        },
        c = {
          name = "Code",
          m = { "<cmd>Mason<cr>", "Mason" },
          d = { builtin.diagnostics, "Diagnostics" },
          f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
        },
        w = {
          name = "Window",
          d = { "<cmd>close<cr>", "delete window" },
        },
        s = {
          name = "Search",
          b = { builtin.current_buffer_fuzzy_find, "Buffer" },
          g = { builtin.live_grep, "Live Grep" },
        },
        g = { name = "Git" },
      }, { prefix = "<leader>" })
    end,
  },
}
