return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	enabled = true,
	init = false,
	config = function()
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			[[　　　 　　/＾>》, -―‐‐＜＾}]],
			[[　　　 　./:::/,≠´::::::ヽ.]],
			[[　　　　/::::〃::::／}::丿ハ]],
			[[　　　./:::::i{l|／　ﾉ／ }::}]],
			[[　　 /:::::::瓜イ＞　´＜ ,:ﾉ]],
			[[　 ./::::::|ﾉﾍ.{､　(_ﾌ_ノﾉイ＿]],
			[[　 |:::::::|／}｀ｽ /          /]],
			[[.　|::::::|(_:::つ/ ThinkPad /　neovim!]],
			[[.￣￣￣￣￣￣￣＼/＿＿＿＿＿/￣￣￣￣￣]],
		}

		vim.api.nvim_create_autocmd("User", {
			once = true,
			pattern = "LazyVimStarted",
			callback = function()
				local stats = require("lazy").stats()
				local ms = stats.startuptime
				dashboard.section.footer.val = "⚡ Neovim loaded "
					.. stats.loaded
					.. "/"
					.. stats.count
					.. " plugins in "
					.. ms
					.. "ms"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})

		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find file", ":Telescope find_files<CR>", {}),

			dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>", {}),

			dashboard.button("s", "Restore session for cwd", ":SessionRestore<CR>", {}),

			dashboard.button("m", "Mason", ":Mason<CR>"),

			dashboard.button("l", "Lazy", ":Lazy<CR>"),

			dashboard.button("q", "ﰌ  Quit", ":qa<CR>", {}),
		}
		require("alpha").setup(dashboard.config)
	end,
}
