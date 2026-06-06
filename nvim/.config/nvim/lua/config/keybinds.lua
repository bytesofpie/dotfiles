local function nmap(lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  opts.noremap = true

  vim.keymap.set("n", lhs, rhs, opts)
end

-- Global keybinds
nmap("<leader>w", "<cmd>w<CR>")
