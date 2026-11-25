local M = {}

local root_patterns = { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }

local function normalize(path)
  path = vim.fn.expand(path)
  return vim.fs.normalize(vim.uv.fs_realpath(path) or path):gsub("(.)/$", "%1")
end

local function get_cwd()
  return normalize(vim.fn.getcwd())
end

local function get_root()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or vim.bo.buftype ~= "" then
    path = get_cwd()
  else
    path = vim.fs.dirname(path)
  end
  local marker = vim.fs.find(root_patterns, { path = path, upward = true })[1]
  return marker and normalize(vim.fs.dirname(marker)) or get_cwd()
end

local function is_within(path, root)
  if vim.fn.has("win32") == 1 then
    path, root = path:lower(), root:lower()
  end
  return path == root or path:sub(1, #root + 1) == root .. "/" or root == "/"
end

local function escape(text)
  return (text:gsub("%%", "%%%%"))
end

---Format the current file path, with separate directory and filename highlights.
---@param opts? table
function M.pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    modified_hl = "MatchParen",
    directory_hl = "",
    filename_hl = "Bold",
    modified_sign = "",
    readonly_icon = " 󰌾 ",
    length = 3,
  }, opts or {})

  return function(self)
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" or vim.bo.buftype ~= "" then
      return ""
    end
    path = normalize(path)
    local root = opts.relative == "root" and get_root() or get_cwd()
    if is_within(path, root) then
      path = path:sub(#root + (root == "/" and 1 or 2))
    end

    local parts = vim.split(path, "/", { plain = true })
    if opts.length > 0 and #parts > opts.length then
      local truncated = { parts[1], "…" }
      for i = #parts - opts.length + 2, #parts do
        truncated[#truncated + 1] = parts[i]
      end
      parts = truncated
    end

    local filename = escape(table.remove(parts) or "")
    local dir = #parts > 0 and escape(table.concat(parts, "/") .. "/") or ""
    local section = self and self.options and self.options.section or "c"
    local reset = "%#lualine_" .. section .. "_normal#"
    local function highlight(text, group)
      return group and group ~= "" and ("%#" .. group .. "#" .. text .. reset) or text
    end

    local file_hl = vim.bo.modified and opts.modified_hl or opts.filename_hl
    local result = highlight(dir, opts.directory_hl) .. highlight(filename, file_hl)
    if vim.bo.modified then
      result = result .. escape(opts.modified_sign)
    end
    if vim.bo.readonly or not vim.bo.modifiable then
      result = result .. escape(opts.readonly_icon)
    end
    return result
  end
end

---Show the project root according to its relationship with the working directory.
---@param opts? table
function M.root_dir(opts)
  opts = vim.tbl_extend("force", {
    cwd = false,
    subdirectory = true,
    parent = true,
    other = true,
    icon = "󱉭 ",
    color = function()
      return { fg = Snacks.util.color("Special") }
    end,
  }, opts or {})

  local function get()
    local cwd, root = get_cwd(), get_root()
    local show
    if root == cwd then
      show = opts.cwd
    elseif is_within(root, cwd) then
      show = opts.subdirectory
    elseif is_within(cwd, root) then
      show = opts.parent
    else
      show = opts.other
    end
    return show and vim.fs.basename(root) or nil
  end

  return {
    function()
      local name = get()
      return name and escape((opts.icon or "") .. name) or ""
    end,
    cond = function()
      return get() ~= nil
    end,
    color = opts.color,
  }
end

---Show the register currently being used to record a macro.
---@param opts? table
function M.macro_recording(opts)
  opts = vim.tbl_extend("force", {
    icon = "󰑋 ",
    color = function()
      return { fg = Snacks.util.color("DiagnosticError"), gui = "bold" }
    end,
  }, opts or {})

  return {
    function()
      return opts.icon .. vim.fn.reg_recording()
    end,
    cond = function()
      return vim.fn.reg_recording() ~= ""
    end,
    color = opts.color,
  }
end

return M
