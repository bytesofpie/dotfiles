local augroup = vim.api.nvim_create_augroup("bytesofpie_autocmds", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = augroup,
	callback = function()
		vim.wo.cursorline = true
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	group = augroup,
	callback = function()
		vim.wo.cursorline = false
	end,
})
