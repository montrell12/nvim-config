return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  -- lazy.nvim
  {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load { paths = { vim.fn.stdpath "config" .. "/snippets" } }
    end,
  },
  {
    "mrjones2014/dash.nvim",
    build = "make install",
    keys = {
      { "<leader>dd", "<cmd>Dash<cr>", desc = "Search Dash" },
      { "<leader>dw", "<cmd>DashWord<cr>", desc = "Search word under cursor" },
    },
  },
  {
    "keith/swift.vim",
    ft = "swift",
  },

  -- LaTeX support
  {
    "lervag/vimtex",
    ft = { "tex", "latex", "bib" },
    init = function()
      vim.g.vimtex_view_method = "skim" -- macOS: use Skim PDF viewer
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_quickfix_mode = 0
    end,
  },

  -- Ionide F# support
  {
    "ionide/Ionide-vim",
    ft = { "fsharp" },
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      vim.g["fsharp#lsp_auto_setup"] = 0  -- We configure LSP manually in lspconfig.lua
      vim.g["fsharp#show_signature_on_cursor_move"] = 1
    end,
  },

  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard", -- harder/darker background
        transparent_mode = false,
        overrides = {
          -- make background even darker
          Normal = { bg = "#1a1a1a" },
          NormalFloat = { bg = "#1a1a1a" },
          SignColumn = { bg = "#1a1a1a" },
          CursorLine = { bg = "#242424" },
        },
        palette_overrides = {
          dark0_hard = "#1a1a1a", -- darker than default #1d2021
          dark0 = "#1e1e1e",
          dark1 = "#242424",
        },
      })
      vim.o.background = "dark"
      vim.cmd "colorscheme gruvbox"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = require "configs.telescope",
  },

  -- Enhanced Swift support
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("xcodebuild").setup()
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "fsautocomplete",
        "typescript-language-server",
        "prettier",
        "eslint-lsp",
        "texlab",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    ft = { "swift", "metal", "typescript", "javascript", "typescriptreact", "javascriptreact", "html", "css", "python", "fsharp", "tex", "latex", "bib" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  { import = "nvchad.blink.lazyspec" },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "cpp",
        "c",
        "fsharp",
        "typescript",
        "javascript",
        "tsx",
        "json",
        "swift",
        "latex",
        "bibtex",
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
    },
  },
}
