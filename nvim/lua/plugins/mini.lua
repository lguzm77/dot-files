local plugins = {
	statusline = {
		use_icons = true,
	},
	pairs = {},
	surround = {}, -- wrap around words 
	comment = {},
	sessions = {},
	tabline = {},
	ai = {}, --text objects
  operators = {},
}


return {
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		enabled = true,
		config = function()
			for name, config in pairs(plugins) do
				require(string.format("mini.%s", name)).setup(config)
			end
		end,
	},
}
