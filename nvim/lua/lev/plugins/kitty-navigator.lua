return {
	"MunsMan/kitty-navigator.nvim",
  event = "VeryLazy",
	build = { "cp navigate_kitty.py ~/.config/kitty", "cp pass_keys.py ~/.config/kitty" },
	opts = {
		keybindings = {
			left = "<C-h>",
			down = "<C-j>",
			up = "<C-k>",
			right = "<C-l>",
		},
	},
}
