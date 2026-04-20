-- Register Metal filetype for clangd
vim.filetype.add({
  extension = {
    metal = "metal",
  },
})

require("nvchad.configs.lspconfig").defaults()
local lspconfig = require "lspconfig"
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Simple servers using new vim.lsp.enable API
local simple_servers = { "html", "cssls" }
vim.lsp.enable(simple_servers)

local default_opts = {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

local function setup(server, opts)
  local ok, config = pcall(function()
    return lspconfig[server]
  end)

  if ok and config and type(config.setup) == "function" then
    config.setup(vim.tbl_deep_extend("force", default_opts, opts or {}))
  else
    vim.notify("LSP server not available: " .. server, vim.log.levels.WARN)
  end
end

-- TypeScript/JavaScript
local known_configs = require "lspconfig.configs"
if known_configs.ts_ls then
  setup("ts_ls", {
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  })
else
  setup "tsserver"
end

-- ESLint
setup("eslint", {
  root_dir = lspconfig.util.root_pattern(
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.json",
    "eslint.config.js",
    "eslint.config.mjs"
  ),
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  settings = {
    workingDirectory = { mode = "auto" },
  },
})

setup("tailwindcss", {
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

-- Python (pyright)
setup "pyright"

-- LaTeX (texlab)
setup("texlab", {
  filetypes = { "tex", "latex", "bib" },
  settings = {
    texlab = {
      build = {
        executable = "latexmk",
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        onSave = true,
      },
      forwardSearch = {
        executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
        args = { "%l", "%p", "%f" },
      },
      chktex = {
        onOpenAndSave = true,
      },
    },
  },
})


-- Swift (sourcekit-lsp)
lspconfig.sourcekit.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "/usr/bin/sourcekit-lsp" },
  root_dir = function(filename)
    local util = lspconfig.util
    -- Prioritize buildServer.json for Xcode projects
    return util.root_pattern("buildServer.json", "Package.swift")(filename)
      or util.find_git_ancestor(filename)
      or util.search_ancestors(filename, function(path)
        if vim.fn.glob(path .. "/*.xcodeproj") ~= "" or vim.fn.glob(path .. "/*.xcworkspace") ~= "" then
          return path
        end
      end)
  end,
  filetypes = { "swift" },
}

-- Metal/C++ (clangd)
setup("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders=false",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "metal" },
  root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".clangd", ".git"),
  init_options = {
    fallbackFlags = {
      "-std=c++14",
      "-xc++",
      "-I/Users/montrellpegues/Downloads/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/include",
      "-I/Users/montrellpegues/Downloads/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1",
      "-I/Users/montrellpegues/Downloads/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/21/include",
      "-I/Users/montrellpegues/Downloads/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/Metal.framework/Headers",
      "-Wno-unknown-attributes",
      "-Wno-c++17-extensions",
    },
  },
})

-- F# (fsautocomplete)
setup("fsautocomplete", {
  cmd = { "fsautocomplete", "--adaptive-lsp-server-enabled" },
  root_dir = lspconfig.util.root_pattern("*.sln", "*.fsproj", ".git"),
  filetypes = { "fsharp" },
  init_options = {
    AutomaticWorkspaceInit = true,
  },
  settings = {
    FSharp = {
      keywordsAutocomplete = true,
      ExternalAutocomplete = false,
      Linter = true,
      UnionCaseStubGeneration = true,
      UnionCaseStubGenerationBody = 'failwith "Not Implemented"',
      RecordStubGeneration = true,
      RecordStubGenerationBody = 'failwith "Not Implemented"',
      InterfaceStubGeneration = true,
      InterfaceStubGenerationObjectIdentifier = "this",
      InterfaceStubGenerationMethodBody = 'failwith "Not Implemented"',
      UnusedOpensAnalyzer = true,
      UnusedDeclarationsAnalyzer = true,
      SimplifyNameAnalyzer = true,
      ResolveNamespaces = true,
      EnableReferenceCodeLens = true,
    },
  },
})

-- Metal LSP (metal-lsp)
local configs = require "lspconfig.configs"
if not configs.metal_lsp then
  configs.metal_lsp = {
    default_config = {
      cmd = { "/Users/montrellpegues/metal-lsp/.build/release/metal-lsp" },
      filetypes = { "metal" },
      root_dir = lspconfig.util.root_pattern(".git", "Package.swift"),
      settings = {},
    },
  }
end

lspconfig.metal_lsp.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}
