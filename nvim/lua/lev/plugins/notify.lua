return {
	"rcarriga/nvim-notify",
  event = "VeryLazy",
	config = function()
		local notify = require("notify")
		notify.setup({ top_down = true, width = 30 })
		vim.notify = notify
	end,
}
