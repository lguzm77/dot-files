local wezterm = require("wezterm")

local config = wezterm.config_builder()
local tabbar = require("tabbar")
local keybindings = require("keybindings")

-- config.font = wezterm.font("Dank Mono", { weight = "DemiBold", stretch = "Expanded" })
config.font = wezterm.font("JetBrains Mono")
config.font_size = 13
config.line_height = 1.1
config.default_cursor_style = "BlinkingBar"

-- TODO: separate configuration into modules
config.enable_tab_bar = true -- modify title bars
config.use_fancy_tab_bar = false
config.window_frame = {
	font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
	font_size = 11,
}

config.window_decorations = "RESIZE"

config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}

-- Slightly transparent and blurred background
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30

config.color_scheme = "rose-pine-moon"

tabbar.set_up_tabbar()

keybindings.set_up_keybindings(config)

return config
