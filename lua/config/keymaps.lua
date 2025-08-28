vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '跳转到定义' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = '跳转到定义' })