local plugins = {
	statusline = {
		use_icons = true,
	},
	pairs = {}, -- navigate easier between symbol pairs
	surround = {}, -- wrap around words
	comment = {}, -- commenting keybdings
	sessions = {}, -- session management
	tabline = {}, -- tabs
	ai = {}, --text objects
	operators = {},
	bracketed = {},
	files = {
		windows = {
			width_preview = math.floor(0.3 * vim.o.columns),
			preview = true,
		},
	}, -- filesystem
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

			vim.keymap.set("n", "<leader>e", ":lua MiniFiles.open()<cr>", { desc = "Open filesystem" })
		end,
	},
}
