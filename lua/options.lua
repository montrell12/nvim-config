require "nvchad.options"

-- add yours here!

-- F# filetype detection
vim.filetype.add({
  extension = {
    fs = "fsharp",
    fsx = "fsharp",
    fsi = "fsharp",
  },
})

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
