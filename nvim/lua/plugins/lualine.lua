local function selectionCount()
	local mode = vim.api.nvim_get_mode().mode
	if not mode:find("[vV\22]") then
		return ""
	end

	local v_start = vim.fn.getpos("v")
	local v_end = vim.fn.getpos(".")
	local lines = math.abs(v_start[2] - v_end[2]) + 1

	-- If the linecount is greater than 2e+6 / 30 = ~67,000 lines, then don't show the count
	-- This prevents performance issues
	local MAX_CHARS = 2e6
	-- Assume 30 characters per line and set count limit to limit performance throttle
	if lines * 30 > MAX_CHARS then
		return lines .. " Ln : >" .. MAX_CHARS .. " C"
	end

	local region = vim.fn.getregion(v_start, v_end, { type = mode })
	local chars = 0
	for i, line in ipairs(region) do
		chars = chars + vim.fn.strchars(line)
		if (mode == "v" or mode == "V") and i < #region then
			chars = chars + 1
		end
		if chars > MAX_CHARS then
			return lines .. " Ln : >" .. MAX_CHARS .. " C"
		end
	end

	return lines .. " Ln : " .. chars .. " C"
end

-- Check if Codeium plugin is loaded, fallback if not
local function codeiumStatus()
	local ok, codeium = pcall(require, "codeium.virtual_text")
	if ok and codeium.status_string then
		return codeium.status_string()
	end
	return ""
end

-- Set up Codeium statusbar refresh
local ok, codeium = pcall(require, "codeium.virtual_text")
if ok and codeium.set_statusbar_refresh then
	codeium.set_statusbar_refresh(function()
		require("lualine").refresh()
	end)
end

require("lualine").setup({
	options = {
		theme = "auto",
		component_separators = "",
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "NvimTree" },
	},
	sections = {
		lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
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
			{ "location", separator = { right = "" }, left_padding = 2 },
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = { "filename" },
		lualine_c = {},
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
})

