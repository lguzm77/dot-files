return {
	"voldikss/vim-floaterm",
	keys = {
		{
			"<leader>t",
			"<cmd>:FloatermNew --height=0.7 --width=0.8 --wintype=float --name=floaterm1 --position=center --autoclose=2<CR>",
			desc = "Open Floatterm",
		},
	},
	config = function()
		vim.keymap.set("n", "<leader>flt", "<cmd>:FloatermToggle<CR>", { desc = "Toggle FloatTerm" })
		vim.keymap.set("t", "<leader>flt", "<cmd>:FloatermToggle<CR>", { desc = "Toggle FloatTerm" })
	end,
}
