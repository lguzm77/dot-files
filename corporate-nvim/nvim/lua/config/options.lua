-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.snacks_animate = false

vim.g.lazyvim_picker = "telescope"

vim.opt.wrap = true

vim.o.clipboard = "unnamedplus"

vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
