local keymap = vim.keymap

local non_recursive_option = {
	noremap = true, -- non-recursive
}
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")
-- greatest remap ever, search and replace all occurrences of the current buffer with your register's content
keymap.set("v", "<leader>p", '"_dP', non_recursive_option)
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
-- keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
-- keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- TODO: Add descriptions to each command
--
-- Resize with arrows
-- delta: 2 lines
keymap.set("n", "<C-Up>", ":resize -2<CR>", non_recursive_option)
keymap.set("n", "<C-Down>", ":resize +2<CR>", non_recursive_option)
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", non_recursive_option)
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", non_recursive_option)

-- Hint: start visual mode with the same area as the previous area and the same mode
keymap.set("v", "<", "<gv", non_recursive_option)
keymap.set("v", ">", ">gv", non_recursive_option)

-- center cursor when moving vertically
-- Navigation and centering is handled by cinnamon.lua
keymap.set("n", "n", "nzzzv", non_recursive_option)
keymap.set("n", "N", "Nzzzv", non_recursive_option)

vim.api.nvim_set_keymap("n", "{", "{zz", non_recursive_option)
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", non_recursive_option) -- zz centers your cursor
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", non_recursive_option)
vim.api.nvim_set_keymap("n", "<C-f>", "<C-f>zz", non_recursive_option)
vim.api.nvim_set_keymap("n", "<C-b>", "<C-b>zz", non_recursive_option)

vim.api.nvim_set_keymap("n", "}", "}zz", non_recursive_option)

-- Goodies from TJ DeVries
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "source current file" })
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")
