local function find_venv()
    local cwd = vim.fn.getcwd()
    local path = cwd
    while path ~= "/" do
        local venv = path .. "/.venv"
        if vim.fn.isdirectory(venv) == 1 then
            return venv
        end
        path = vim.fn.fnamemodify(path, ":h")
    end
end

local venv = find_venv()
if venv then
    vim.env.VIRTUAL_ENV = venv
    vim.env.PATH = venv .. "/bin:" .. vim.env.PATH
    vim.g.python3_host_prog = venv .. "/bin/python"
end
