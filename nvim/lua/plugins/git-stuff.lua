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
			vim.keymap.set("n", "<leader>df", "<cmd>:Gvdiffsplit!<cr>", { desc = "Git conflict resolution" })
		end,
	},
}
