require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"tree-sitter-cli",
		"lua-language-server",
		"prettier",
		"prettierd",
		"shfmt",
		"stylua",
		"eslint-lsp",
		"oxlint",
		"oxfmt",
		"tailwindcss-language-server",
		"vtsls",
		"rust-analyzer",
		"expert",
	},
	auto_update = false,
	run_on_start = true,
})

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.enable({
	"lua_ls",
	"vtsls",
	"eslint",
	"tailwindcss",
	"rust_analyzer",
	"oxlint",
	"expert",
})
