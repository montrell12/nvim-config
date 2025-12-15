require "nvchad.mappings"



local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map('t', 'jk', [[<C-\><C-n>]], opts)

map('v', '<A-j>', ":m '>+1<CR>gv=gv", opts)
map('v', '<A-k>', ":m '<-2<CR>gv=gv", opts)

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
