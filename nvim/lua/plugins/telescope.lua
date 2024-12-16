-- some local functions
local function live_grep_from_project_git_root()
	local function is_git_repo()
		vim.fn.system("git rev-parse --is-inside-work-tree")

		return vim.v.shell_error == 0
	end

	local function get_git_root()
		local dot_git_path = vim.fn.finddir(".git", ".;")
		return vim.fn.fnamemodify(dot_git_path, ":h")
	end

	local opts = {}

	if is_git_repo() then
		opts = {
			cwd = get_git_root(),
		}
	end

	require("telescope.builtin").live_grep(opts)
end

local function find_files_from_project_git_root()
	local function is_git_repo()
		vim.fn.system("git rev-parse --is-inside-work-tree")
		return vim.v.shell_error == 0
	end
	local function get_git_root()
		local dot_git_path = vim.fn.finddir(".git", ".;")
		return vim.fn.fnamemodify(dot_git_path, ":h")
	end
	local opts = {}
	if is_git_repo() then
		opts = {
			cwd = get_git_root(),
		}
	end
	require("telescope.builtin").find_files(opts)
end

return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
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
		{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Find symbols LSP" },
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--trim", -- add this value
					"--hidden",
					-- do not search within .git directories
					"--glob",
					"!**/.git/*",
				},
			},
			pickers = {
				find_files = {
					theme = "ivy",
				},
				live_grep = {
					theme = "ivy",
				},
			},
			extensions = {
				fzf = {},
			},
		})

		telescope.load_extension("fzf")
		vim.g.zoxide_use_select = true

		-- customize previewer
		-- TODO: can you make this be dynamic?
		vim.api.nvim_create_autocmd("User", {
			pattern = "TelescopePreviewerLoaded",
			callback = function(args)
				vim.wo.wrap = true
				vim.wo.number = true
			end,
		})

		local keymap = vim.keymap
		local builtin = require("telescope.builtin")

		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>ff", find_files_from_project_git_root, { desc = "Find files from git root" })

		keymap.set("n", "<leader>fw", function()
			local current_buffer_name = vim.api.nvim_buf_get_name(0)
			-- TODO: how do you execute a vim command using the api? So we can remove the builtin import
			builtin.grep_string({ search_dirs = { current_buffer_name } })
		end, { desc = "Find word under cursor in current buffer" })

		keymap.set("n", "<leader>fd", builtin.grep_string, { desc = "Find word under cursor in cwd" })
		keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })
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
		keymap.set("n", "<leader>fg", live_grep_from_project_git_root)
		-- TODO: why doesn't this work?
		-- require("config.telescope.multigrep").setup() -- custom grep picker
	end,
}
