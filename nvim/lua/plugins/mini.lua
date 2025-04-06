local pluginsToConfig = {
	statusline = {
		use_icons = true,
	},
	pairs = {},
	surround = {},
	comment = {},
	sessions = {},
	tabline = {},
	ai = {},
}

return {
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		enabled = true,
		config = function()
			for pluginName, config in pairs(pluginsToConfig) do
				require(string.format("mini.%s", pluginName)).setup(config)
			end
		end,
	},
}
