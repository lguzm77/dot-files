return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		--TODO: rework mason installation

		local javascript_tools = {
			"prettier",
			"eslint_d",
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


		-- install linters and formatters
		mason_tool_installer.setup({
			ensure_installed = {
				"stylua",
				"codespell",
				"marksman",
        "buf",
        "yamlfix",
        unpack(javascript_tools),
        unpack(go_tools),
        unpack(shell_tools),
			},
		})
	end,
}
