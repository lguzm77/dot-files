-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local non_recursive_option = {
  noremap = true,
}

-- Delete default lazyim keymaps
local keymapdelete = vim.keymap.del
keymapdelete("n", "<leader>-")
keymapdelete("n", "<leader>|")

local keymapset = vim.keymap.set

keymapset("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymapset("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymapset("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymapset("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Window navigation
-- Move window
keymapset("n", "sh", "<C-w>h")
keymapset("n", "sk", "<C-w>k")
keymapset("n", "sj", "<C-w>j")
keymapset("n", "sl", "<C-w>l")

-- Buffer navigation
keymapset("n", "<C-d>", "<C-d>zz", non_recursive_option) -- zz centers your cursor
keymapset("n", "<C-u>", "<C-u>zz", non_recursive_option)
keymapset("n", "<C-f>", "<C-f>zz", non_recursive_option)
keymapset("n", "<C-b>", "<C-b>zz", non_recursive_option)

keymapset("n", "n", "nzzzv", non_recursive_option)
keymapset("n", "N", "Nzzzv", non_recursive_option)

-- greatest remap ever, search and replace all occurrences of the current buffer with your register's content
keymapset(
  "v",
  "<leader>p",
  '"_dP',
  { unpack(non_recursive_option), desc = "Search and replace all occurrences with your register's content" }
)
