return {
  "aikhe/fleur.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
    styles = {
      comments = { italic = true },
      keywords = { bold = true },
    },
    plugins = {
      telescope = true,
    },
  },
  config = function()
    vim.cmd "colorscheme fleur"
  end,
}
