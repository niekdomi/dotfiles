local function get_format_on_save(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
    return { timeout_ms = 500, lsp_format = "fallback" }
end

require("conform").setup({
    formatters_by_ft = {
        bash = { "shfmt" },
        c = { "clang_format" },
        cmake = { "gersemi" },
        cpp = { "clang_format" },
        cs = { "csharpier" },
        css = { "prettierd" },
        go = { "gopls" },
        html = { "prettierd" },
        javascript = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        python = { lsp_format = "prefer" },
        rust = { "rustfmt" },
        svelte = { "prettierd" },
        toml = { "tombi" },
        typescript = { "prettierd" },
        typst = { lsp_format = "prefer" },
        yaml = { "prettierd" },
    },
    formatters = {
        gersemi = {
            prepend_args = {
                "--list-expansion=favour-expansion",
                "--no-warn-about-unknown-commands",
            },
        },
    },
    format_on_save = get_format_on_save,
})

vim.api.nvim_create_user_command("Format", function(args)
    local action = args.fargs[1]
    local valid_actions = {
        toggle = function() vim.b.disable_autoformat = not vim.b.disable_autoformat end,
        disable = function() vim.b.disable_autoformat = true end,
        enable = function() vim.b.disable_autoformat = false end,
    }

    if not valid_actions[action] then
        vim.notify("Invalid format action. Use: enable, disable, or toggle", vim.log.levels.ERROR)
        return
    end

    valid_actions[action]()

    local status = vim.b.disable_autoformat and "Disabled" or "Enabled"
    vim.notify(string.format("Buffer autoformat: %s", status), vim.log.levels.INFO)
end, {
    desc = "Control buffer-local autoformat (enable/disable/toggle)",
    nargs = 1,
    complete = function() return { "enable", "disable", "toggle" } end,
})
