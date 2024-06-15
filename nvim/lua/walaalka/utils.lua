local M = {}

M.onAttach = function(_, bufnr)
  local buf_set_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap = true, silent = true }

  local mappings = {
    { key = 'gd', cmd = 'vim.lsp.buf.definition()', desc = 'Go to definition' },
    { key = 'K', cmd = 'vim.lsp.buf.hover()', desc = 'Hover documentation' },
    { key = 'gI', cmd = 'vim.lsp.buf.implementation()', desc = 'Go to implementation' },
    { key = '<gs>', cmd = 'vim.lsp.buf.signature_help()', desc = 'Signature help' },
    { key = 'gD', cmd = 'vim.lsp.buf.type_definition()', desc = 'Go to type definition' },
    { key = '<leader>fm', cmd = 'vim.lsp.buf.rename()', desc = 'Rename' },
    { key = 'gr', cmd = 'vim.lsp.buf.references()', desc = 'Find references' },
    { key = '<leader>ca', cmd = 'vim.lsp.buf.code_action()', desc = 'Code action' },
    { key = '<leader>cD', cmd = 'vim.lsp.diagnostic.show_line_diagnostics()', desc = 'Show line diagnostics' },
    { key = '[d', cmd = 'vim.lsp.diagnostic.goto_prev()', desc = 'Go to previous diagnostic' },
    { key = ']d', cmd = 'vim.lsp.diagnostic.goto_next()', desc = 'Go to next diagnostic' },
    { key = '<leader>q', cmd = 'vim.lsp.diagnostic.set_loclist()', desc = 'Set location list' }
  }

  for _, mapping in ipairs(mappings) do
    buf_set_keymap(bufnr, 'n', mapping.key, '<cmd>lua ' .. mapping.cmd .. '<CR>', vim.tbl_extend('force', opts, { desc = mapping.desc }))
  end
end

return M

