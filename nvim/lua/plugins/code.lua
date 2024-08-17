return {

  -- git wrapper
  {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {
      { "<leader>gg", "<cmd>Git<cr>", desc = "Git Status" },
      { "<leader>ga", "<cmd>Git add %<cr>", desc = "Git Add" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git Push" },
      { "<leader>gm", "<cmd>Git commit --amend --no-edit<cr>", desc = "Git Amend" },
      { "<leader>gD", "<cmd>Git diff<cr>", desc = "Git diff all" },
    },
  },

  -- copilot
  {
    "Exafunction/codeium.vim",
    config = function()
      local opts = { expr = true, silent = true }
      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set('i', '<Tab>', function() return vim.fn['codeium#Accept']() end, opts)
      vim.keymap.set('i', '<c-s-k>', function() return vim.fn['codeium#CycleCompletions'](1) end, opts)
      vim.keymap.set('i', '<c-s-j>', function() return vim.fn['codeium#CycleCompletions'](-1) end, opts)
      vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, opts)
    end
  },

  -- undotree
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Undotree" },
    },
  },

  -- Outline
  {
    "hedyhli/outline.nvim",
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

      require("outline").setup({
        -- Your setup opts here (leave empty to use defaults)
      })
    end,
  },

  -- auto close tags and brackets
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },

  {
    'windwp/nvim-ts-autotag',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },
}
