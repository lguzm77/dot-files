local pluginsToConfig = {
	statusline = {
		config = {
			use_icons = true,
		},
	},
	pairs = {
		config = {},
	},
	surround = {
		config = {},
	},
	comment = {
		config = {},
	},
	sessions = {
		config = {},
	},
	tabline = {
		config = {},
	},
}

return {
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		enabled = true,
		config = function()
			for pluginName, config in pairs(pluginsToConfig) do
				require(string.format("mini.%s", pluginName)).setup(config.config)
			end
		end,
	},
}
