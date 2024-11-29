return {
	{
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
					yaml = { "yamlfix" },
					json = { "prettierd" },
					csharp = { "csharpier" },
					["*"] = { "codespell" },
					go = { "gofumpt" },
					markdown = { "prettierd" },
					bash = { "beautysh" },
					sh = { "shellcheck" },
					proto = { "buf" },
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>l", function()
				conform.format({
					lsp_fallback = true,
					async = true,
					timeout_ms = 1000,
				})
			end, { desc = "Format file or range (in visual)" })
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				yaml = { "yamllint" },
				protobuf = { "buf" },
				terraform = { "tflint" },
				["*"] = { "codespell" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>ll", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
		end,
	},
}
