return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
			"folke/todo-comments.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
    cmd= "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy find files in cwd" },
			{ "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find string in cwd" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local transform_mod = require("telescope.actions.mt").transform_mod

			local trouble = require("trouble")

			-- custom trouble action
			local custom_actions = transform_mod({
				open_trouble_qflist = function(prompt_bufnr)
					trouble.toggle("quickfix")
				end,
			})

			telescope.setup({
				defaults = {
					wrap_results = true,
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
					},
					path_display = { "shorten" },
					layout_config = {
						horizontal = {
							preview_width = 0.7, -- toggle preview window size
						},
					},
					mappings = {
						-- insert mode mappings
						i = {
							["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						},
					},
				},
			})

			-- customize previewer
			vim.api.nvim_create_autocmd("User", {
				pattern = "TelescopePreviewerLoaded",
				callback = function(args)
					vim.wo.wrap = true
					vim.wo.number = true
				end,
			})

			-- TODO: check what other extensions are available to you.
			-- Do any enhance your workflow? Why?
			telescope.load_extension("fzf")
			telescope.load_extension("noice")
			-- TODO: what does this extension do?
			telescope.load_extension("ui-select")

			local keymap = vim.keymap
			local builtin = require("telescope.builtin")

			keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })

			keymap.set("n", "<leader>fw", function()
				local current_buffer_name = vim.api.nvim_buf_get_name(0)
				builtin.grep_string({ search_dirs = { current_buffer_name } })
			end, { desc = "Find word under cursor in current buffer" })
			keymap.set("n", "<leader>fd", builtin.grep_string, { desc = "Find word under cursor in cwd" })

			keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
			keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })
			keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "search commits for buffer" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
    event = "BufReadPre",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
