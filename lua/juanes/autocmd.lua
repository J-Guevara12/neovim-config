vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.keymap.set('n', '<leader>k', ':w <CR> :! python %<CR>')
    vim.keymap.set('n', '<leader>K', ':w <CR> :terminal python %<CR>')
    vim.keymap.set('n', '<leader>t', ':w <CR> :terminal pytest %<CR>')
  end
})
vim.api.nvim_create_autocmd("BufRead", {
    pattern = "Jenkinsfile",
    callback = function ()
        vim.bo.filetype = "groovy"
    end
})
