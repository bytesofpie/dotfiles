vim.pack.add({
	"https://github.com/rachartier/tiny-cmdline.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/nvim-mini/mini.diff",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/malewicz1337/oil-git.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/linrongbin16/gitlinker.nvim",
	"https://github.com/esmuellert/codediff.nvim",
})

require("bytesofpie.plugins.ui")
require("bytesofpie.plugins.keymaps")
require("bytesofpie.plugins.lsp")
require("bytesofpie.plugins.editor")
