local M = {}

function M.nmap(lhs, rhs, opts)
    vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", {
        silent = true,
    }, opts or {}))
end

return M
