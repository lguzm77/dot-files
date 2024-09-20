return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			-- install additional formatters via Mason
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				yaml = { "yamlfix" },
				json = { "prettier" },
				csharp = { "csharpier" },
				["*"] = { "codespell" },
				go = { "gofumpt" },
				sh = { "shellcheck" },
				markdown = { "prettier" },
				bash = { "beautysh" },
        sh = {"shellcheck"},
				proto = { "buf" },
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>l", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual)" })
	end,
}
