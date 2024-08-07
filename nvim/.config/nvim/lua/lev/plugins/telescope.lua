return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			-- This will not install any breaking changes.
			-- For major updates, this must be adjusted manually.
			version = "^1.0.0",
		},
    -- TODO: integrate neoclip
	},
	cmd = "Telescope",
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy find files in cwd" },
		{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Find symbols LSP" },
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

		local telescopeConfig = require("telescope.config")
		-- Clone the default Telescope configuration
		local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

		-- I want to search in hidden/dot files.
		table.insert(vimgrep_arguments, "--hidden")
		-- I don't want to search in the `.git` directory.
		table.insert(vimgrep_arguments, "--glob")
		table.insert(vimgrep_arguments, "!**/.git/*")

		telescope.setup({
			defaults = {
				wrap_results = true,
				vimgrep_arguments = vimgrep_arguments,
				path_display = { "truncate" },
				layout_config = { horizontal = { preview_width = 0.6 } },
				mappings = {
					-- insert mode mappings
					-- -- TODO: why aren't these mappings working?
					i = {
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-j>"] = actions.cycle_history_next,
						["<C-k>"] = actions.cycle_history_prev,
						["<C-s>"] = actions.cycle_previewers_next,
						["<C-a>"] = actions.cycle_previewers_prev,
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
				pickers = {
					find_files = {
						-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
				},
			},
		})

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
		telescope.load_extension("noice")
		-- TODO: what does this extension do?
		telescope.load_extension("ui-select")
		vim.g.zoxide_use_select = true

		telescope.load_extension("live_grep_args")

		-- Set keymaps. TODO: can you extract this to a separate file?
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
			"<leader>gb",
			"<cmd>Telescope git_bcommits<cr>",
			{ desc = "search git commits for current buffer" }
		)
		keymap.set(
			"n",
			"<leader>fg",
			"<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
			{ desc = "Live Grep" }
		)
	end,
}
