local dap = require("dap")

-- ============================================================================
-- SIGNS
-- ============================================================================
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticInfo", linehl = "CursorLine", numhl = "" })


-- ============================================================================
-- KEYBINDINGS
-- ============================================================================
vim.keymap.set("n", "<F5>", function() require("dap").continue() end, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<F10>", function() require("dap").step_into() end, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F11>", function() require("dap").step_over() end, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F12>", function() require("dap").step_out() end, { desc = "Debug: Step Out" })

-- Helper function to set/edit breakpoints
local function set_breakpoint_with_edit(prompt, bp_type)
	local bufnr = vim.api.nvim_get_current_buf()
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local breakpoints = require("dap.breakpoints").get(bufnr)[bufnr] or {}

	-- Find existing breakpoint on current line
	local existing_value = ""
	for _, bp in ipairs(breakpoints) do
		if bp.line == line then
			if bp_type == "condition" then
				existing_value = bp.condition or ""
			elseif bp_type == "hitCondition" then
				existing_value = bp.hitCondition or ""
			elseif bp_type == "logMessage" then
				existing_value = bp.logMessage or ""
			end
			break
		end
	end

	-- Prompt with existing value as default
	local value = vim.fn.input({
		prompt = prompt,
		default = existing_value,
	})

	if value and value ~= "" then
		if bp_type == "condition" then
			require("dap").set_breakpoint(value, nil, nil)
		elseif bp_type == "hitCondition" then
			require("dap").set_breakpoint(nil, value, nil)
		elseif bp_type == "logMessage" then
			require("dap").set_breakpoint(nil, nil, value)
		end
	end
end

vim.keymap.set("n", "<F6>", function() set_breakpoint_with_edit("Breakpoint condition: ", "condition") end)
vim.keymap.set("n", "<F7>", function() set_breakpoint_with_edit("Hit count: ", "hitCondition") end)

-- ============================================================================
-- LLDB Adapter
-- ============================================================================
dap.adapters.lldb = {
	type = "executable",
	command = "lldb-dap",
	name = "lldb",
}

-- ============================================================================
-- C++ Configurations
-- ============================================================================
dap.configurations.cpp = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
	},
}

-- C Configurations (reuse C++)
dap.configurations.c = dap.configurations.cpp

-- ============================================================================
-- Virtual Text (shows variable values inline)
-- ============================================================================
require("nvim-dap-virtual-text").setup({
	enabled = true,
	enabled_commands = true,
	highlight_changed_variables = true,
	highlight_new_as_changed = true,
	show_stop_reason = true,
	commented = false,
	only_first_definition = true,
	all_references = false,
	virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
})

-- ============================================================================
-- DAP View (nice UI for debugging)
-- ============================================================================
require("dap-view").setup({
	auto_toggle = true, -- Auto open/close when session starts/ends
	follow_tab = true, -- Follow when switching tabs
	winbar = {
		show = true,
		sections = { "watches", "scopes", "breakpoints", "threads", "repl" },
		default_section = "scopes",
		controls = {
			enabled = true,
			position = "right",
			buttons = {
				"play",
				"step_into",
				"step_over",
				"step_out",
				"terminate",
			},
		},
	},
	windows = {
		size = 0.25,
		position = "below",
	},
})
