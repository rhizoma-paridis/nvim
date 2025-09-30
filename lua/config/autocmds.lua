local paridis_group = vim.api.nvim_create_augroup("Paridis", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = paridis_group,
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})