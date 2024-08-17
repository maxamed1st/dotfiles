vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.fillchars = { eob = " " }

-- Enable system clipboard support
vim.opt.clipboard:append("unnamedplus")
vim.opt.scrolloff = 999
vim.opt.signcolumn = "yes"
vim.opt.undofile = true
vim.opt.undolevels = 10000
