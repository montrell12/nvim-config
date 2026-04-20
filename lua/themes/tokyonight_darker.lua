-- Tokyo Night Darker - Based on Tokyo Night with darker backgrounds
-- For NvChad

local M = {}

M.base_30 = {
  white = "#d5deff",
  darker_black = "#0a0b10", -- even darker
  black = "#0e0f14", -- nvim bg (much darker)
  black2 = "#121318", -- darker secondary
  one_bg = "#16171f", -- slightly lighter
  one_bg2 = "#1c1e2a",
  one_bg3 = "#232636",
  grey = "#40486a",
  grey_fg = "#4c5580",
  grey_fg2 = "#585e80",
  light_grey = "#646e9c",
  red = "#ff7a93",
  baby_pink = "#ffb0b0",
  pink = "#ff85b0",
  line = "#16171f", -- for lines like vertsplit
  green = "#b5e878",
  vibrant_green = "#7fffdc",
  nord_blue = "#8fb8ff",
  blue = "#88b4ff",
  yellow = "#f0c070",
  sun = "#ffd98c",
  purple = "#d0a8ff",
  dark_purple = "#b08ff0",
  teal = "#22e8b8",
  orange = "#ffac70",
  cyan = "#8edfff",
  statusline_bg = "#121318",
  lightbg = "#16171f",
  pmenu_bg = "#88b4ff",
  folder_bg = "#88b4ff",
}

M.base_16 = {
  base00 = "#0a0b10", -- Default bg (much darker)
  base01 = "#0e0f14", -- Lighter bg
  base02 = "#16171f", -- Selection bg
  base03 = "#3b4261", -- Comments
  base04 = "#545c7e", -- Dark fg
  base05 = "#b8c0e8", -- Default fg (brighter)
  base06 = "#d5deff", -- Light fg (brighter)
  base07 = "#d5deff", -- Light bg
  base08 = "#ff7a93", -- Red - Variables (brighter)
  base09 = "#ffac70", -- Orange - Integers, Boolean (brighter)
  base0A = "#f0c070", -- Yellow - Classes (brighter)
  base0B = "#b5e878", -- Green - Strings (brighter)
  base0C = "#8edfff", -- Cyan - Support (brighter)
  base0D = "#88b4ff", -- Blue - Functions (brighter)
  base0E = "#d0a8ff", -- Purple - Keywords (brighter)
  base0F = "#ff7a93", -- Red - Deprecated (brighter)
}

M.polish_hl = {
  treesitter = {
    ["@variable"] = { fg = M.base_16.base05 },
    ["@variable.builtin"] = { fg = M.base_30.red },
    ["@variable.parameter"] = { fg = M.base_30.yellow },
    ["@property"] = { fg = M.base_30.cyan },
    ["@function"] = { fg = M.base_30.blue },
    ["@function.builtin"] = { fg = M.base_30.cyan },
    ["@function.call"] = { fg = M.base_30.blue },
    ["@constant"] = { fg = M.base_30.orange },
    ["@constant.builtin"] = { fg = M.base_30.orange },
    ["@constructor"] = { fg = M.base_30.blue },
    ["@type"] = { fg = M.base_30.cyan },
    ["@type.builtin"] = { fg = M.base_30.blue },
    ["@keyword"] = { fg = M.base_30.purple },
    ["@keyword.return"] = { fg = M.base_30.purple },
    ["@keyword.operator"] = { fg = M.base_30.purple },
    ["@string"] = { fg = M.base_30.green },
    ["@number"] = { fg = M.base_30.orange },
    ["@boolean"] = { fg = M.base_30.orange },
    ["@punctuation.bracket"] = { fg = M.base_16.base05 },
    ["@punctuation.delimiter"] = { fg = M.base_16.base05 },
  },
}

M.type = "dark"

return M
