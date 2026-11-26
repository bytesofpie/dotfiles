vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.mouse = ""
vim.opt.clipboard = "unnamedplus"

-- tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- lines
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false

-- columns
vim.opt.scrolloff = 10
-- enable in 0.13
-- vim.opt.scrolloffpad = 1
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 0
vim.opt.laststatus = 3

-- windows
vim.opt.winborder = "rounded"

-- Little bracket animation
vim.opt.showmatch = true
vim.opt.matchtime = 2

vim.opt.title = true

-- searching
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.path:append("**")
vim.opt.wildmode = { "longest:full", "full" }

-- undo & swap
vim.opt.swapfile = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.cache/nvim/undodir")

-- little snappier
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

-- splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- enable ui2
require("vim._core.ui2").enable({
	msg = {
		target = "msg",
		targets = {
			bufread = "msg",
			bufwrite = "msg",
			completion = "cmd",
			confirm = "cmd",
			echoerr = "pager",
			emsg = "pager",
			list_cmd = "pager",
			lua_error = "pager",
			progress = "msg",
			rpc_error = "pager",
			search_cmd = "cmd",
			search_count = "cmd",
			shell_cmd = "pager",
			shell_err = "pager",
			shell_out = "pager",
			shell_ret = "pager",
			typed_cmd = "msg",
			verbose = "pager",
			wildlist = "cmd",
		},
		msg = {
			height = 0.3,
			timeout = 5000,
		},
		pager = {
			height = 0.5,
		},
	},
})
