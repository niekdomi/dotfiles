local neoscroll = require("neoscroll")

neoscroll.setup({
	mappings = {
		"<C-u>",
		"<C-d>",
		"<C-b>",
		"<C-f>",
		"<C-y>",
		"<C-e>",
		"zt",
		"zz",
		"zb",
	},

	-- Hide cursor while scrolling
	hide_cursor = true,

	-- Stop at <EOF> when scrolling downwards
	stop_eof = true,

	-- Stop scrolling when the cursor reaches the scrolloff margin of the file
	respect_scrolloff = true,

	-- The cursor will keep on scrolling even if the window cannot scroll further
	cursor_scrolls_alone = false,

	-- Default easing function
	easing = "linear",

	-- Function to run before the scrolling animation starts
	pre_hook = nil,

	-- Function to run after the scrolling animation ends
	post_hook = nil,

	-- Disable "Performance Mode" on all buffers. (will disable treesitter while scrollling)
	performance_mode = false,

	ignored_events = { -- Events ignored while scrolling
		"WinScrolled",
		"CursorMoved",
	},
})

local keymap = {
	["<C-u>"] = function()
		neoscroll.ctrl_u({ duration = 250 })
	end,
	["<C-d>"] = function()
		neoscroll.ctrl_d({ duration = 250 })
	end,
	["<C-b>"] = function()
		neoscroll.ctrl_b({ duration = 200 })
	end,
	["<C-f>"] = function()
		neoscroll.ctrl_f({ duration = 200 })
	end,
	["<C-y>"] = function()
		neoscroll.scroll(-0.1, { move_cursor = true, duration = 10 })
	end,
	["<C-e>"] = function()
		neoscroll.scroll(0.1, { move_cursor = true, duration = 10 })
	end,
	["zt"] = function()
		neoscroll.zt({ half_win_duration = 200 })
	end,
	["z+"] = function()
		neoscroll.zt({ half_win_duration = 200 })
	end,
	["zz"] = function()
		neoscroll.zz({ half_win_duration = 200 })
	end,
	["zb"] = function()
		neoscroll.zb({ half_win_duration = 200 })
	end,
	["z-"] = function()
		neoscroll.zb({ half_win_duration = 200 })
	end,
}

local modes = { "n", "v", "x" }
for key, func in pairs(keymap) do
	vim.keymap.set(modes, key, func)
end

