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
require("snacks").setup()
require("gitsigns").setup()

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
