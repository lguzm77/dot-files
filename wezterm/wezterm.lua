local wezterm = require("wezterm")

local tabbar = require("tabbar")
local keybindings = require("keybindings")
local appearance = require("appearance")
local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 13
config.line_height = 1.1
config.default_cursor_style = "BlinkingBar"
config.native_macos_fullscreen_mode = true

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true
config.window_frame = {
	font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
	font_size = 10,
}

config.tab_max_width = 32

config.window_decorations = "RESIZE"

config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}

config.mouse_bindings = {
  -- Open URLs with CMD+Click
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor,
  }
}

-- Slightly transparent and blurred background
config.window_background_opacity = 0.95
config.macos_window_background_blur = 15

appearance.set_up_appearance(config)

tabbar.set_up_tabbar()

keybindings.set_up_keybindings(config)

return config
