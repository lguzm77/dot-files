return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "Oil",
	keys = {
		{ "-", "<cmd>Oil --float<CR>", desc = "Open parent directory" },
	},
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			float = {
				padding = 5,
				max_width = 70,
        max_height = 70,
			},
			view_options = {
				show_hidden = true,
				natural_order = true,
				is_hidden_file = function(name, _)
					return name == ".." or name == ".git" -- hide .git and .. folders
				end,
			},
			win_options = { wrap = true },
		})
	end,
}
