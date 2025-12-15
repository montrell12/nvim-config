require("nvchad.configs.lspconfig").defaults()
local lspconfig = require "lspconfig"

local servers = { "html", "cssls" }
vim.lsp.enable(servers)
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

lspconfig.ts_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}



lspconfig.tailwindcss.setup({
  root_dir = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.ts", "postcss.config.js"),
  settings = {
    tailwindCSS = {
      includeLanguages = {
        typescript = "javascript",
        typescriptreact = "javascriptreact",
        javascript = "javascript",
        javascriptreact = "javascriptreact",
      },
      experimental = {
        classRegex = {
          "tw`([^`]*)",
          'tw="([^"]*)"',
          'tw={"([^"}]*)"}',
        },
      },
    },
  },
})
