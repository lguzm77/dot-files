return {
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	enable = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("tokyonight").setup({
	-- 			style = "storm",
	-- 			dim_inactive = true,
	-- 			lualine_bold = true,
	-- 		})
	-- 		local number_color = "#7aa2f7"
	-- 		local number_line_color = "#CEB25E"
	-- 		vim.cmd("colorscheme tokyonight")
	-- 		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = number_color, bold = true })
	-- 		vim.api.nvim_set_hl(0, "LineNr", { fg = number_line_color, bold = true })
	-- 		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = number_color, bold = true })
	-- 	end,
	-- },
	-- {
	-- 	"eldritch-theme/eldritch.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {},
	-- 	config = function()
	-- 		vim.cmd("colorscheme eldritch")
	-- 	end,
	-- },

	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				variant = "moon", -- auto, main, moon, or dawn
				dark_variant = "moon", -- main, moon, or dawn
				dim_inactive_windows = true,
				extend_background_behind_borders = true,

				enable = {
					terminal = true,
					legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
					migrations = true, -- Handle deprecated options automatically
				},

				styles = {
					bold = true,
					italic = true,
					transparency = true,
				},

				-- Transparent telescope
				highlight_groups = {
					TelescopeBorder = { fg = "highlight_high", bg = "none" },
					TelescopeNormal = { bg = "none" },
					TelescopePromptNormal = { bg = "base" },
					TelescopeResultsNormal = { fg = "subtle", bg = "none" },
					TelescopeSelection = { fg = "text", bg = "base" },
					TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
				},

				groups = {
					border = "muted",
					link = "iris",
					panel = "surface",

					error = "love",
					hint = "iris",
					info = "foam",
					note = "pine",
					todo = "rose",
					warn = "gold",

					git_add = "foam",
					git_change = "rose",
					git_delete = "love",
					git_dirty = "rose",
					git_ignore = "muted",
					git_merge = "iris",
					git_rename = "pine",
					git_stage = "iris",
					git_text = "rose",
					git_untracked = "subtle",

					h1 = "iris",
					h2 = "foam",
					h3 = "rose",
					h4 = "gold",
					h5 = "pine",
					h6 = "foam",
				},
			})

			vim.cmd("colorscheme rose-pine")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "AndreM222/copilot-lualine", "folke/noice.nvim" },
		event = "VeryLazy",
		config = function()
			local lualine = require("lualine")
			lualine.setup({
				options = {
					theme = "auto",
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
