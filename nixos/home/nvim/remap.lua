vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- nvim tree
-- vim.keymap.set("n", "<leader>o", ":NvimTreeFocus<CR>")
-- vim.keymap.set("n", "<leader>k", ":NvimTreeToggle<CR>")

-- move selected up
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


-- Copy to system clipboard
-- vim.keymap.set("v", "<leader>y", "\"+y" )
-- vim.keymap.set("n", "<leader>Y", "\"+yg_" )
-- vim.keymap.set("n", "<leader>y", "\"+y" )

-- Paste from system clipboard
-- vim.keymap.set("n", "<leader>p", "\"+p" )
-- vim.keymap.set("n", "<leader>P", "\"+P" )
-- vim.keymap.set("v", "<leader>p", "\"+p" )
-- vim.keymap.set("v", "<leader>P", "\"+P" )
