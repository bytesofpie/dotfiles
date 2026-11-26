local nmap = bytesofpie.nmap
local gitlinker = require("gitlinker")

nmap("<leader>bo", Snacks.bufdelete.other)
nmap("<leader>e", vim.cmd.Oil, { desc = "Open Oil" })
nmap("<leader>gg", Snacks.lazygit.open, { desc = "Open LazyGit" })
nmap("<leader><leader>", Snacks.picker.files, { desc = "Find files" })
nmap(";r", Snacks.picker.grep, { desc = "Live grep" })
nmap(";;", Snacks.picker.resume, { desc = "Resume last picker" })
nmap([[\\]], Snacks.picker.buffers, { desc = "List open buffers" })
nmap(";e", Snacks.picker.diagnostics, { desc = "List diagnostics" })
nmap(";n", Snacks.picker.notifications, { desc = "Notification history" })
nmap(";h", Snacks.picker.git_diff, { desc = "List Git hunks" })

nmap("]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })

nmap("[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous reference" })

nmap("gd", function()
	Snacks.picker.lsp_definitions({ jump = { reuse_win = false } })
end, { desc = "LSP Goto Definition" })
nmap("gD", Snacks.picker.lsp_declarations, { desc = "LSP Goto Declaration" })
nmap("gy", Snacks.picker.lsp_type_definitions, { desc = "LSP Goto Type Definition" })
nmap("gr", Snacks.picker.lsp_references, { desc = "LSP Find References" })
nmap("K", vim.lsp.buf.hover, { desc = "Hover" })
nmap("gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })

nmap("<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
nmap("<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
nmap("<leader>f", function()
	require("conform").format()
end, { desc = "Format code" })

nmap("<leader>gb", require("gitsigns").blame_line, { desc = "Blame current line" })
nmap("<leader>gB", require("gitsigns").blame, { desc = "Blame buffer" })
nmap("<leader>gl", gitlinker.link, { desc = "Copy git permalink" })

nmap("<leader>dv", "<cmd>CodeDiff<cr>", { desc = "Toggle CodeDiff" })
nmap("<leader>dh", "<cmd>CodeDiff history %<cr>", { desc = "File history (current file)" })
nmap("<leader>dH", "<cmd>CodeDiff history<cr>", { desc = "File history (repo)" })
