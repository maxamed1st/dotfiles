-- Open help and man pages in a vertical split
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man" },
  command = "wincmd L"
})
