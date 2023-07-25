vim.g.mapleader = " "

-- Save file
vim.keymap.set("n", "<leader>w", vim.cmd.w)

-- Save file and close editor
vim.keymap.set("n", "<C-w>", vim.cmd.wq)

-- Close editor
vim.keymap.set("n", "<leader>q", vim.cmd.q)
vim.keymap.set("n", "<C-q>", ":q!<CR>")

-- source file
vim.keymap.set("n", "<leader>s", vim.cmd.so)

-- File explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Exit insert mode
vim.keymap.set("n", "<C-c>", "<Esc>l")
vim.keymap.set("i", "jk","<Esc>")

-- Move blocks in visual mode
vim.keymap.set("v", "K", ":move '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":move '>+1<CR>gv=gv")

-- Easier indenting
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- Line snaping doesn't move
vim.keymap.set("n", "J", "mzJ`z")
-- Keep page jumps with cursor at the center
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- When searching the tarfet is in the center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- copy to void register
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Yarns into OS clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- deletes into void register
vim.keymap.set("x", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- Navigate across the bufferline
vim.keymap.set("n", "<TAB>", vim.cmd.BufferLineCycleNext)
vim.keymap.set("n", "<S-TAB>", vim.cmd.BufferLineCyclePrev)

-- Move tabs in the bufferline
vim.keymap.set("n", "NN", vim.cmd.BufferLineMoveNext)
vim.keymap.set("n", "VV", vim.cmd.BufferLineMovePrev)

-- Sort tabs in the bufferline
vim.keymap.set("n", "VN", vim.cmd.BufferLineSortByExtension)
vim.keymap.set("n", "NV", vim.cmd.BufferLineSortByDirectory)

-- Close buffer
vim.keymap.set("n", "<leader>x", vim.cmd.bd)
