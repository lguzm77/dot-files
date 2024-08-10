return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "AndreM222/copilot-lualine", "folke/noice.nvim" },
	event = "VeryLazy",
	config = function()
		local lualine = require("lualine")
		lualine.setup({
			options = {
				theme = "tokyonight",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
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
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			extensions = { "fugitive", "quickfix", "fzf", "lazy", "mason", "nvim-dap-ui", "oil", "trouble" },
		})
	end,
}
