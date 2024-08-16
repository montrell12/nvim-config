-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
---

local M = {}
M.ui = {
  theme = "gruvbox",
  statusline = {
    theme = "minimal",
    separator_style = "arrow",
    transparency = true,
    modules = {
      abc = function()
        return "Montrell"
      end,
    },
  },
  cmp = {
    border_color = "grey_fg",
  },
  nvdash = {
    hl_override = {
      Pmenu = { bg = "#ffffff" },
      statusline = { border_color = "#ffffff" },
    },
  },
  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic =
  -- 	true },
  -- },
}

return M
