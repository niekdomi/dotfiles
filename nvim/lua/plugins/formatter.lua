require("conform").setup({
	formatters_by_ft = {
		bash = { "shfmt" },
		c = { "clang_format" },
		cmake = { "gersemi" },
		cpp = { "clang_format" },
		cs = { "csharpier" },
		css = { "prettierd" },
		go = { "gopls" },
		html = { "prettierd" },
		javascript = { "prettierd" },
		json = { "prettierd" },
		lua = { "stylua" },
		markdown = { "prettierd" },
		python = { "ruff_format", "ruff_organize_imports" },
		rust = { "rustfmt" },
		svelte = { "prettierd" },
		tex = { "latexindent" },
		typescript = { "prettierd" },
		yaml = { "prettierd" },
	},
	formatters = {
		latexindent = {
			-- install latexindent from package manager:
			-- texlive-binextra perl-yaml-tiny perl-file-homedir
			command = "latexindent",
			args = function()
				local yaml_file = vim.fn.getcwd() .. "/.latexindent.yaml"
				if vim.fn.filereadable(yaml_file) == 1 then
					return { "-m", "-rv", "-l" }
				else
					return { "-m", '-y=defaultIndent:"\t",noAdditionalIndent:multicols:1' }
				end
			end,
		},
		ruff = {
			args = {
				"-c",
				"ruff\
				check\
				--select=I\
				--fix\
				--stdin-filename\
				{buffer_path}\
				| ruff format\
				--stdin-filename\
				{buffer_path}",
			},
		},
		gersemi = {
			command = "gersemi",
			args = {
				"--list-expansion=favour-expansion",
				"--no-warn-about-unknown-commands",
				"-", -- stdin
			},
		},
	},
	format_after_save = {
		lsp_fallback = true,
	},
})
