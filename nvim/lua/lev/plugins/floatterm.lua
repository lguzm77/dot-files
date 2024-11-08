return {
	"voldikss/vim-floaterm",
	keys = {
		{
			"<leader>t",
			"<cmd>:FloatermNew --height=0.9 --width=0.9 --wintype=float --name=floaterm1 --position=center --autoclose=2<CR>",
			desc = "Open Floatterm",
		},
	},
	config = function()
		vim.keymap.set("n", "<leader>tt", "<cmd>:FloatermToggle<CR>", { desc = "Toggle FloatTerm" })
		vim.keymap.set("t", "<leader>tt", "<cmd>:FloatermToggle<CR>", { desc = "Toggle FloatTerm" })

		vim.keymap.set("t", "<leader>n", "<cmd>:FloatermNext<CR>", { desc = "Toggle FloatTerm" })
		vim.keymap.set("t", "<leader>p", "<cmd>:FloatTermPrev<CR>", { desc = "Toggle FloatTerm" })
	end,
}
