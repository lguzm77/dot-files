local module = {}
local wezterm = require("wezterm")
local HOME = os.getenv("HOME")

function module.set_up_appearance(config)
	wezterm.add_to_config_reload_watch_list(HOME .. "/.cache/wal/wezterm-wal.toml")
	config.color_scheme_dirs = { HOME .. "/.cache/wal/" }
	config.color_scheme = "wezterm-wal"

	-- Tab color configuration
  -- TODO: change tab bar background
	config.colors = {
		tab_bar = {
			-- The color of the strip that goes along the top of the window
			-- (does not apply when fancy tab bar is in use)
			-- background = config.color_schemes['wezterm-wal'].background,
		},
	}
end

return module
