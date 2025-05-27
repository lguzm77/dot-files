return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    cmd = "Mason",
    dependencies = {
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

      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      -- New stuff
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
