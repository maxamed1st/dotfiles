vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>")

-- toggle search highlight
-- local toggle_hlsearch = function()
-- 	if vim.o.hlsearch then
-- 	  vim.o.hlsearch = false
-- 	else
-- 		vim.o.hlsearch = true
-- 	end
-- end
vim.keymap.set("n", "<esc>", "<cmd>noh<cr>", { desc = "noh", noremap = true, silent = true })
vim.keymap.set("n", "<leader>cn", "<cmd>Noice<cr>", { desc = "Noice" })
