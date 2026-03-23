return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = false, -- Use latest commit for best LazyVim compatibility
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      enabled = vim.fn.executable("make") == 1,
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    {
      "nvim-telescope/telescope-ui-select.nvim",
      config = function()
        require("telescope").load_extension("ui-select")
      end,
    },
  },
  keys = {
    -- Files
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fF", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files (hidden)" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
    { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
    -- Search
    { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep (root dir)" },
    { "<leader>sG", "<cmd>Telescope live_grep cwd=~<cr>", desc = "Grep (home)" },
    { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Word under cursor" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer fuzzy find" },
    -- Vim / LSP
    { "<leader>fb", "<cmd>Telescope buffers sort_mru=true<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
    -- Git
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
    { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
  },
  opts = function()
    local actions = require("telescope.actions")

    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        preview = {
          wrap = true, -- wrap preview window text
        },
        -- Performance
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
          "%.cache/",
          "dist/",
          "build/",
          "%.lock",
          "__pycache__/",
          "%.DS_Store",
        },
        -- Layout
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = { preview_width = 0.55, prompt_position = "top" },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        sorting_strategy = "ascending",
        winblend = 0,
        -- Mappings
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-u>"] = false, -- clear prompt (default)
            ["<C-d>"] = actions.delete_buffer,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
            ["<C-s>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
          },
          n = {
            ["q"] = actions.close,
            ["<C-d>"] = actions.delete_buffer,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = {
          -- Use ripgrep if available, fall back to fd, then find
          find_command = (function()
            if vim.fn.executable("rg") == 1 then
              return { "rg", "--files", "--follow", "--color=never" }
            elseif vim.fn.executable("fd") == 1 then
              return { "fd", "--type=f", "--follow" }
            end
          end)(),
        },
        buffers = {
          previewer = false,
          layout_config = { width = 0.6, height = 0.5 },
          mappings = { i = { ["<C-d>"] = actions.delete_buffer } },
        },
        live_grep = {
          additional_args = { "--hidden", "--glob=!.git/" },
        },
        lsp_references = { show_line = false },
        lsp_definitions = { show_line = false },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    }
  end,
}
