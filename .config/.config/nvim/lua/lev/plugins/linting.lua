return {
	-- TODO: evaluate moving all linting and formatter jazz to mason.lua
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

		-- auto trigger on certain events
    -- TextChanged removed this event, evaluate if it affects your workflow
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
}
