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
vim.opt.laststatus = 3 -- lock vim status bar to the bottom

