return {
	{
		"echasnovski/mini.nvim",
    event = "VeryLazy",
		enabled = true,
		config = function()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = true })
		end,
	},
}
