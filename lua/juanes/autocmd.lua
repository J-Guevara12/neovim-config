vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.keymap.set('n', '<leader>k', ':w <CR> :! python3 %<CR>')
  end
})
