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
		jsonc = { "prettierd" },
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
	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		vim.b.disable_autoformat = true -- Buffer-local
	else
		vim.g.disable_autoformat = true -- Global
	end
end, { desc = "Disable autoformat-on-save", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, { desc = "Re-enable autoformat-on-save" })

