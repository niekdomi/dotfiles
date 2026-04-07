local function get_os_appearance()
    local os = vim.uv.os_uname().sysname

    if os == "Linux" then
        local handle =
            io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
        if handle then
            local result = handle:read("*a")
            handle:close()
            return result:find("dark") and "dark" or "light"
        end
    end

    return "dark" -- fallback
end

vim.o.background = get_os_appearance()
