return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		enable = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "storm",
				dim_inactive = true,
				lualine_bold = true,
			})
			local number_color = "#7aa2f7"
			local number_line_color = "#CEB25E"
			vim.cmd("colorscheme tokyonight")
			vim.api.nvim_set_hl(0, "LineNrAbove", { fg = number_color, bold = true })
			vim.api.nvim_set_hl(0, "LineNr", { fg = number_line_color, bold = true })
			vim.api.nvim_set_hl(0, "LineNrBelow", { fg = number_color, bold = true })
		end,
	},

	{
		"eldritch-theme/eldritch.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
    config = function ()
      vim.cmd("colorscheme eldritch")
      
    end
	}
,
	{
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
	},
}
