local leet_arg = "leetcode.nvim"

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
  },
  { "altermo/nwm", branch = "x11" },
  { "glacambre/firenvim", build = ":call firenvim#install(0)" },
  { "ellisonleao/gruvbox.nvim" },
  {
    "MunifTanjim/nui.nvim",
    dependencies = {
      ensure_installed = {
        "nvim-telescope/telescope.nvim",
        "kawre/leetcode.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    },
  },
  {
    "nvim-lua/plenary.nvim",
    dependencies = {
      ensure_installed = {
        "nvim-telescope/telescope.nvim",
        "kawre/leetcode.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      ensure_installed = {
        "nvim-lua/plenary.nvim",
        "kawre/leetcode.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    },
  },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      ensure_installed = {
        "MunifTanjim/nui.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
      },
    },
    lazy = leet_arg ~= vim.fn.argv()[1],
    opts = { arg = leet_arg },
    config = function()
      require("leetcode").setup {
        -- Add your leetcode.nvim configuration here
        lang = "python3", -- or your preferred language
        directory = vim.fn.stdpath "data" .. "/leetcode/",
        logging = true,
      }
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {},
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "typescript-language-server",
        "tsserver",
        "css-lsp",
        "prettier",
        "pyright",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      dependencies = {
        "kawre/leetcode.nvim",
        "MunifTanjim/nui.nvim",
      },
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "typescript",
        "javascript",
        "prettier",
      },
    },
  },
}
