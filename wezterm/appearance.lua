local module = {}
local wezterm = require("wezterm")
local HOME = os.getenv("HOME")

function module.set_up_appearance(config)
	wezterm.add_to_config_reload_watch_list(HOME .. "/.cache/wal/wezterm-wal.toml")
	config.color_scheme_dirs = { HOME .. "/.cache/wal/" }
	config.color_scheme = "wezterm-wal"
end

return module
