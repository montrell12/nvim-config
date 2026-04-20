require "nvchad.autocmds"

-- Metal shader filetype detection
vim.filetype.add {
  extension = {
    metal = "metal",
  },
}

-- Use C++ tree-sitter for Metal syntax highlighting
vim.treesitter.language.register("cpp", "metal")

-- Swift LSP auto-attach
vim.api.nvim_create_autocmd("FileType", {
  pattern = "swift",
  callback = function()
    -- Ensure lspconfig is loaded
    local ok, _ = pcall(require, "configs.lspconfig")
    if not ok then
      return
    end
    -- Try to start sourcekit-lsp if not already attached
    vim.defer_fn(function()
      local clients = vim.lsp.get_clients({ name = "sourcekit" })
      if #clients == 0 then
        vim.cmd("LspStart sourcekit")
      end
    end, 100)
  end,
})

-- Metal LSP auto-attach (clangd)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "metal",
  callback = function()
    local ok, _ = pcall(require, "configs.lspconfig")
    if not ok then
      return
    end
    vim.defer_fn(function()
      local clients = vim.lsp.get_clients({ name = "clangd" })
      if #clients == 0 then
        vim.cmd("LspStart clangd")
      end
    end, 100)
  end,
})
