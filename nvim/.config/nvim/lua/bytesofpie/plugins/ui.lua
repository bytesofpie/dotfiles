require("tokyonight").setup({
	transparent = true,
	terminal_colors = true,
	style = "night",
})

require("tiny-cmdline").setup({
	position = {
		x = "50%",
		y = "20%",
	},
})

require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()
require("gitsigns").setup()
require("gitlinker").setup()
require("oil").setup()
require("oil-git").setup()
require("todo-comments").setup()

require("snacks").setup({
	lazygit = {},
	indent = {},
	notifier = {},
	picker = {
		sources = {
			files = { hidden = true, ignored = false },
			grep = { hidden = true },
		},
	},
	words = {},
})

vim.cmd.colorscheme("tokyonight")

require("bytesofpie.utils.tabline").setup()
vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.require('bytesofpie.utils.tabline').render()"

local lualine_utils = require("bytesofpie.utils.lualine")

require("lualine").setup({
	options = {
		theme = "tokyonight",
		globalstatus = true,
		disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
		refresh = {
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
				"RecordingEnter",
				"RecordingLeave",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			lualine_utils.root_dir(),
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{
				lualine_utils.pretty_path({ length = 0 }),
			},
		},
		lualine_x = {
			lualine_utils.macro_recording(),
			{
				"diagnostics",
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
			},
			{
				"diff",
				symbols = { added = " ", modified = " ", removed = " " },
			},
		},
		lualine_y = { { "progress", separator = " ", padding = { left = 1, right = 1 } } },
		lualine_z = { { "location", padding = { left = 1, right = 1 } } },
	},
})

require("nvim-treesitter").install({
	"bash",
	"odin",
	"c",
	"javascript",
	"html",
	"typescript",
	"lua",
	"luadoc",
	"css",
	"gitignore",
	"rust",
	"elixir",
	"erlang",
	"heex",
	"jsdoc",
	"json",
	"markdown",
	"markdown_inline",
	"sql",
	"toml",
	"tsx",
	"vim",
	"vimdoc",
	"csv",
})

vim.lsp.document_color.enable(false)
require("nvim-highlight-colors").setup({
	render = "background",
	enable_hex = true,
	enable_short_hex = true,
	enable_rgb = true,
	enable_hsl = true,
	enable_hsl_without_function = true,
	enable_ansi = true,
	enable_var_usage = true,
	enable_tailwind = false,
})

vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
		format = function(diagnostic)
			return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
		end,
	},
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
})

---@module 'blink.cmp'
---@type blink.cmp.Config
require("blink.cmp").setup({
	snippets = {
		preset = "default",
	},
	completion = {
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
		menu = {
			border = "none",
			draw = {
				treesitter = { "lsp" },
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		ghost_text = {
			enabled = vim.g.ai_cmp,
		},
	},
	cmdline = {
		enabled = true,
		keymap = {
			preset = "cmdline",
			["<Right>"] = false,
			["<Left>"] = false,
		},
		completion = {
			list = { selection = { preselect = false } },
			menu = {
				auto_show = function()
					return vim.fn.getcmdtype() == ":"
				end,
			},
			ghost_text = { enabled = true },
		},
	},

	keymap = {
		preset = "enter",
		["c-y"] = { "select_and_accept" },
	},

	appearance = {
		kind_icons = {
			Array = " ",
			Boolean = "󰨙 ",
			Class = " ",
			Codeium = "󰘦 ",
			Color = " ",
			Control = " ",
			Collapsed = " ",
			Constant = "󰏿 ",
			Constructor = " ",
			Enum = " ",
			EnumMember = " ",
			Event = " ",
			Field = " ",
			File = " ",
			Folder = " ",
			Function = "󰊕 ",
			Interface = " ",
			Key = " ",
			Keyword = " ",
			Method = "󰊕 ",
			Module = " ",
			Namespace = "󰦮 ",
			Null = " ",
			Number = "󰎠 ",
			Object = " ",
			Operator = " ",
			Package = " ",
			Property = " ",
			Reference = " ",
			Snippet = "󱄽 ",
			String = " ",
			Struct = "󰆼 ",
			Text = " ",
			TypeParameter = " ",
			Unit = " ",
			Value = " ",
			Variable = "󰀫 ",
		},
	},
})

require("mini.pairs").setup({
	modes = { insert = true, command = true, terminal = false },
})

require("mini.diff").setup({
	view = {
		overlay_style = "hunk",
	},
	mappings = {
		goto_next = "]c",
		goto_prev = "[c",
	},
})
