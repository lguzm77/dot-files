return {
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>gl", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
		},
	},
	{
		"pwntester/octo.nvim",
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
		config = function()
			-- Custom :Browse command
			vim.api.nvim_create_user_command("Browse", function(opts)
				-- xdg-open for linux, open for mac
        -- TODO: Can you make this function execute the correct command based on the operation system?
				vim.fn.system({ "open", opts.fargs[1] })
			end, { nargs = 1 })

			vim.keymap.set({ "n", "v" }, "<leader>op", ":GBrowse<CR>", {})
		end,
	},
}
