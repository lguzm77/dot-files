return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			-- install additional formatters via Mason
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				yaml = { "prettierd" },
				csharp = { "csharpier" },
				["*"] = { "codespell" },
				go = { "gofumpt" },
				sh = { "shellcheck" },
				markdown = { "prettierd" },
				bash = { "beautysh" },
        proto = { "buf" },
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>l", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range (in visual)" })
	end,
}
