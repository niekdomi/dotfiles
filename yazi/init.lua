-- Custom Git signs
th.git = th.git or {}
th.git.deleted = ui.Style():fg("red"):bold()

th.git = th.git or {}
th.git.modified_sign = "M"
th.git.deleted_sign = "D"

-- Plugins
require("bookmarks"):setup({
	last_directory = { enable = false, persist = false, mode = "dir" },
	persist = "vim",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = true,
	notify = {
		enable = false,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})
require("full-border"):setup({ type = ui.Border.ROUNDED })
require("git"):setup()
require("relative-motions"):setup({
	show_numbers = "relative_absolute",
	show_motion = true,
	line_numbers_styles = {
		hovered = ui.Style():bold():reverse(true),
	},
})
require("starship"):setup({})
require("searchjump"):setup({
	unmatch_fg = "#cdd6f4",
	match_str_fg = "#cdd6f4",
	match_str_bg = "#1e1e2e",
	first_match_str_fg = "#89b4fa",
	first_match_str_bg = "#1e1e2e",
	label_fg = "#f38ba8",
	label_bg = "#1e1e2e",
	only_current = false,
	show_search_in_statusbar = false,
	auto_exit_when_unmatch = true,
	enable_capital_label = false,
})
require("zoxide"):setup({ update_db = true })

Linemode = Linemode or {}

function Linemode:rtime()
	local mtime = math.floor(self._file.cha.mtime or 0)
	if mtime == 0 then
		return "  --"
	end

	local now = os.time()
	local now_t = os.date("*t", now) --[[@as osdate]]
	local mtime_t = os.date("*t", mtime) --[[@as osdate]]

	local today_start_t = {
		year = now_t.year,
		month = now_t.month,
		day = now_t.day,
		hour = 0,
		min = 0,
		sec = 0,
	}
	local today_start = os.time(today_start_t)
	local yesterday_start = today_start - 86400

	local time_str = os.date("%H:%M", mtime) --[[@as string]]

	if mtime >= today_start then
		return string.format("  Today %s", time_str)
	elseif mtime >= yesterday_start then
		return string.format("  Yesterday %s", time_str)
	elseif now_t.year == mtime_t.year then
		local formatted = os.date("%d %b %H:%M", mtime) --[[@as string]]
		local result = string.gsub(formatted, "^0(%d)", "%1")
		if tonumber(result:match("^%d+")) <= 9 then
			return "   " .. result
		end
		return "  " .. result
	else
		local formatted = os.date("%d %b %Y", mtime) --[[@as string]]
		local result = string.gsub(formatted, "^0(%d)", "%1")
		if tonumber(result:match("^%d+")) <= 9 then
			return "   " .. result
		end
		return "  " .. result
	end
end
