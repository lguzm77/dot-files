return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	config = function()
		vim.opt.termguicolors = true
		require("bufferline").setup({
			options = {
				mode = "buffers",
        diagnostics = "nvim_lsp",
				separator_style = "thin",
				indicator = {
					style = "underline",
				},
			},
		})
	end,
}
