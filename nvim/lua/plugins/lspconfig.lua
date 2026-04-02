require("mason-tool-installer").setup({
	ensure_installed = {
		"bashls",
		"clang-format",
		"clangd",
		"codebook",
		"css-lsp",
		"eslint-lsp",
		"gersemi",
		"golangci-lint-langserver",
		"gopls",
		"html-lsp",
		"json-lsp",
		"lua_ls",
		"neocmakelsp",
		"prettierd",
		"ruff",
		"rust_analyzer",
		"shellcheck",
		"shfmt",
		"stylua",
		"tinymist",
		"tombi",
		"ty",
		"typescript-language-server",
		"yaml-language-server",
	},
})

-----------------------------------------------------------
-- LSP server configurations
-----------------------------------------------------------

vim.lsp.config.bashls = {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh", "zsh" },
}

vim.lsp.config.codebook = {
	cmd = { "codebook-lsp", "serve" },
	root_markers = { "codebook.toml", ".git" },
}

vim.lsp.config.clangd = {
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
}

vim.lsp.config.cssls = {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
}

vim.lsp.config.eslint = {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
	root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "eslint.config.js", "eslint.config.mjs" },
	settings = {
		validate = "on",
		run = "onType",
		nodePath = "",
		experimental = {
			useFlatConfig = true,
		},
	},
	before_init = function(params, config)
		if params.rootPath then
			config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
				workingDirectory = { directory = params.rootPath },
			})
		end
	end,
}

vim.lsp.config.golangci_lint_ls = {
	cmd = { "golangci-lint-langserver" },
	filetypes = { "go", "gomod" },
	root_markers = { ".golangci.yml", ".golangci.yaml", "go.mod", ".git" },
}

vim.lsp.config.gopls = {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
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
}

vim.lsp.config.html = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
}

vim.lsp.config.jsonls = {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
}

vim.lsp.config.lua_ls = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim", "require" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
		},
	},
}

vim.lsp.config.ruff = {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
}

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

vim.lsp.config.rust_analyzer = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git" },
}

vim.lsp.config.svelte = {
	cmd = { "svelteserver", "--stdio" },
	filetypes = { "svelte" },
	root_markers = { "package.json", ".git" },
}

vim.lsp.config.tinymist = {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	root_markers = { ".git" },
	settings = {
		formatterMode = "typstyle",
		formatterPrintWidth = 80,
		formatterProseWrap = true,
	},
}

vim.lsp.config.tombi = {
	cmd = { "tombi", "lsp" },
	filetypes = { "toml" },
}

vim.lsp.config.ts_ls = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
}

vim.lsp.config.ty = {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", ".git" },
}

vim.lsp.config.yamlls = {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose" },
}

-----------------------------------------------------------
-- Diagnostic signs
-----------------------------------------------------------
local sign_numhl = {}
for _, type in ipairs({ "Error", "Warn", "Hint", "Info" }) do
	sign_numhl[vim.diagnostic.severity[string.upper(type)]] = "DiagnosticSign" .. type
end

-----------------------------------------------------------
-- LSP keybindings
-----------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local opts = { buffer = bufnr, silent = true }
		local keymap = vim.keymap

		opts.desc = "Show references"
		keymap.set("n", "grr", "<cmd>Telescope lsp_references<CR>", opts)

		opts.desc = "Go definition"
		keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

		opts.desc = "Go definition in new tab"
		keymap.set("n", "gD", "<cmd>tab split | Telescope lsp_definitions<CR>", opts)

		opts.desc = "Show diagnostics"
		keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics<CR>", opts)

		opts.desc = "Go to previous diagnostic"
		keymap.set("n", "<leader>dp", function()
			vim.diagnostic.jump({ count = -1, float = false })
		end, opts)

		opts.desc = "Go to next diagnostic"
		keymap.set("n", "<leader>dn", function()
			vim.diagnostic.jump({ count = 1, float = false })
		end, opts)

		opts.desc = "Show documentation"
		keymap.set("n", "K", function()
			vim.lsp.buf.hover({ border = "rounded", max_width = 70 })
		end, opts)

		-- Disable LSP color highlighting (handled by nvim-highlight-colors)
		vim.lsp.document_color.enable(false)
	end,
})

-----------------------------------------------------------
-- Diagnostic configuration
-----------------------------------------------------------
vim.diagnostic.config({
	float = { border = "rounded", max_width = 70 },
	signs = { text = {}, texthl = {}, numhl = sign_numhl },
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#E55353" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#E0B644" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#419BEF" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#49B675" })

-----------------------------------------------------------
-- Diagnostic toggle
-----------------------------------------------------------
local diagnostic_states = { enabled = true, inline = true }

local diagnostic_configs = {
	inline = { virtual_text = { prefix = "●" }, virtual_lines = false },
	detailed = { virtual_text = false, virtual_lines = true },
	disabled = { virtual_text = false, virtual_lines = false },
}

local function get_active_config()
	if not diagnostic_states.enabled then
		return diagnostic_configs.disabled
	end
	return diagnostic_states.inline and diagnostic_configs.inline or diagnostic_configs.detailed
end

vim.diagnostic.config(get_active_config())

vim.keymap.set("n", "<Leader>tl", function()
	if diagnostic_states.enabled then
		diagnostic_states.inline = not diagnostic_states.inline
		vim.diagnostic.config(get_active_config())
	end
end, { desc = "Toggle detailed diagnostics" })

vim.keymap.set("n", "<Leader>td", function()
	diagnostic_states.enabled = not diagnostic_states.enabled
	vim.diagnostic.config(get_active_config())
end, { desc = "Toggle diagnostics" })
