return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_tool_installer = require("mason-tool-installer")

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
}
