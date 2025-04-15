return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    cmd = "Mason",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local mason = require "mason"
      local mason_tool_installer = require "mason-tool-installer"

      -- Linters and formatters
      local javascript_tools = {
        "prettierd",
        "eslint",
        "js-debug-adapter",
      }

      local go_tools = {
        "gofumpt",
        "golangci-lint",
      }

      local shell_tools = {
        "shellcheck",
        "beautysh",
      }

      local yaml_tools = { "yamlfix", "yamllint" }

      -- install linters and formatters
      mason_tool_installer.setup({
        ensure_installed = {
          "stylua",
          "codespell",
          "marksman",
          "buf",
          unpack(yaml_tools),
          unpack(javascript_tools),
          unpack(go_tools),
          unpack(shell_tools),
          "tflint",
        },
      })

      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    -- completion
    "Saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    event = "VeryLazy",

    version = "v0.*",

    opts = {
      keymap = { preset = "default" },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "Saghen/blink.cmp",
      "williamboman/mason-lspconfig.nvim",
    },
    event = "VeryLazy",
    config = function()
      -- TODO: rework lsp configuration
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local mason_lspconfig = require "mason-lspconfig"

      local lspconfig = require "lspconfig"

      local lsps = {
        "yamlls",
        "biome", -- js toolchain
        "eslint",
        "gopls",
        "omnisharp",
        "lua_ls",
      }

      -- Language servers installed by Mason
      mason_lspconfig.setup({
        auto_install = true,
        ensure_installed = lsps,
      })

      local signs =
        { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      mason_lspconfig.setup_handlers({
        -- default handler for installed servers
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["eslint"] = function()
          lspconfig.eslint.setup({
            packageManager = "npm",
            settings = {
              validate = "on",
              workingDirectories = { mode = "auto" },
              format = true,
            },
            on_attach = function(client, bufnr)
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
              })
            end,
          })
        end,
        ["yamlls"] = function()
          lspconfig.yamlls.setup({
            filetypes = { "yml", "yaml", "yaml.docker-compose", "yaml.gitlab" },
            capabilities = capabilities,
            settings = {
              yaml = {
                schemas = {
                  ["https://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                  ["https://json.schemastore.org/kubernetes"] = "manifests/*.yaml",
                },
                validate = true, -- Enable schema validation
                format = {
                  enable = true, -- Enable auto-formatting
                },
                keyOrdering = false, -- Disable reordering of keys during formatting
              },
            },
          })
        end,
        --specific handlers
        ["omnisharp"] = function()
          local omnisharp_exec_path = vim.fn.stdpath "data"
            .. "/mason/packages/libexec/OmniSharp.dll"
          lspconfig.omnisharp.setup({
            capabilities = capabilities,
            cmd = { "dotnet", omnisharp_exec_path },
            settings = {
              RoslynExtensionsOptions = {
                EnableAnalyzersSupport = true,
                AnalyzeOpenDocumentsOnly = true,
              },
            },
          })
        end,
      })
    end,
  },
}
