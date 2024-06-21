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
    { key = '[d', cmd = 'vim.lsp.diagnostic.goto_prev()', desc = 'Go to previous diagnostic' },
    { key = ']d', cmd = 'vim.lsp.diagnostic.goto_next()', desc = 'Go to next diagnostic' },
    { key = '<leader>q', cmd = 'vim.lsp.diagnostic.set_loclist()', desc = 'Set location list' }
  }

  for _, mapping in ipairs(mappings) do
    buf_set_keymap(bufnr, 'n', mapping.key, '<cmd>lua ' .. mapping.cmd .. '<CR>', vim.tbl_extend('force', opts, { desc = mapping.desc }))
  end
end

M.delete_buffer = function (buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 0 then -- Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr("#")
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end

return M
