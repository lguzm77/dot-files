-- We almost always start by importing the wezterm module
local wezterm = require("wezterm")
-- Define a lua table to hold _our_ module's functions
local module = {}

function module.set_up_appearance(config)
		config.color_scheme = "Kanagawa (Gogh)"
end

return module
