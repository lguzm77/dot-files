return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    cmd = "Mason",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "williamboman/mason-lspconfig",
      "neovim/nvim-lspconfig",
    },
    opts = {
      servers = {
        ts_ls = {},
        eslint = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      local mason = require "mason"
      local mason_lspconfig = require "mason-lspconfig"
      local mason_tool_installer = require "mason-tool-installer"

      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      mason_tool_installer.setup({

        ensure_installed = {
          "stylua",
          "prettierd",
          "prettier",
          "csharpier",
          "codespell",
          "gofumpt",
          "beautysh",
          "shellcheck",
          "buf",
        },
      })

      local lsps = {
        "yamlls",
        "ts_ls",
        "eslint",
        "gopls",
        "omnisharp",
        "lua_ls",
        "dockerls",
        "bashls",
      }

      -- Language servers installed by Mason
      mason_lspconfig.setup({
        auto_install = true,
        ensure_installed = lsps,
      })

      for server, config in pairs(opts.servers) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
  },
}
