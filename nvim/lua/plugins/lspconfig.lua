require("mason-tool-installer").setup({
    ensure_installed = {
        "bash-language-server",
        "clang-format",
        "clangd",
        "codebook",
        "css-lsp",
        "emmylua_ls",
        "golangci-lint-langserver",
        "gopls",
        "html-lsp",
        "json-lsp",
        "neocmakelsp",
        "prettierd",
        "ruff",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "stylua",
        "tinymist",
        "tombi",
        "ty",
        "vtsls",
        "yaml-language-server",
    },
})

--------------------------------------------------------------------------------
-- LSP server configurations
--------------------------------------------------------------------------------

-- NOTE: All servers must be added to the list to enable them
vim.lsp.enable({
    "bashls",
    "clangd",
    -- "codebook",
    "cssls",
    "emmylua_ls",
    "golangci_lint_ls",
    "gopls",
    "html",
    "jsonls",
    "neocmake",
    "ruff",
    "rust_analyzer",
    "svelte",
    "tinymist",
    "tombi",
    "ts_ls",
    "ty",
    "yamlls",
    "zls",
})

vim.lsp.config("bashls", {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh" },
})

vim.lsp.config("codebook", {
    cmd = { "codebook-lsp", "serve" },
    root_markers = { "codebook.toml", ".codebook.toml", ".git" },
})

vim.lsp.config("clangd", {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "cppm", "cuda", "cxx" },
    root_markers = { ".clangd", ".git" },
    settings = {
        clangd = {
            InlayHints = {
                BlockEnd = true,
                DeducedTypes = true,
                DefaultArguments = true,
                Designators = true,
                Enabled = true,
                ParameterNames = true,
                TypeNameLimit = 0,
            },
        },
    },
})

vim.lsp.config("cssls", {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
})

vim.lsp.config("emmylua_ls", {
    cmd = { "emmylua_ls" },
    filetypes = { "lua" },
    root_markers = { ".emmyrc.json", ".luarc.json", ".git", ".stylua.toml", "stylua.toml" },
    settings = {
        emmylua = {
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        },
    },
})

vim.lsp.config("golangci_lint_ls", {
    cmd = { "golangci-lint-langserver" },
    filetypes = { "go", "gomod" },
    root_markers = { ".golangci.yml", ".golangci.yaml", "go.mod", ".git" },
    init_options = {
        command = {
            "golangci-lint",
            "run",
            "--output.json.path=stdout",
            "--show-stats=false",
            "--issues-exit-code=1",
        },
    },
})

vim.lsp.config("gopls", {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork" },
    root_markers = { "go.mod", ".git" },
    settings = {
        gopls = {
            analyses = { unusedparams = true },
            gofumpt = true,
            hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = true,
                functionTypeParameters = true,
                ignoredError = false,
                parameterNames = true,
                rangeVariableTypes = true,
            },
            staticcheck = true,
            usePlaceholders = true,
        },
    },
})

vim.lsp.config("html", {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
})

vim.lsp.config("jsonls", {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
})

vim.lsp.config("ruff", {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
})

vim.lsp.config("neocmake", {
    cmd = { "neocmakelsp", "stdio" },
    filetypes = { "cmake" },
    root_markers = { "CMakeLists.txt", ".git" },
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        if vim.g.disable_autoformat or vim.b[vim.api.nvim_get_current_buf()].disable_autoformat then
            return
        end

        vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports.ruff" }, diagnostics = {} },
            apply = true,
        })

        vim.lsp.buf.code_action({
            context = { only = { "source.fixAll.ruff" }, diagnostics = {} },
            apply = true,
        })
    end,
})

vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", ".git" },
})

vim.lsp.config("svelte", {
    cmd = { "svelteserver", "--stdio" },
    filetypes = { "svelte" },
    root_markers = { "package.json", ".git" },
})

vim.lsp.config("tinymist", {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    root_markers = { ".git" },
    settings = {
        formatterMode = "typstyle",
        formatterPrintWidth = 80,
        formatterProseWrap = true,
    },
})

vim.lsp.config("tombi", {
    cmd = { "tombi", "lsp" },
    filetypes = { "toml" },
})

vim.lsp.config("ts_ls", {
    cmd = { "vtsls", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    settings = {
        typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = {
                parameterNames = { enabled = "all" },
                parameterName = { enabled = true },
                functionParameterType = { enabled = true },
                variableType = { enabled = true },
                variableTypeHintsWhenTypeMatchesName = { enabled = true },
                propertyDeclarationType = { enabled = true },
                functionLikeReturnType = { enabled = true },
                enumMemberValue = { enabled = true },
            },
        },
    },
})

vim.lsp.config("ty", {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", ".git" },
})

vim.lsp.config("yamlls", {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yaml.docker-compose" },
    settings = {
        yaml = {
            schemaStore = {
                enable = false,
                url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
        },
    },
})

vim.lsp.config("zls", {
    cmd = { "zls" },
    filetypes = { "zig" },
})

--------------------------------------------------------------------------------
-- LSP keybindings
--------------------------------------------------------------------------------

local float_opts = { border = "rounded", max_width = 70 }

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
        end

        -- stylua: ignore start
        map("n", "grr", "<cmd>Telescope lsp_references<CR>", "Show references")
        map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Go definition")
        map("n", "gD", "<cmd>tab split | Telescope lsp_definitions<CR>", "Definition in tab")
        map("n", "<leader>D", "<cmd>Telescope diagnostics<CR>", "Show diagnostics")
        map( "n", "<leader>dp", function() vim.diagnostic.jump({ count = -1, float = false }) end, "Prev diagnostic")
        map( "n", "<leader>dn", function() vim.diagnostic.jump({ count = 1, float = false }) end, "Next diagnostic")
        map("n", "K", function() vim.lsp.buf.hover(float_opts) end, "Show documentation")
        map("i", "<C-s>", function() vim.lsp.buf.signature_help(float_opts) end, "Signature help")
        -- stylua: ignore end

        vim.lsp.document_color.enable(true, { bufnr = args.buf }, { style = "virtual" })
    end,
})

--------------------------------------------------------------------------------
-- Diagnostic configuration & Toggle Logic
--------------------------------------------------------------------------------
local icons = {
    [vim.diagnostic.severity.ERROR] = "󰅚 ",
    [vim.diagnostic.severity.WARN] = "󰀪 ",
    [vim.diagnostic.severity.HINT] = "󰌶 ",
    [vim.diagnostic.severity.INFO] = "󱩎 ",
}

local function set_diagnostic_highlights()
    -- Get the foreground color from the standard diagnostic groups
    local err_fg = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg
    local warn_fg = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg
    local hint_fg = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" }).fg
    local info_fg = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }).fg

    -- Apply the color specifically to the special color (sp) attribute of the curl
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = err_fg })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = warn_fg })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = hint_fg })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = info_fg })
end

local state = { enabled = true, detailed = false }

local function apply_diagnostics()
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.diagnostic.config({
        virtual_text = state.enabled and not state.detailed and {
            prefix = "●",
            severity = { min = vim.diagnostic.severity.WARN },
        } or false,

        virtual_lines = state.enabled and state.detailed and {
            severity = { min = vim.diagnostic.severity.WARN },
        } or false,

        signs = state.enabled and { text = icons } or false,

        float = float_opts,
    })
end

-- Toggle bindings
vim.keymap.set("n", "<Leader>tl", function()
    state.detailed = not state.detailed
    apply_diagnostics()
end, { desc = "Toggle detailed diagnostics" })

vim.keymap.set("n", "<Leader>td", function()
    state.enabled = not state.enabled
    apply_diagnostics()
end, { desc = "Toggle diagnostics" })

-- Initial Load
apply_diagnostics()
set_diagnostic_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_diagnostic_highlights,
})
