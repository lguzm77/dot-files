return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	enabled = true,
	init = false,
	config = function()
		local dashboard = require("alpha.themes.dashboard")

    -- TODO: add a startup timer at the bottom
    -- TODO: Add icons and add a session restore button

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

		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find file", ":Telescope find_files<CR>", {}),

			dashboard.button("r", "  Recent files", ":lua require'telescope.builtin'.oldfiles{}<CR>", {}),

      dashboard.button('m', "Open Mason", ":Mason<CR>"),
      
      dashboard.button('l', "Open Lazy", ":Lazy<CR>"),

			dashboard.button("q", "ﰌ  Quit", ":qa<CR>", {}),
		}
		require("alpha").setup(dashboard.config)
	end,
}
