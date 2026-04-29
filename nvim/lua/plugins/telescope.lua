local telescope = require("telescope")
local actions = require("telescope.actions")

local ignore_patterns = { "build/", "target/", "/node_modules/", "%.git/" }

telescope.setup({
    defaults = {
        vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
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
        },
        live_grep = {
            file_ignore_patterns = ignore_patterns,
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
})
