return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"zig",
				"lua",
				"vim",
				"vimdoc",
			},
			highlight = {
				enable = true,
			},
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		opts = {
			keymap = {
				["<CR>"] = { "accept", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				menu = {
					border = "rounded",
				},
				documentation = {
					auto_show = true,
					window = {
						border = "rounded",
					},
				},
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			sign_priority = 20,
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"sphamba/smear-cursor.nvim",
		opts = {},
	},
	{
		"fleury",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		priority = 1000,
		config = function()
			require("fleury.colors").setup()
		end,
	},
}
