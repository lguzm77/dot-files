local plugins = {
  statusline = {
    use_icons = true,
  },
  pairs = {}, -- navigate easier between symbol pairs
  surround = {}, -- wrap around words
  comment = {}, -- commenting keybdings
  sessions = {}, -- session management
  tabline = {}, -- tabs
  ai = {}, --text objects
  operators = {},
  bracketed = {},
}

return {
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    enabled = true,
    config = function()
      for name, config in pairs(plugins) do
        require(string.format("mini.%s", name)).setup(config)
      end
    end,
  },
}
