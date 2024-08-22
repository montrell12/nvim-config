require "nvchad.mappings"

-- add yours here
local map = vim.keymap.set
local cmd = vim.cmd

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<Leader>pt", "<M-i>", { desc = "CMD enter command mode", remap = true })
map("i", "jk", "<ESC>")

-- LazyGit integration
vim.api.nvim_set_keymap("n", "<leader>lg", ":LazyGit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>lc", ":Leet", { noremap = true, silent = true })
-- vim.highlight.on_yank(yankOptions)
--
--
