return
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
    local utils = require("walaalka.utils")
    wk.register({
      f = {
        name = "Files/Buffers",
        b = { "<cmd>Telescope buffers<cr>", "Buffers" },
        d = { utils.delete_buffer, "delete buffer" },
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
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
        f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
        D = { builtin.diagnostics, "Show all diagnostics" },
      },
      w = {
        name = "Window",
        d = { "<cmd>close<cr>", "delete window" },
      },
      s = {
        name = "Search",
        b = { builtin.current_buffer_fuzzy_find, "Buffer" },
        g = { builtin.live_grep, "Live Grep" },
        t = { "<cmd>TodoTelescope<cr>", "Todo Telescope" }
      },
      g = { name = "Git" },
    }, { prefix = "<leader>" })
  end,
}
