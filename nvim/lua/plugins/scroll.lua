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

    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = true,
    cursor_scrolls_alone = false,
    easing = "linear",
    pre_hook = nil,
    post_hook = nil,
    performance_mode = false,
    ignored_events = { "WinScrolled", "CursorMoved" },
})

local keymap = {
    ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 250 }) end,
    ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 250 }) end,
    ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 200 }) end,
    ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 200 }) end,
    ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor = true, duration = 10 }) end,
    ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor = true, duration = 10 }) end,
    ["zt"] = function() neoscroll.zt({ half_win_duration = 200 }) end,
    ["z+"] = function() neoscroll.zt({ half_win_duration = 200 }) end,
    ["zz"] = function() neoscroll.zz({ half_win_duration = 200 }) end,
    ["zb"] = function() neoscroll.zb({ half_win_duration = 200 }) end,
    ["z-"] = function() neoscroll.zb({ half_win_duration = 200 }) end,
}

local modes = { "n", "v", "x" }
for key, func in pairs(keymap) do
    vim.keymap.set(modes, key, func)
end
