vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

vim.filetype.add({
    extension = {
        json = "jsonc",
    },
})

-- ╭──────────────────────────────────────────────────────────╮
-- │ Options                                                  │
-- ╰──────────────────────────────────────────────────────────╯
local o = vim.opt

o.clipboard = "unnamedplus"
-- o.cmdheight = 0
o.cursorline = true
o.expandtab = true
o.ignorecase = true
o.linebreak = true -- Break whole word
o.number = true
o.relativenumber = true
o.shiftwidth = 4
o.shortmess:append("I")
o.signcolumn = "yes"
o.smartcase = true
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.tabstop = 4
o.undofile = true
o.wrap = false

-- Mouse
o.mousemodel = "extend"
o.mouse = "a"

-- ╭──────────────────────────────────────────────────────────╮
-- │ Keymaps                                                  │
-- ╰──────────────────────────────────────────────────────────╯
local map = vim.keymap.set

-- Disable cutting
map("n", "x", "\"_x")
map("n", "X", "\"_X")

-- Editor / Editing
map("n", "<leader>nh", "<cmd>nohl<cr>")
map("n", "<leader>o", "o<Esc>")
map("n", "<leader>O", "O<Esc>")
map("n", "<leader>e", "<cmd>Yazi<cr>")
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>tw", "<cmd>set wrap!<cr>")
map("n", "#", "@@")
map({ "n", "v", "s", "x" }, "<leader>i", "~")

-- Telescope
map("n", "<leader>fC", "<cmd>Telescope git_conflict<cr>")
map("n", "<leader>fc", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fg", "<cmd>TodoTelescope<cr>")
map("n", "<leader>fm", "<cmd>Telescope marks<cr>")
map("n", "<leader>fr", "<cmd>Telescope registers<cr>")
map("n", "<leader>ft", "<cmd>Telescope colorscheme enable_preview=true<cr>")
map("n", "gO", "<cmd>Telescope lsp_document_symbols<cr>")

-- Exchange
map("n", "cx", function() require("substitute.exchange").operator() end)
map("n", "cxx", function() require("substitute.exchange").line() end)
map("x", "X", function() require("substitute.exchange").visual() end)

-- Clear registers
map("n", "cr", function()
    local regs = "abcdefghijklmnopqrstuvwxyz0123456789/-\"*+"
    for i = 1, #regs do
        local reg = regs:sub(i, i)
        vim.fn.setreg(reg, {})
    end
    print("All registers cleared!")
end)

-- LSP
map(
    "n",
    "<leader>tt",
    function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
    end
)

-- Git
map("n", "gl", "<cmd>LazyGit<cr>")
map("n", "gB", "<cmd>Gitsigns blame_line<cr>")

map("n", "gh", function()
    vim.cmd("Gitsigns toggle_word_diff")
    vim.cmd("Gitsigns toggle_deleted")
    vim.cmd("Gitsigns toggle_linehl")
end)

-- Dial (Enhanced increment/decrement)
map("n", "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end)
map("n", "<C-a>", function() require("dial.map").manipulate("increment", "normal") end)

-- ╭──────────────────────────────────────────────────────────╮
-- │ Plugins                                                  │
-- ╰──────────────────────────────────────────────────────────╯
vim.pack.add({
    -- Git
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/kdheepak/lazygit.nvim" },
    { src = "https://github.com/niekdomi/conflict.nvim" },

    -- LSP, Auto-completion & Formatter
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/RRethy/vim-illuminate" },
    { src = "https://github.com/saghen/blink.cmp" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/stevearc/dressing.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },

    -- Telescope
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-mini/mini.icons" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },

    -- Treesitter
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
    { src = "https://github.com/windwp/nvim-ts-autotag" },

    -- Others
    { src = "https://github.com/Exafunction/windsurf.nvim" },
    { src = "https://github.com/gbprod/substitute.nvim" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
    { src = "https://github.com/catppuccin/nvim" },
    { src = "https://github.com/folke/flash.nvim" },
    { src = "https://github.com/folke/todo-comments.nvim" },
    { src = "https://github.com/karb94/neoscroll.nvim" },
    { src = "https://github.com/kylechui/nvim-surround" },
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
    { src = "https://github.com/max397574/better-escape.nvim" },
    { src = "https://github.com/mikavilpas/yazi.nvim" },
    { src = "https://github.com/monaqa/dial.nvim" },
    { src = "https://github.com/numToStr/Comment.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/windwp/nvim-autopairs" },
})
-- ╭──────────────────────────────────────────────────────────╮
-- │ Configurations                                           │
-- ╰──────────────────────────────────────────────────────────╯
vim.cmd("colorscheme catppuccin-mocha")
require("theme")

require("plugins.cmp")
require("plugins.flash")
require("plugins.formatter")
require("plugins.lspconfig")
require("plugins.lualine")
require("plugins.scroll")
require("plugins.telescope")
require("plugins.treesitter")

require("better_escape").setup({
    mappings = {
        i = { j = { j = false, k = "<ESC>" } },
        t = { j = { false } }, --lazygit navigation fix
        v = { j = { k = false } }, -- visual select fix
        s = { j = { k = false } }, -- selection mode (snippets) fix
    },
})

-- Stub out "cmp" module for windsurf.nvim & dressing.nvim (expects nvim-cmp, but blink.cmp is used)
package.preload["cmp"] = function()
    local noop = function() end
    return {
        event = { on = noop },
        register_source = noop,
        setup = { buffer = noop },
    }
end

require("codeium").setup({
    enable_cmp_source = false,
    virtual_text = {
        enabled = true,
        default_filetype_enabled = true,
        idle_delay = 75,

        key_bindings = {
            accept = "<C-f>",
            accept_word = "<C- >",
            accept_line = false,
            clear = "<C-x>",
            next = "<C-.>",
            prev = "<C-,>",
        },
    },
})

require("Comment").setup()

require("conflict").setup({
    show_actions = false,
})

local augend = require("dial.augend")
require("dial.config").augends:register_group({
    default = {
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,
        augend.constant.alias.bool,
        augend.constant.new({
            elements = { "True", "False" },
            word = true,
            cyclic = true,
        }),
        augend.date.new({
            pattern = "%Y/%m/%d",
            default_kind = "day",
        }),
        augend.date.new({
            pattern = "%Y-%m-%d",
            default_kind = "day",
        }),
        augend.hexcolor.new({
            case = "prefer_upper",
        }),
    },
})

require("dressing").setup()

require("gitsigns").setup({
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
    },
    current_line_blame_formatter = "<author> - <summary>",
    preview_config = { border = "rounded" },
    gh = true,
})

require("ibl").setup({
    scope = { enabled = false },
})

require("illuminate").configure({
    filetypes_denylist = { "markdown" },
    modes_denylist = {
        "v",
        "V",
        "\22", -- Visual Block?!
    },
})

require("mason").setup()

require("mason-lspconfig").setup({
    automatic_enable = true,
})

require("mini.icons").setup({
    style = "glyph",
})
MiniIcons.mock_nvim_web_devicons()

require("nvim-autopairs").setup()

require("nvim-highlight-colors").setup({
    render = "virtual",
    virtual_symbol = " ⬤",
    virtual_symbol_position = "eow",
    enabled_tailwind = true,
})

require("nvim-surround").setup()

require("nvim-ts-autotag").setup({
    opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
    },
    per_filetype = {
        ["rust"] = { enable_close = false, enable_rename = false },
    },
})

require("render-markdown").setup({
    code = {
        border = "thin",
        sign = false,
        language = false,
    },
    heading = {
        sign = false,
        width = "block",
    },
})

require("substitute").setup({
    exchange = {
        preserve_cursor_position = true,
    },
})

require("todo-comments").setup({
    search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
    highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
})

require("yazi").setup({
    open_for_directories = true,
})
