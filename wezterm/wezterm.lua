-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font("Dank Mono")
config.font_size = 14

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

config.color_scheme = "rose-pine"

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- and finally, return the configuration to wezterm

config.leader = {
	-- Leader key is ctrl-a
	key = "a",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}

config.keys = {

	{
		-- leader+[ leads to copy mode
		key = "[",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
}

local actions = wezterm.action
config.keys = {

	{
		key = "c",
		mods = "LEADER",
		action = actions.SpawnTab("CurrentPaneDomain"),
	},
}

return config
