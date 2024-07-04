-- BLAZINGLY FAST
return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		vim.keymap.set("n", "<leader>M", function()
			mark.add_file()
			vim.notify("File marked by Harpoon")
		end, { desc = "Mark file for quick harpoon access" })

		vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle harpoon quick menu" })

		local number_of_marked_files = 3

		for i = 1, number_of_marked_files do
			vim.keymap.set("n", string.format("<C-%d>", i), function()
				ui.nav_file(i)
			end, { desc = string.format("Go to marked file %d", i) })
		end
	end,
}
