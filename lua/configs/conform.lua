local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    swift = { "swiftformat" },
  },

  formatters = {
    swiftformat = {
      command = "xcrun",
      args = { "swift-format", "format", "--assume-filename", "$FILENAME", "-" },
      stdin = true,
    },
  },

  format_on_save = {
    timeout_ms = 2000,
    lsp_fallback = true,
  },
}

return options
