--------------------------------------------------------------------------------
-- Selection Count
--------------------------------------------------------------------------------
local function selectionCount()
    local mode = vim.api.nvim_get_mode().mode
    if not mode:find("[vV\22]") then
        return ""
    end

    local anchor_line = vim.fn.line("v")
    local anchor_col = vim.fn.col("v")
    local cursor_line = vim.fn.line(".")
    local cursor_col = vim.fn.col(".")

    local start_line = math.min(anchor_line, cursor_line)
    local end_line = math.max(anchor_line, cursor_line)
    local line_count = end_line - start_line + 1

    local char_count
    if mode == "V" then -- Visual line
        local start_byte = vim.fn.line2byte(start_line)
        local end_byte = vim.fn.line2byte(end_line + 1)
        char_count = end_byte - start_byte
    elseif mode == "\22" then -- Visual block
        local start_col = math.min(anchor_col, cursor_col)
        local end_col = math.max(anchor_col, cursor_col)
        char_count = (end_col - start_col + 1) * line_count
    else
        local start_byte = vim.fn.line2byte(anchor_line) + anchor_col - 1
        local end_byte = vim.fn.line2byte(cursor_line) + cursor_col - 1
        if start_byte > end_byte then
            start_byte, end_byte = end_byte, start_byte
        end
        char_count = end_byte - start_byte + 1
    end

    return string.format("%dLn : %dC", line_count, char_count)
end

--------------------------------------------------------------------------------
-- Codeium Status & Refresh
--------------------------------------------------------------------------------
local ok_codeium, codeium = pcall(require, "codeium.virtual_text")

-- Check if Codeium plugin is loaded, fallback if not
local function codeiumStatus()
    if ok_codeium and codeium.status_string then
        return codeium.status_string()
    end
    return ""
end

-- Set up Codeium statusbar refresh
if ok_codeium and codeium.set_statusbar_refresh then
    codeium.set_statusbar_refresh(function()
        local ok_lualine, lualine = pcall(require, "lualine")
        if ok_lualine then
            lualine.refresh()
        end
    end)
end

--------------------------------------------------------------------------------
-- Lualine
--------------------------------------------------------------------------------
require("lualine").setup({
    options = {
        theme = "auto",
        component_separators = "",
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "NvimTree" },
    },
    sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_b = { "filename", "branch", "diagnostics" },
        lualine_c = { "lsp_status" },
        lualine_x = {},
        lualine_y = {
            codeiumStatus,
            "filetype",
            "fileformat",
            "progress",
        },
        lualine_z = {
            { selectionCount },
            { "location", separator = { right = "" }, left_padding = 2 },
        },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = { "filename" },
        lualine_c = {
            function()
                local width = vim.fn.winwidth(0)
                local filenamestr = vim.fn.expand("%:t")
                local filename_len = filenamestr ~= "" and #filenamestr or 9
                local location_len = #tostring(vim.fn.line("."))
                local modified_len = vim.bo.modified and 4 or 0

                return string.rep("-", width - (filename_len + location_len + modified_len + 11))
            end,
        },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
})
