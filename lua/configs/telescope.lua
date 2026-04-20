local options = {
  defaults = {
    previewer = true,
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        preview_width = 0.55,
        preview_cutoff = 120,
      },
      vertical = {
        preview_height = 0.5,
      },
      width = 0.87,
      height = 0.80,
    },
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
  },
  pickers = {
    find_files = {
      previewer = true,
    },
    live_grep = {
      previewer = true,
    },
    buffers = {
      previewer = true,
    },
  },
}

return options
