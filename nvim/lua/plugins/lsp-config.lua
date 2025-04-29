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
        "js-debug-adapter",
        "eslint_d",
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
        run_on_start = true,
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
    "neovim/nvim-lspconfig",
    dependencies = {
      "Saghen/blink.cmp",
      "williamboman/mason-lspconfig.nvim",
    },
    event = "VeryLazy",
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local mason_lspconfig = require "mason-lspconfig"

      local lspconfig = require "lspconfig"

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

      local signs =
        { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local keymap = vim.keymap
      -- keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP keymaps",
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf, silent = true }

          opts.desc = "Show LSP references"
          keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

          opts.desc = "Go to declaration"
          keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

          opts.desc = "Show LSP definitions"
          keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>zz", opts) -- show lsp definitions

          opts.desc = "Show LSP implementations"
          keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

          opts.desc = "Show LSP type definitions"
          keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

          opts.desc = "See available code actions"
          keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

          opts.desc = "Smart rename"
          keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

          opts.desc = "Show buffer diagnostics"
          keymap.set(
            "n",
            "<leader>D",
            "<cmd>Telescope diagnostics bufnr=0<CR>",
            opts
          ) -- show  diagnostics for file

          opts.desc = "Show line diagnostics"
          keymap.set("n", "<leader>dg", vim.diagnostic.open_float, opts) -- show diagnostics for line

          opts.desc = "Go to previous diagnostic"
          keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

          opts.desc = "Go to next diagnostic"
          keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

          opts.desc = "Show documentation for what is under cursor"
          keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

          opts.desc = "Restart LSP"
          keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
        end,
      })

      mason_lspconfig.setup_handlers({
        -- default handler for installed servers
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["ts_ls"] = function()
          lspconfig.ts_ls.setup({
            capabilities = capabilities,
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
            },
            root_dir = function()
              return vim.fs.dirname(
                vim.fs.find("tsconfig.json", { upward = true })[1]
                  or vim.fs.find("package.json", { upward = true })[1]
              )
            end,
          })
        end,
        ["eslint"] = function()
          lspconfig.eslint.setup({
            capabilities = capabilities,
            bin = "eslint_d", -- faster execution
            settings = {
              packageManager = "npm",
              validate = "on",
              workingDirectories = {
                mode = "auto",
              },
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
