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
    wk.add({
      { "<leader>c", group = "Code" },
      { "<leader>cD", builtin.diagnostics, desc = "Show all diagnostics" },
      { "<leader>cf", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", desc = "Format" },
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
      { "<leader>f", group = "Files/Buffers" },
      { "<leader>fc", "<cmd>Telescope resume<cr>", desc = "Continue last search" },
      { "<leader>fd", utils.delete_buffer, desc = "delete buffer" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
      { "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "Man pages" },
      { "<leader>fn", "<cmd>enew<cr>", desc = "New File" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>g", group = "Git" },
      { "<leader>i", group = "Interface" },
      { "<leader>ic", "<cmd>Telescope colorscheme<cr>", desc = "Color Scheme" },
      { "<leader>s", group = "Search" },
      { "<leader>sb", builtin.current_buffer_fuzzy_find, desc = "Buffer" },
      { "<leader>sg", builtin.live_grep, desc = "Live Grep" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
      { "<leader>w", group = "Window" },
      { "<leader>wd", "<cmd>close<cr>", desc = "delete window" },
    })
  end,
}
