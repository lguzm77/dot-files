return {
	"rcarriga/nvim-notify",
	config = function()
		local notify = require("notify")
		notify.setup({ top_down = false, width = 30 })
		vim.notify = notify
	end,
}
