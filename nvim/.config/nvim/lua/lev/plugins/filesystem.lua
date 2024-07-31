return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			view_options = {
				show_hidden = false,
			},
		})

		local keymap = vim.keymap
		keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
	end,
}
