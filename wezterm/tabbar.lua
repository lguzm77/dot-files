local wezterm = require("wezterm")
local module = {}

local function get_battery_information()
	local bat = ""
	for _, b in ipairs(wezterm.battery_info()) do
		bat = "🔋" .. string.format("%.0f%%", b.state_of_charge * 100)
	end
	return bat
end

-- configure tab line
local function segments_for_right_status(window)
	-- this returns a table of strings
	return {
		window:active_workspace(),
		-- Format is based on rust chrono https://docs.rs/chrono/0.4.19/chrono/format/strftime/index.html
		wezterm.strftime("%a %b %-d %I:%M %p"),
		get_battery_information(),
		wezterm.hostname(),
	}
end



function module.set_up_tabbar()
	wezterm.on("update-status", function(window, _)
		local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
		local segments = segments_for_right_status(window)

		local color_scheme = window:effective_config().resolved_palette
		-- Note the use of wezterm.color.parse here, this returns
		-- a Color object, which comes with functionality for lightening
		-- or darkening the colour (amongst other things).
		local bg = wezterm.color.parse(color_scheme.background)
		local fg = color_scheme.foreground

		-- Each powerline segment is going to be coloured progressively
		-- darker/lighter depending on whether we're on a dark/light colour
		-- scheme. Let's establish the "from" and "to" bounds of our gradient.
		local gradient_to, gradient_from = bg, nil
		-- we are only in dark color
		gradient_from = gradient_to:lighten(0.2)

		-- Yes, WezTerm supports creating gradients, because why not?! Although
		-- they'd usually be used for setting high fidelity gradients on your terminal's
		-- background, we'll use them here to give us a sample of the powerline segment
		-- colours we need.
		local gradient = wezterm.color.gradient(
			{
				orientation = "Horizontal",
				colors = { gradient_from, gradient_to },
			},
			#segments -- only gives us as many colours as we have segments.
		)

		-- We'll build up the elements to send to wezterm.format in this table.
		local elements = {}

		for i, seg in ipairs(segments) do
			local is_first = i == 1

			if is_first then
				table.insert(elements, { Background = { Color = color_scheme.background } })
			end
			table.insert(elements, { Foreground = { Color = gradient[i] } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })

			table.insert(elements, { Foreground = { Color = fg } })
			table.insert(elements, { Background = { Color = gradient[i] } })
			table.insert(elements, { Text = " " .. seg .. " " })
		end

		window:set_right_status(wezterm.format(elements))
	end)

	-- second listener that shows if the leader key is active
	wezterm.on("update-right-status", function(window, _)
		local SOLID_LEFT_ARROW = ""

		local color_scheme = window:effective_config().resolved_palette

		local ARROW_FOREGROUND = { Foreground = { Color = color_scheme.foreground } }
		local prefix = ""

		if window:leader_is_active() then
			prefix = " " .. utf8.char(0x1F5FF) -- moyai 
			SOLID_LEFT_ARROW = utf8.char(0xe0b2)
		end

		if window:active_tab():tab_id() ~= 0 then
			ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
		end -- arrow color based on if tab is first pane

		window:set_left_status(wezterm.format({
			{ Background = { Color = color_scheme.background } },
			{ Text = prefix },
			ARROW_FOREGROUND,
			{ Text = SOLID_LEFT_ARROW },
		}))
	end)
end


return module
