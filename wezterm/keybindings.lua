local wezterm = require("wezterm")

local projects = require("projects")

local module = {}

local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

-- config borrowed from
-- https://github.com/mrjones2014/smart-splits.nvim
local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

function module.set_up_keybindings(config)
	config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 }
	config.keys = {
		-- splitting
		{
			mods = "LEADER",
			key = "v",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			mods = "LEADER",
			key = "h",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			--maximize a window
			mods = "LEADER",
			key = "m",
			action = wezterm.action.TogglePaneZoomState,
		},
		-- rotate panes
		{
			mods = "LEADER",
			key = "Space",
			action = wezterm.action.RotatePanes("Clockwise"),
		},
		-- show the pane selection mode, but have it swap the active and selected panes
		{
			mods = "LEADER",
			key = "0",
			action = wezterm.action.PaneSelect({
				mode = "SwapWithActive",
			}),
		},
		-- move between split panes
		split_nav("move", "h"),
		split_nav("move", "j"),
		split_nav("move", "k"),
		split_nav("move", "l"),
		-- resize panes
		split_nav("resize", "h"),
		split_nav("resize", "j"),
		split_nav("resize", "k"),
		split_nav("resize", "l"),
		{
			key = "t",
			mods = "LEADER",
			action = wezterm.action.ShowTabNavigator,
		},
		-- Spawn a new tab
		{
			key = "a",
			mods = "LEADER",
			action = wezterm.action.SpawnTab("CurrentPaneDomain"),
		},
		-- move between tabs
		{
			key = "l",
			mods = "LEADER",
			action = wezterm.action.ActivateTabRelative(1),
		},
		{

			key = "h",
			mods = "LEADER",
			action = wezterm.action.ActivateTabRelative(-1),
		},
		{
			key = "x",
			mods = "LEADER",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},
		{
			key = "w",
			mods = "LEADER",
			action = wezterm.action.CloseCurrentTab({ confirm = true }),
		},
		{
			key = "p",
			mods = "LEADER",
			-- Present in to our project picker
			action = projects.choose_project(),
		},
		{
			key = "f",
			mods = "LEADER",
			-- Present a list of existing workspaces
			action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
		},
		{
			key = "r",
			mods = "LEADER",
			action = wezterm.action.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, _, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
	}
end

return module
