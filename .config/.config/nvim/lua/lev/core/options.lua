local opt = vim.opt

opt.clipboard:append("unnamedplus") -- use system clipboard as default register
opt.termguicolors = true

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.g.mapleader = " "

vim.wo.number = true
vim.wo.relativenumber = true

vim.cmd("cd %:p:h") -- set current directory as base

vim.cmd("set wrap")
vim.cmd("set breakindent")
vim.cmd("set linebreak")
vim.cmd("set foldlevel=20") -- how deep do we want our folds to go
vim.cmd("set foldmethod=expr")
vim.cmd("set foldexpr=nvim_treesitter#foldexpr()") -- treesitter dependency
--vim.opt.nofoldenable = true
vim.opt.foldlevelstart = 99

opt.laststatus = 3 -- lock vim status bar to the bottom

opt.swapfile = false
opt.backup = false
opt.signcolumn = "yes"
opt.scrolloff = 20 -- how many lines to show above and below cursor
opt.conceallevel = 2
