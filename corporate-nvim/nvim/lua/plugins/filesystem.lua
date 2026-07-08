return {
  "stevearc/oil.nvim",
  keys = {
    { "<leader>e", "<cmd>Oil<CR>", desc = "Open parent directory" },
  },
  opts = {
    preview_window = { enable = false },
    columns = {
      "icon",
    },
    sort = {
      { "type", "asc" },
      { "name", "asc" },
    },

    default_file_explorer = true,

    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      natural_order = true,
      is_hidden_file = function(name, _)
        return name == ".." or name == ".git"
      end,
    },

    win_options = { wrap = true },
  },
}
