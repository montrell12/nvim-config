-- ~/.config/nvim/lua/custom/dashdocs.lua
-- In-buffer Dash documentation viewer

local M = {}

M.config = {
  docset_path = vim.fn.expand("~/Library/Application Support/Dash/DocSets"),
  float_opts = {
    relative = "editor",
    width = 100,
    height = 30,
    border = "rounded",
    title = " Dash Docs ",
    title_pos = "center",
  },
  -- Map filetypes to docset names
  filetype_map = {
    swift = "Swift",
    typescript = "TypeScript",
    typescriptreact = "TypeScript",
    javascript = "JavaScript",
    javascriptreact = "JavaScript",
    python = "Python_3",
    lua = "Lua",
    rust = "Rust",
    go = "Go",
    html = "HTML",
    css = "CSS",
    react = "React",
    fsharp = "F_Sharp",
  },
}

local state = {
  buf = nil,
  win = nil,
}

-- Find docset database path
local function get_docset_db(filetype)
  local docset_name = M.config.filetype_map[filetype]
  if not docset_name then
    return nil, "No docset configured for filetype: " .. filetype
  end

  local base = M.config.docset_path
  local patterns = {
    string.format("%s/%s.docset/Contents/Resources/docSet.dsidx", base, docset_name),
    string.format("%s/%s/%s.docset/Contents/Resources/docSet.dsidx", base, docset_name, docset_name),
  }

  for _, path in ipairs(patterns) do
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end

  return nil, "Docset not found for: " .. docset_name
end

-- Get docset resources path
local function get_resources_path(db_path)
  return vim.fn.fnamemodify(db_path, ":h")
end

-- Query docset database
local function query_docs(db_path, query)
  local cmd = string.format(
    [[sqlite3 -separator '	' '%s' "SELECT name, type, path FROM searchIndex WHERE name LIKE '%%%s%%' COLLATE NOCASE ORDER BY length(name) LIMIT 30"]],
    db_path,
    query:gsub("'", "''")
  )
  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return nil, "Database query failed"
  end

  local results = {}
  for line in output:gmatch("[^\n]+") do
    local name, type, path = line:match("([^\t]+)\t([^\t]+)\t([^\t]+)")
    if name then
      table.insert(results, { name = name, type = type, path = path })
    end
  end
  return results
end

-- Convert HTML to plain text (basic)
local function html_to_text(html)
  local text = html
  -- Remove script and style tags
  text = text:gsub("<script.-</script>", "")
  text = text:gsub("<style.-</style>", "")
  -- Convert common elements
  text = text:gsub("<h1.->(.-)</h1>", "\n# %1\n")
  text = text:gsub("<h2.->(.-)</h2>", "\n## %1\n")
  text = text:gsub("<h3.->(.-)</h3>", "\n### %1\n")
  text = text:gsub("<h4.->(.-)</h4>", "\n#### %1\n")
  text = text:gsub("<p.->(.-)</p>", "%1\n\n")
  text = text:gsub("<li.->(.-)</li>", "  • %1\n")
  text = text:gsub("<br%s*/?>", "\n")
  text = text:gsub("<code.->(.-)</code>", "`%1`")
  text = text:gsub("<pre.->(.-)</pre>", "\n```\n%1\n```\n")
  text = text:gsub("<strong.->(.-)</strong>", "**%1**")
  text = text:gsub("<b.->(.-)</b>", "**%1**")
  text = text:gsub("<em.->(.-)</em>", "*%1*")
  text = text:gsub("<i.->(.-)</i>", "*%1*")
  text = text:gsub("<a.->(.-)</a>", "%1")
  -- Remove remaining tags
  text = text:gsub("<[^>]+>", "")
  -- Decode entities
  text = text:gsub("&lt;", "<")
  text = text:gsub("&gt;", ">")
  text = text:gsub("&amp;", "&")
  text = text:gsub("&quot;", '"')
  text = text:gsub("&nbsp;", " ")
  text = text:gsub("&#%d+;", "")
  -- Clean up whitespace
  text = text:gsub("\n%s*\n%s*\n", "\n\n")
  text = text:gsub("^%s+", "")
  return text
end

-- Read and parse documentation file
local function read_doc(resources_path, doc_path)
  -- Strip anchor
  local file_path = doc_path:gsub("#.*$", "")
  local full_path = resources_path .. "/Documents/" .. file_path

  if vim.fn.filereadable(full_path) ~= 1 then
    return nil, "Doc file not found: " .. full_path
  end

  local file = io.open(full_path, "r")
  if not file then
    return nil, "Cannot open file"
  end

  local content = file:read("*all")
  file:close()

  return html_to_text(content)
end

-- Close floating window
function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
  state.buf = nil
end

-- Open floating window with content
local function open_float(content, title)
  M.close()

  state.buf = vim.api.nvim_create_buf(false, true)

  local lines = vim.split(content, "\n")
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)

  local opts = vim.tbl_extend("force", M.config.float_opts, {
    row = math.floor((vim.o.lines - M.config.float_opts.height) / 2),
    col = math.floor((vim.o.columns - M.config.float_opts.width) / 2),
    title = " " .. title .. " ",
  })

  state.win = vim.api.nvim_open_win(state.buf, true, opts)

  -- Buffer settings
  vim.bo[state.buf].modifiable = false
  vim.bo[state.buf].buftype = "nofile"
  vim.bo[state.buf].filetype = "markdown"

  -- Keymaps
  local buf_opts = { buffer = state.buf, silent = true }
  vim.keymap.set("n", "q", M.close, buf_opts)
  vim.keymap.set("n", "<Esc>", M.close, buf_opts)
end

-- Show search results in Telescope or quickfix
local function show_results(results, db_path)
  local has_telescope, telescope = pcall(require, "telescope.pickers")
  local resources_path = get_resources_path(db_path)

  if has_telescope then
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    telescope.new({}, {
      prompt_title = "Dash Docs",
      finder = finders.new_table({
        results = results,
        entry_maker = function(entry)
          return {
            value = entry,
            display = string.format("[%s] %s", entry.type, entry.name),
            ordinal = entry.name,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            local content, err = read_doc(resources_path, selection.value.path)
            if content then
              open_float(content, selection.value.name)
            else
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end)
        return true
      end,
    }):find()
  else
    -- Fallback to vim.ui.select
    local items = vim.tbl_map(function(r)
      return string.format("[%s] %s", r.type, r.name)
    end, results)

    vim.ui.select(items, { prompt = "Dash Docs:" }, function(_, idx)
      if idx then
        local content, err = read_doc(resources_path, results[idx].path)
        if content then
          open_float(content, results[idx].name)
        else
          vim.notify(err, vim.log.levels.ERROR)
        end
      end
    end)
  end
end

-- Main search function
function M.search(query)
  query = query or vim.fn.input("Dash search: ")
  if query == "" then return end

  local ft = vim.bo.filetype
  local db_path, err = get_docset_db(ft)

  if not db_path then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  local results, query_err = query_docs(db_path, query)
  if not results then
    vim.notify(query_err, vim.log.levels.ERROR)
    return
  end

  if #results == 0 then
    vim.notify("No results found for: " .. query, vim.log.levels.WARN)
    return
  end

  show_results(results, db_path)
end

-- Search word under cursor
function M.search_word()
  local word = vim.fn.expand("<cword>")
  if word ~= "" then
    M.search(word)
  end
end

-- Setup function
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- Commands
  vim.api.nvim_create_user_command("DashSearch", function(args)
    M.search(args.args)
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("DashWord", function()
    M.search_word()
  end, {})
end

return M
