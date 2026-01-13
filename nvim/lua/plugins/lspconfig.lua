require("mason-tool-installer").setup({
	ensure_installed = {
		"bashls",
		"clang-format",
		"clangd",
		-- "codebook",
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
		"pyright",
		"ruff",
		"shellcheck",
		"shfmt",
		"stylua",
		"texlab",
		"typescript-language-server",
		"yaml-language-server",
	},
})

vim.lsp.config.clangd = {
	cmd = {
		"/home/domi/Downloads/clangd_snapshot_20251221/bin/clangd",
	},
	filetypes = { "c", "cpp", "cuda" },
	root_markers = { ".clangd", ".git" },
	settings = {
		clangd = {
			InlayHints = {
				Enabled = true,
				BlockEnd = true,
				DeducedTypes = true,
				DefaultArguments = true,
				Designators = true,
				ParameterNames = true,
				TypeNameLimit = 0, -- No limit
			},
			Documentation = {
				CommentFormat = "Doxygen",
			},
		},
	},
}

vim.lsp.config.codebook = {
	cmd = { "codebook-lsp", "serve" },
	filetypes = {
		"c",
		"cpp",
		"cs",
		"css",
		"go",
		"haskell",
		"html",
		"java",
		"javascript",
		"javascriptreact",
		"lua",
		"markdown",
		"php",
		"python",
		"ruby",
		"rust",
		"toml",
		"tex",
		"text",
		"typescript",
		"typescriptreact",
	},
	root_markers = { ".git", "codebook.toml", ".codebook.toml" },
}

vim.lsp.config.gopls = {
	cmd = { "gopls" },
	filetypes = { "go" },
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

vim.lsp.config.lua_ls = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim", "require" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
}

vim.lsp.config.bashls = {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash" },
}

vim.lsp.config.cssls = {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	root_markers = { "package.json", ".git" },
	settings = {
		css = {
			validate = true,
		},
		scss = {
			validate = true,
		},
		less = {
			validate = true,
		},
	},
}

-- vim.lsp.config.eslint = {
-- 	cmd = { "vscode-eslint-language-server", "--stdio" },
-- 	filetypes = {
-- 		"javascript",
-- 		"javascriptreact",
-- 		"javascript.jsx",
-- 		"typescript",
-- 		"typescriptreact",
-- 		"typescript.tsx",
-- 		"vue",
-- 		"svelte",
-- 		"astro",
-- 	},
-- 	root_markers = {
-- 		"eslint.config.js",
-- 		"eslint.config.mjs",
-- 		"package.json",
-- 		".git",
-- 	},
-- }

-- -- Golangci-lint Language Server
-- vim.lsp.config.golangci_lint_ls = {
-- 	cmd = { "golangci-lint-langserver" },
-- 	filetypes = { "go", "gomod" },
-- 	root_markers = { "go.mod", ".git" },
-- 	command = {
-- 		"golangci-lint",
-- 		"run",
-- 		"--output.json.path=stdout",
-- 		"--issues-exit-code=1",
-- 		"--show-stats=false",
-- 		"--fix",
-- 		"--enable-only=wsl_v5",
-- 	},
-- }

-- HTML Language Server
vim.lsp.config.html = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	root_markers = { "package.json", ".git" },
	settings = {
		html = {
			format = {
				enable = true,
			},
			hover = {
				documentation = true,
				references = true,
			},
		},
	},
}

-- -- Neocmake Language Server
-- vim.lsp.config.neocmake = {
-- 	cmd = { "neocmakelsp", "--stdio" },
-- 	filetypes = { "cmake" },
-- 	root_markers = { "CMakePresets.json", "CTestConfig.cmake", ".git", "build", "cmake" },
-- 	init_options = {
-- 		format = {
-- 			enable = true,
-- 		},
-- 		scan_cmake_in_package = true,
-- 	},
-- }

vim.lsp.config.jsonls = {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
}

vim.lsp.config.pyright = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		".git",
	},
	settings = {
		-- python = {
		-- 	analysis = {
		-- 		autoSearchPaths = true,
		-- 		diagnosticMode = "workspace",
		-- 		useLibraryCodeForTypes = true,
		-- 		typeCheckingMode = "basic",
		-- 	},
		-- },
	},
}

-- Ruff Language Server
vim.lsp.config.ruff = {
	cmd = { "ruff", "server", "--preview" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
	init_options = {
		settings = {
			-- Additional ruff settings can go here
		},
	},
}

-- -- Rust Analyzer
-- vim.lsp.config.rust_analyzer = {
-- 	cmd = { "rust-analyzer" },
-- 	filetypes = { "rust" },
-- 	root_markers = { "Cargo.toml", "rust-project.json", ".git" },
-- 	settings = {
-- 		["rust-analyzer"] = {
-- 			cargo = {
-- 				allFeatures = true,
-- 				loadOutDirsFromCheck = true,
-- 			},
-- 			procMacro = {
-- 				enable = true,
-- 			},
-- 			checkOnSave = {
-- 				command = "clippy",
-- 			},
-- 		},
-- 	},
-- }

-- -- TypeScript Language Server
-- vim.lsp.config.ts_ls = {
-- 	cmd = { "typescript-language-server", "--stdio" },
-- 	filetypes = {
-- 		"javascript",
-- 		"javascriptreact",
-- 		"javascript.jsx",
-- 		"typescript",
-- 		"typescriptreact",
-- 		"typescript.tsx",
-- 	},
-- 	root_markers = { "tsconfig.json", "package.json", ".git" },
-- 	init_options = {
-- 		hostInfo = "neovim",
-- 	},
-- 	settings = {
-- 		typescript = {
-- 			inlayHints = {
-- 				includeInlayParameterNameHints = "all",
-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
-- 				includeInlayFunctionParameterTypeHints = true,
-- 				includeInlayVariableTypeHints = true,
-- 				includeInlayPropertyDeclarationTypeHints = true,
-- 				includeInlayFunctionLikeReturnTypeHints = true,
-- 				includeInlayEnumMemberValueHints = true,
-- 			},
-- 		},
-- 		javascript = {
-- 			inlayHints = {
-- 				includeInlayParameterNameHints = "all",
-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
-- 				includeInlayFunctionParameterTypeHints = true,
-- 				includeInlayVariableTypeHints = true,
-- 				includeInlayPropertyDeclarationTypeHints = true,
-- 				includeInlayFunctionLikeReturnTypeHints = true,
-- 				includeInlayEnumMemberValueHints = true,
-- 			},
-- 		},
-- 	},
-- }

vim.lsp.config.texlab = {
	cmd = { "texlab" },
	filetypes = { "tex", "plaintex", "bib" },
	root_markers = { ".git" },
}

vim.lsp.config.yamlls = {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
	root_markers = { ".git" },
	settings = {
		yaml = {
			schemas = {
				-- Kubernetes schemas
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0/all.json"] =
				"/*.k8s.yaml",
				-- Docker Compose
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
				"/*docker-compose*.{yml,yaml}",
				-- GitHub Workflows
				["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
				-- GitLab CI
				["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] =
				"*gitlab-ci*.{yml,yaml}",
			},
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},
			format = {
				enable = true,
				singleQuote = false,
				bracketSpacing = true,
			},
			validate = true,
			hover = true,
			completion = true,
			customTags = {
				-- Ansible tags
				"!vault",
				"!encrypted/pkcs1-oaep",
				-- CloudFormation tags
				"!Ref",
				"!Sub",
				"!GetAtt",
				"!Join",
			},
		},
	},
}

-----------------------------------------------------------
-- Diagnostic signs configuration
-----------------------------------------------------------
local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
local signConf = { text = {}, texthl = {}, numhl = {} }

for type, _ in pairs(signs) do
	local severityName = string.upper(type)
	local severity = vim.diagnostic.severity[severityName]
	local hl = "DiagnosticSign" .. type

	-- signConf.text[severity] = icon
	signConf.text[severity] = ""
	signConf.texthl[severity] = ""
	signConf.numhl[severity] = hl
end

-- LSP keybindings and configuration
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

		-- This disables the css color highlighting from the lsp,
		-- since the highlighting is handled by `nvim-highlight-colors`
		vim.lsp.document_color.enable(false)
	end,
})

vim.diagnostic.config({
	float = {
		border = "rounded",
		max_width = 70,
	},
	signs = signConf,
})

-----------------------------------------------------------
-- Diagnostic highlight configuration
-----------------------------------------------------------
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#E55353" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#E0B644" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#419BEF" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#49B675" })

-----------------------------------------------------------
-- Toggling virtual lines
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

-- Apply the initial configuration
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
