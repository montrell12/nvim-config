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
vim.api.nvim_set_keymap(
  "n",
  "<leader>wo",
  ":NWMOpen<CR>",
  { noremap = true, silent = true, desc = "Open URL under cursor" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>wf",
  cmd[[lua require('nwm').open_file()<CR>]],
  { noremap = true, silent = true, desc = "Open current file in browser" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>ws",
  cmd[[lua require('nwm').search()<CR>]],
  { noremap = true, silent = true, desc = "Search web for word under cursor" }
)

-- Optional: Set visual mode keymap for searching selected text
vim.api.nvim_set_keymap(
  "v",
  "<leader>ws",
  cmd[[lua require('nwm').search(vim.fn.expand('<cword>'))<CR>]],
  { noremap = true, silent = true, desc = "Search web for selected text" }
)
cmd [[ 
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END
]]
--;der-i> ap({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
