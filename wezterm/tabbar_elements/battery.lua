local wezterm = require("wezterm")
local M = {}

function M.get_battery_information()
	local battery_status = ""
	for _, battery in ipairs(wezterm.battery_info()) do
		local charge = battery.state_of_charge * 100
		local emoji = nil
		local state = battery.state

		if state == "Charging" then
			emoji = "⚡"
		elseif state == "Discharging" then
			emoji = "🔋"
		else
			-- Unknown state
			emoji = "🔋❓"
		end

		if charge <= 25 then
			emoji = "🪫"
		elseif charge <= 10 then
			emoji = "🪫⚠️"
		end

		battery_status = emoji .. string.format("%.0f%%", charge)
	end
	return battery_status
end

return M
