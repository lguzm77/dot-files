-- For custom callbacks
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Only attach lsp client to open buffers",
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local clients = vim.lsp.get_active_clients()
		for _, client in ipairs(clients) do
			vim.lsp.buf_attach_client(bufnr, client.id)
		end
	end,
})

vim.api.nvim_create_autocmd("BufUnload", {
  desc = "Detach lsp client when a buffer is closed",
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local clients = vim.lsp.get_active_clients()
		for _, client in ipairs(clients) do
			vim.lsp.buf_detach_client(bufnr, client.id)
		end
	end,
})
