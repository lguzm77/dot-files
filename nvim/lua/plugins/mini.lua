return {
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		enabled = true,
		config = function()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = true })

			local pairs = require("mini.pairs")
			pairs.setup()

			local surround = require("mini.surround") -- surround actions
			surround.setup()

			local comment = require("mini.comment")
			comment.setup()
		end,
	},
}
