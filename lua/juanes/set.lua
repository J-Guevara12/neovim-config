vim.opt.nu = true
vim.opt.wrap = false
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/vim/undodir/"
vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- Workaround for Neovim 0.12 bug: TSNode userdata can become invalid (freed C
-- struct) while still being truthy in Lua, causing node:range() to fail inside
-- the conceal_line decoration provider.
vim.schedule(function()
  local orig = vim.treesitter.get_range
  vim.treesitter.get_range = function(node, source, metadata)
    local ok, result = pcall(orig, node, source, metadata)
    if not ok then return { 0, 0, 0, 0, 0, 0 } end
    return result
  end
end)
