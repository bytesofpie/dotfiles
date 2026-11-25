local M = {}

local SOLID_LEFT_ARROW = ""
local SOLID_RIGHT_ARROW = ""
local MAX_NAME_LENGTH = 20
local TRUNCATE_TO = 17

---Set up tabline highlights using the configured TokyoNight palette.
function M.setup()
  local ok, colors_mod = pcall(require, "tokyonight.colors")
  if not ok then
    vim.notify("tabline: tokyonight.colors not found", vim.log.levels.WARN)
    return
  end
  local colors = colors_mod.setup()

  vim.api.nvim_set_hl(0, "TabLineActive", {
    fg = colors.bg,
    bg = colors.blue,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "TabLineInactive", {
    fg = colors.fg_dark,
    bg = colors.bg_dark,
  })
  vim.api.nvim_set_hl(0, "TabLineSepActive", {
    fg = colors.blue,
    bg = "NONE",
  })
  vim.api.nvim_set_hl(0, "TabLineSepInactive", {
    fg = colors.bg_dark,
    bg = "NONE",
  })
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
end

---@param filename string
---@return string
local function get_icon(filename)
  if MiniIcons and MiniIcons.get then
    return MiniIcons.get("file", filename)
  end
  return ""
end

---@param bufnr number
---@return string name, string icon
local function get_buf_info(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  if vim.bo[bufnr].buftype == "terminal" then
    return "[Terminal]", ""
  end

  if vim.bo[bufnr].filetype == "oil" then
    local dir = vim.fn.fnamemodify(bufname:gsub("^oil://", ""), ":~")
    local length = vim.fn.strchars(dir)
    if length > MAX_NAME_LENGTH then
      dir = "…" .. vim.fn.strcharpart(dir, length - TRUNCATE_TO, TRUNCATE_TO)
    end
    return dir, ""
  end

  if bufname == "" then
    return "[No Name]", ""
  end

  local filename = vim.fn.fnamemodify(bufname, ":t")
  local icon = get_icon(filename)
  if vim.fn.strchars(filename) > MAX_NAME_LENGTH then
    filename = vim.fn.strcharpart(filename, 0, TRUNCATE_TO) .. "…"
  end
  return filename, icon
end

---Switch to a buffer when its tabline label is clicked.
---@param bufnr number
---@param clicks number
---@param button string
---@param modifiers string
function M.select(bufnr, clicks, button, modifiers)
  if button == "l" and vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
    vim.api.nvim_set_current_buf(bufnr)
  end
end

---@param bufnr number
---@param is_active boolean
---@return string
local function render_buffer(bufnr, is_active)
  local filename, icon = get_buf_info(bufnr)
  local modified = vim.bo[bufnr].modified and "[+] " or ""
  local title = ("   " .. modified .. icon .. " " .. filename .. "   "):gsub("%%", "%%%%")
  local tab_hl = is_active and "%#TabLineActive#" or "%#TabLineInactive#"
  local sep_hl = is_active and "%#TabLineSepActive#" or "%#TabLineSepInactive#"

  return string.format(
    "%%%d@v:lua.require'bytesofpie.utils.tabline'.select@%s%s%s%s%s%s%%X",
    bufnr,
    sep_hl,
    SOLID_LEFT_ARROW,
    tab_hl,
    title,
    sep_hl,
    SOLID_RIGHT_ARROW
  )
end

---@return string
function M.render()
  local ok, result = pcall(function()
    local parts = {}
    local current_buf = vim.api.nvim_get_current_buf()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[bufnr].buflisted then
        parts[#parts + 1] = render_buffer(bufnr, bufnr == current_buf)
      end
    end
    return table.concat(parts) .. "%#TabLineFill#"
  end)
  return ok and result or "%#TabLineFill#"
end

return M
