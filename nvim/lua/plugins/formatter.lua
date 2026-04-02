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
		python = { lsp_format = "prefer" },
		rust = { "rustfmt" },
		svelte = { "prettierd" },
		toml = { "tombi" },
		typescript = { "prettierd" },
		typst = { lsp_format = "prefer" },
		yaml = { "prettierd" },
	},
	formatters = {
		gersemi = {
			prepend_args = {
				"--list-expansion=favour-expansion",
				"--no-warn-about-unknown-commands",
			},
		},
	},
	format_on_save = function(bufnr)
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

