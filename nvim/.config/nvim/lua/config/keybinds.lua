local function nmap(lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	opts.noremap = true

	vim.keymap.set("n", lhs, rhs, opts)
end

-- Global keybinds
nmap("<leader>w", "<cmd>w<CR>")

-- Add all TODOs to qflist
vim.keymap.set("n", "<leader>st", function()
	vim.fn.setqflist({}, " ", {
		title = "TODOs",
		lines = vim.fn.systemlist("rg --vimgrep TODO"),
		efm = "%f:%l:%c:%m",
	})
	vim.cmd("Trouble qflist toggle focus=true")
end, { desc = "Search TODOs" })
