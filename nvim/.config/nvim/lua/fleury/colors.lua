local M = {}

M.palette = {
	bar = "#131313",
	base = "#ffcfaa",
	pop1 = "#de8150",
	pop2 = "#ff0000",

	bg = "#171717",
	bg_alt = "#222425",
	bg_alt2 = "#1e1e1e",
	bg_dark = "#101010",
	bg_hover = "#362e25",
	bg_active = "#63523d",

	fg = "#b99468",
	fg_base = "#ffcfaa",
	comment = "#9ba290",
	non_text = "#5c4d3c",

	keyword = "#f0c674",
	string = "#ffa900",
	number = "#ffa900",
	preproc = "#dc7575",
	operator = "#dc7575",
	special = "#ff0000",

	func = "#eb7134",
	type = "#edb211",
	macro = "#2895c7",
	enum = "#6eb535",

	cursor = "#00ee00",
	cursor_alt = "#e0741b",
	cursor_text = "#0c0c0c",

	visual = "#303040",
	visual_fg = "#ff44dd",
	mark = "#494949",

	error_bg = "#3a0000",
	warn_bg = "#003a3a",
	error = "#ff0000",

	cyan = "#03d3fc",
	green = "#22b80b",
	bright_green = "#27cc7f",
	aqua = "#8ffff2",
	yellow = "#f0bb0c",
	orange = "#f0500c",
	magenta = "#de2368",
	power = "#efaf2f",
}

local function hi(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

function M.setup()
	vim.cmd("highlight clear")

	if vim.fn.exists("syntax_on") == 1 then
		vim.cmd("syntax reset")
	end

	vim.g.colors_name = "fleury"
	vim.o.background = "dark"

	local c = M.palette

	-- Editor UI
	hi("Normal", { fg = c.fg, bg = c.bg })
	hi("NormalNC", { fg = c.fg, bg = c.bg })
	hi("SignColumn", { fg = c.non_text, bg = c.bg })
	hi("FoldColumn", { fg = c.non_text, bg = c.bg })
	hi("ColorColumn", { bg = c.bg_alt })
	hi("Cursor", { fg = c.cursor_text, bg = c.cursor })
	hi("lCursor", { fg = c.cursor_text, bg = c.cursor_alt })
	hi("CursorLine", { bg = c.bg_alt2 })
	hi("CursorColumn", { bg = c.bg_alt2 })
	hi("LineNr", { fg = "#404040", bg = c.bg_dark })
	hi("CursorLineNr", { fg = c.base, bg = c.bg_dark, bold = true })

	hi("Visual", { fg = c.visual_fg, bg = c.visual })
	hi("VisualNOS", { bg = c.visual })
	hi("Search", { fg = c.visual_fg, bg = c.visual })
	hi("IncSearch", { fg = c.cursor_text, bg = c.pop1 })
	hi("CurSearch", { fg = c.cursor_text, bg = c.pop1 })

	hi("Pmenu", { fg = c.fg, bg = c.bg_alt })
	hi("PmenuSel", { fg = c.base, bg = c.bg_active })
	hi("PmenuSbar", { bg = c.bg_alt })
	hi("PmenuThumb", { bg = c.bg_active })

	hi("StatusLine", { fg = c.base, bg = c.bar })
	hi("StatusLineNC", { fg = c.non_text, bg = c.bar })
	hi("WinSeparator", { fg = c.bg_alt, bg = c.bg })
	hi("VertSplit", { fg = c.bg_alt, bg = c.bg })
	hi("TabLine", { fg = c.fg, bg = c.bar })
	hi("TabLineSel", { fg = c.base, bg = c.bg_active })
	hi("TabLineFill", { bg = c.bar })

	hi("NonText", { fg = c.non_text })
	hi("Whitespace", { fg = c.non_text })
	hi("EndOfBuffer", { fg = c.bg })
	hi("Directory", { fg = c.macro })
	hi("Title", { fg = c.func, bold = true })
	hi("Question", { fg = c.keyword })
	hi("MoreMsg", { fg = c.keyword })
	hi("ModeMsg", { fg = c.base })

	-- Diagnostics
	hi("Error", { fg = c.error, bg = c.error_bg })
	hi("ErrorMsg", { fg = c.error })
	hi("WarningMsg", { fg = c.yellow })
	hi("DiagnosticError", { fg = c.error })
	hi("DiagnosticWarn", { fg = c.yellow })
	hi("DiagnosticInfo", { fg = c.cyan })
	hi("DiagnosticHint", { fg = c.bright_green })
	hi("DiagnosticUnderlineError", { sp = c.error, undercurl = true })
	hi("DiagnosticUnderlineWarn", { sp = c.yellow, undercurl = true })
	hi("DiagnosticUnderlineInfo", { sp = c.cyan, undercurl = true })
	hi("DiagnosticUnderlineHint", { sp = c.bright_green, undercurl = true })

	-- Diff
	hi("DiffAdd", { fg = c.green, bg = "#1e2a1e" })
	hi("DiffChange", { fg = c.yellow, bg = "#2a261e" })
	hi("DiffDelete", { fg = c.error, bg = c.error_bg })
	hi("DiffText", { fg = c.base, bg = c.visual })

	-- Base syntax
	hi("Comment", { fg = c.comment, italic = true })
	hi("Constant", { fg = c.number })
	hi("String", { fg = c.string })
	hi("Character", { fg = c.string })
	hi("Number", { fg = c.number })
	hi("Boolean", { fg = c.number })
	hi("Float", { fg = c.number })

	hi("Identifier", { fg = c.fg })
	hi("Function", { fg = c.func })

	hi("Statement", { fg = c.keyword })
	hi("Conditional", { fg = c.keyword })
	hi("Repeat", { fg = c.keyword })
	hi("Label", { fg = c.keyword })
	hi("Operator", { fg = c.operator })
	hi("Keyword", { fg = c.keyword })
	hi("Exception", { fg = c.keyword })

	hi("PreProc", { fg = c.preproc })
	hi("Include", { fg = c.string })
	hi("Define", { fg = c.macro })
	hi("Macro", { fg = c.macro })
	hi("PreCondit", { fg = c.preproc })

	hi("Type", { fg = c.type })
	hi("StorageClass", { fg = c.keyword })
	hi("Structure", { fg = c.keyword })
	hi("Typedef", { fg = c.type })

	hi("Special", { fg = c.special })
	hi("SpecialChar", { fg = c.special })
	hi("Tag", { fg = c.bright_green })
	hi("Delimiter", { fg = c.operator })
	hi("SpecialComment", { fg = c.bright_green })
	hi("Debug", { fg = c.pop2 })

	hi("Underlined", { underline = true })
	hi("Ignore", { fg = c.non_text })
	hi("Todo", { fg = c.bright_green, bold = true })
	hi("MatchParen", { fg = c.aqua, bold = true })

	-- Treesitter
	hi("@comment", { link = "Comment" })
	hi("@string", { link = "String" })
	hi("@string.escape", { fg = c.special })
	hi("@character", { link = "Character" })
	hi("@number", { link = "Number" })
	hi("@boolean", { link = "Boolean" })
	hi("@float", { link = "Float" })

	hi("@function", { fg = c.func })
	hi("@function.call", { fg = c.func })
	hi("@function.builtin", { fg = c.func })
	hi("@method", { fg = c.func })
	hi("@method.call", { fg = c.func })
	hi("@constructor", { fg = c.type })

	hi("@keyword", { fg = c.keyword })
	hi("@keyword.function", { fg = c.keyword })
	hi("@keyword.return", { fg = c.keyword })
	hi("@keyword.operator", { fg = c.keyword })
	hi("@conditional", { fg = c.keyword })
	hi("@repeat", { fg = c.keyword })
	hi("@operator", { fg = c.operator })

	hi("@type", { fg = c.type })
	hi("@type.builtin", { fg = c.keyword })
	hi("@type.definition", { fg = c.type })
	hi("@storageclass", { fg = c.keyword })
	hi("@structure", { fg = c.keyword })

	hi("@constant", { fg = c.number })
	hi("@constant.builtin", { fg = c.number })
	hi("@constant.macro", { fg = c.enum })
	hi("@variable", { fg = c.fg })
	hi("@variable.builtin", { fg = c.keyword })
	hi("@field", { fg = c.fg_base })
	hi("@property", { fg = c.fg_base })
	hi("@parameter", { fg = c.base })

	hi("@namespace", { fg = c.type })
	hi("@module", { fg = c.type })
	hi("@punctuation", { fg = c.operator })
	hi("@punctuation.delimiter", { fg = c.operator })
	hi("@punctuation.bracket", { fg = c.fg })
	hi("@punctuation.special", { fg = c.special })

	hi("@preproc", { fg = c.preproc })
	hi("@include", { fg = c.string })
	hi("@define", { fg = c.macro })
	hi("@macro", { fg = c.macro })

	hi("@tag", { fg = c.func })
	hi("@tag.attribute", { fg = c.type })
	hi("@tag.delimiter", { fg = c.operator })

	-- LSP semantic tokens
	hi("@lsp.type.function", { fg = c.func })
	hi("@lsp.type.method", { fg = c.func })
	hi("@lsp.type.macro", { fg = c.macro })
	hi("@lsp.type.enum", { fg = c.enum })
	hi("@lsp.type.enumMember", { fg = c.enum })
	hi("@lsp.type.type", { fg = c.type })
	hi("@lsp.type.struct", { fg = c.keyword })
	hi("@lsp.type.class", { fg = c.type })
	hi("@lsp.type.interface", { fg = c.type })
	hi("@lsp.type.parameter", { fg = c.base })
	hi("@lsp.type.property", { fg = c.fg_base })
	hi("@lsp.type.variable", { fg = c.fg })

	-- Common plugins
	hi("TelescopeNormal", { fg = c.fg, bg = c.bg })
	hi("TelescopeBorder", { fg = c.bg_active, bg = c.bg })
	hi("TelescopeSelection", { fg = c.base, bg = c.bg_hover })
	hi("TelescopeMatching", { fg = c.string, bold = true })

	hi("NvimTreeNormal", { fg = c.fg, bg = c.bg })
	hi("NvimTreeFolderName", { fg = c.type })
	hi("NvimTreeOpenedFolderName", { fg = c.type, bold = true })
	hi("NvimTreeRootFolder", { fg = c.func, bold = true })
	hi("NvimTreeGitDirty", { fg = c.yellow })
	hi("NvimTreeGitNew", { fg = c.green })
	hi("NvimTreeGitDeleted", { fg = c.error })

	hi("GitSignsAdd", { fg = c.green })
	hi("GitSignsChange", { fg = c.yellow })
	hi("GitSignsDelete", { fg = c.error })
end

return M
