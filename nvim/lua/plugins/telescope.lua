return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		-- TODO: integrate neoclip
	},
	cmd = "Telescope",
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy find files in cwd" },
		{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Find symbols LSP" },
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup({})

		-- customize previewer
		-- TODO: can you make this be dynamic?
		vim.api.nvim_create_autocmd("User", {
			pattern = "TelescopePreviewerLoaded",
			callback = function(args)
				vim.wo.wrap = true
				vim.wo.number = true
			end,
		})

		telescope.load_extension("fzf")
		vim.g.zoxide_use_select = true

		local keymap = vim.keymap
		local builtin = require("telescope.builtin")

		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })

		keymap.set("n", "<leader>fw", function()
			local current_buffer_name = vim.api.nvim_buf_get_name(0)
			-- TODO: how do you execute a vim command using the api? So we can remove the builtin import
			builtin.grep_string({ search_dirs = { current_buffer_name } })
		end, { desc = "Find word under cursor in current buffer" })

		keymap.set("n", "<leader>fd", builtin.grep_string, { desc = "Find word under cursor in cwd" })

		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })
		keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "search git commits" })
		keymap.set(
			"n",
			"<leader>gbf",
			"<cmd>Telescope git_bcommits<cr>",
			{ desc = "search git commits for current buffer" }
		)
		keymap.set("n", "<leader>ep", function()
			require("telescope.builtin").find_files({
				cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
			})
		end)

		require("plugins.modules.multigrep").setup() -- custom grep picker
	end,
}
