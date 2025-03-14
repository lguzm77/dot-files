vim.keymap.set("t", "qq", "<c-\\><c-n>", { desc = "escape terminal mode" })

local current_terminal_id = 1
local terminal_states = {
	[1] = { floating = { buf = -1, win = -1 } },
	[2] = { floating = { buf = -1, win = -1 } },
}

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	-- Calculate the position to center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create a buffer
	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	end

	-- Define window configuration
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal", -- No borders or extra UI elements
		border = "rounded",
		title = string.format("%s/%s", tostring(current_terminal_id), tostring(#terminal_states)),
	}

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

local toggle_terminal = function(terminal_id)
	local state = terminal_states[terminal_id]
	-- Toggle visibility
	if vim.api.nvim_win_is_valid(state.floating.win) then
		vim.api.nvim_win_hide(state.floating.win)
	else
		-- Create window
		state.floating = create_floating_window({ buf = state.floating.buf })
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
		end
	end
end

local rotate_terminal = function()
	if #terminal_states == 0 then
		return
	end

	toggle_terminal(current_terminal_id)

	current_terminal_id = (current_terminal_id % #terminal_states) + 1

	toggle_terminal(current_terminal_id)
end

local rotate_previous_terminal = function()
	if #terminal_states == 0 then
		return
	end

	toggle_terminal(current_terminal_id)

	current_terminal_id = (current_terminal_id - 2 + #terminal_states) % #terminal_states + 1

	toggle_terminal(current_terminal_id)
end

-- Create a floating window with default dimensions

vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, { desc = "toggle floating terminal" })

vim.keymap.set({ "n", "t" }, "<leader>tt", function()
	toggle_terminal(current_terminal_id)
end, { desc = "toggle floating terminal" })

vim.keymap.set("t", "<leader>tn", function()
	rotate_terminal()
end, { desc = "next terminal" })

vim.keymap.set("t", "<leader>tp", function()
	rotate_previous_terminal()
end, { desc = "previous terminal" })
