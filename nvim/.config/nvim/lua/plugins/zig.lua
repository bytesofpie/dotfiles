return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        zls = {
          cmd = { "zls" },
          mason = false,
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "zig" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        zig = { "zigfmt" },
      },
    },
  },
}
