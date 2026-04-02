require("flash").setup({
	jump = {
		autojump = false,
	},
	label = {
		uppercase = false,
	},
	highlight = {
		backdrop = false,
	},
	modes = {
		char = {
			enabled = false,
		},
	},
	prompt = {
		enabled = false,
	},
})

vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#e24efc", bold = true })

vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })

