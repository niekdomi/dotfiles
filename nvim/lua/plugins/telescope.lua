local telescope = require("telescope")
local actions = require("telescope.actions")

local ignore_patterns = { "build/", "target/", "/node_modules/", "%.git/" }

telescope.setup({
    defaults = {
        vimgrep_arguments = {
            "rg",
            "--follow",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--fixed-strings",
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_config = {
            horizontal = {
                prompt_position = "top",
            },
        },
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        mappings = {
            i = {
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-j>"] = actions.move_selection_next,
                ["<esc>"] = actions.close,
            },
            n = {
                ["q"] = actions.close,
            },
        },
    },
    pickers = {
        find_files = {
            hidden = true,
            file_ignore_patterns = ignore_patterns,
            sorter = require("telescope.sorters").get_fuzzy_file(),
        },
        live_grep = {
            file_ignore_patterns = ignore_patterns,
            sorter = require("telescope.sorters").get_fuzzy_file(),
        },
    },
})
