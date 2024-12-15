return {
	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup({ enable_builtin = true })
			vim.cmd([[hi OctoEditable guibg=none]]) -- removes background colors in diff showing
		end,
		keys = { { "<leader>O", "<cmd>Octo<cr>", desc = "Octo" } },
	},
	{
		"tpope/vim-fugitive",
		dependencies = { "tpope/vim-rhubarb" },
		event = "BufRead",
		config = function()
			-- Custom :Browse command
			vim.api.nvim_create_user_command("Browse", function(opts)
				-- xdg-open for linux, open for mac
				-- TODO: Can you make this function execute the correct command based on the operation system?
				vim.fn.system({ "open", opts.fargs[1] })
			end, { nargs = 1 })

			vim.keymap.set({ "n", "v" }, "<leader>op", ":GBrowse<CR>", {})
			vim.keymap.set("n", "<leader>df", "<cmd>:Gvdiffsplit!<cr>", { desc = "Git conflict resolution" })
		end,
	},
}
