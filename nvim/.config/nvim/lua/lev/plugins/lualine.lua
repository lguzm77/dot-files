return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "AndreM222/copilot-lualine", "folke/noice.nvim" },
	config = function()
		local lualine = require("lualine")
		lualine.setup({
			options = {
				theme = "auto",
			},
			sections = {
				lualine_x = {
					{
						require("noice").api.status.mode.get,
						cond = require("noice").api.status.mode.has,
						color = { fg = "#ff9e64" },
					},
					{ "copilot" },
					{ "encoding" },
					{ "filetype" },
				},
			},
		})
	end,
}
