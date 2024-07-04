return {
	"folke/tokyonight.nvim",
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "storm",
		})
		local number_color = "#bb9af7"
    local number_line_color = "#CEB25E"
		vim.cmd("colorscheme tokyonight")
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = number_color, bold = true })
		vim.api.nvim_set_hl(0, "LineNr", { fg = number_line_color, bold = true })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = number_color, bold = true })
	end,
}
