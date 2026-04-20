-- Add to ~/.config/nvim/lua/custom/init.lua (or wherever NvChad loads custom config)

-- Metal shader filetype detection
vim.filetype.add({
  extension = {
    metal = "metal",
  },
})

require("custom.dashdocs").setup({
  -- Customize if needed
  float_opts = {
    width = 120,
    height = 35,
  },
  -- Add more filetype mappings
  filetype_map = {
    swift = "Swift",
    typescript = "TypeScript",
    typescriptreact = "TypeScript",
    javascript = "JavaScript",
    python = "Python_3",
    fsharp = "F_Sharp",
  },
})

-- Keymaps - add to your mappings.lua or init.lua
vim.keymap.set("n", "<leader>ds", "<cmd>DashSearch<cr>", { desc = "Dash search" })
vim.keymap.set("n", "<leader>dd", "<cmd>DashWord<cr>", { desc = "Dash word under cursor" })
