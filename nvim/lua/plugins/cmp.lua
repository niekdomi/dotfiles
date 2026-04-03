require("blink.cmp").setup({
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = { border = "rounded" },
        },
        list = {
            selection = {
                preselect = false,
                auto_insert = true,
            },
        },
        menu = {
            border = "rounded",
            draw = {
                columns = {
                    { "label", "label_description", gap = 1 },
                    { "kind_icon", gap = 1, "kind" },
                },
            },
        },
    },
    fuzzy = { implementation = "lua" },
    keymap = {
        preset = "none",

        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<CR>"] = { "accept", "fallback" },

        ["<C-n>"] = { "show", "fallback" },
        ["<C-p>"] = { "show", "fallback" },

        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },

        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
    cmdline = {
        keymap = {
            preset = "inherit",
            ["<CR>"] = { "accept_and_enter", "fallback" },
        },
        completion = {
            menu = { auto_show = true },
            list = {
                selection = {
                    preselect = false,
                    auto_insert = true,
                },
            },
        },
    },
    signature = {
        enabled = true,
        window = { border = "rounded" },
    },
})
