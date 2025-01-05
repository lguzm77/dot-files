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
}

return {
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		enabled = true,
		config = function()
			for name, properties in pairs(pluginsToConfig) do
				require(string.format("mini.%s", name)).setup(properties.config)
			end
		end,
	},
}
