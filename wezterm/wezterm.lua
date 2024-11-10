-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
local actions = wezterm.action

config.font = wezterm.font("Dank Mono")
config.font_size = 14

config.enable_tab_bar = true

config.window_decorations = "RESIZE"

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

config.color_scheme = "rose-pine"

config.leader = {
	-- Leader key is ctrl-a
	key = "s",
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

config.keys = {

	{
		key = "c",
		mods = "LEADER",
		action = actions.SpawnTab("CurrentPaneDomain"),
	},
}

config.keys = {
	{
		key = "n",
		mods = "LEADER",
		action = actions.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = actions.ActivateTabRelative(-1),
	},
}

return config
