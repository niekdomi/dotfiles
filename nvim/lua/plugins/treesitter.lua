local ts = require("nvim-treesitter")

--------------------------------------------------------------------------------
-- Auto-install & Start
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
        pcall(ts.install, lang)

        -- Disable for files over 1MB
        local ok, stats = pcall(vim.uv.fs_stat, ev.file)
        if ok and stats and stats.size > 1024 * 1024 then
            return
        end

        pcall(vim.treesitter.start)
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

--------------------------------------------------------------------------------
-- Treesitter Textobjects
--------------------------------------------------------------------------------
local select = require("nvim-treesitter-textobjects.select")

local function map_select(key, query, desc)
    vim.keymap.set(
        { "x", "o" },
        key,
        function() select.select_textobject(query, "textobjects") end,
        { desc = desc }
    )
end

map_select("ai", "@conditional.outer", "Select outer conditional")
map_select("ii", "@conditional.inner", "Select inner conditional")
map_select("al", "@loop.outer", "Select outer loop")
map_select("il", "@loop.inner", "Select inner loop")
map_select("af", "@function.outer", "Select outer function")
map_select("if", "@function.inner", "Select inner function")
map_select("ac", "@class.outer", "Select outer class")
map_select("ic", "@class.inner", "Select inner class")
