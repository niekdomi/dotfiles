local ts = require("nvim-treesitter")

-- Auto-install parsers on demand and enable treesitter highlighting
vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
		if not vim.tbl_contains(ts.get_installed(), lang) and vim.tbl_contains(ts.get_available(), lang) then
			ts.install(lang)
		end

		-- Disable treesitter for files over 1MB
		local max_filesize = 1000 * 1024
		local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
		if ok and stats and stats.size > max_filesize then
			return
		end

		pcall(vim.treesitter.start)
		vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- Textobjects
require("nvim-treesitter-textobjects").setup({
	select = {
		enable = true,
		lookahead = true,

		keymaps = {
			["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
			["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

			["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
			["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

			["af"] = { query = "@function.outer", desc = "Select outer part of a function" },
			["if"] = { query = "@function.inner", desc = "Select inner part of a function" },

			["aF"] = { query = "@frame.outer", desc = "Select outer part of a frame" },
			["iF"] = { query = "@frame.inner", desc = "Select inner part of a frame" },

			["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
			["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
		},
	},
	move = {
		enable = true,
		set_jumps = true,

		goto_next_start = {
			["]f"] = { query = "@call.outer", desc = "Next function call start" },
			["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
			["]c"] = { query = "@class.outer", desc = "Next class start" },
			["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
			["]l"] = { query = "@loop.outer", desc = "Next loop start" },

			["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
			["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
		},
		goto_next_end = {
			["]F"] = { query = "@call.outer", desc = "Next function call end" },
			["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
			["]C"] = { query = "@class.outer", desc = "Next class end" },
			["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
			["]L"] = { query = "@loop.outer", desc = "Next loop end" },
		},
		goto_previous_start = {
			["[f"] = { query = "@call.outer", desc = "Prev function call start" },
			["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
			["[c"] = { query = "@class.outer", desc = "Prev class start" },
			["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
			["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
		},
		goto_previous_end = {
			["[F"] = { query = "@call.outer", desc = "Prev function call end" },
			["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
			["[C"] = { query = "@class.outer", desc = "Prev class end" },
			["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
			["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
		},
	},
})

