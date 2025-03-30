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
	group = vim.api.nvim_create_augroup("lsp-buffer-management", { clear = true }),
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local clients = vim.lsp.get_active_clients()
		for _, client in ipairs(clients) do
			vim.lsp.buf_attach_client(bufnr, client.id)
		end
	end,
})

local function is_oil_buffer(bufnr)
	local filetype = vim.api.nvim_buf_get_option(bufnr or 0, "filetype")
	return filetype == "oil"
end

vim.api.nvim_create_autocmd("BufDelete", {
	desc = "Detach lsp client when a buffer is closed",
	group = vim.api.nvim_create_augroup("lsp-buffer-management", { clear = true }),
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()

		if is_oil_buffer(bufnr) then
			return
		end

		local clients = vim.lsp.get_active_clients()
		for _, client in ipairs(clients) do
			vim.lsp.buf_detach_client(bufnr, client.id)
		end
	end,
})

local keymap = vim.keymap

-- keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP keymaps",
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf, silent = true }

		opts.desc = "Show LSP references"
		keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

		opts.desc = "Go to declaration"
		keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

		opts.desc = "Show LSP definitions"
		keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>zz", opts) -- show lsp definitions

		opts.desc = "Show LSP implementations"
		keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

		opts.desc = "Show LSP type definitions"
		keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

		opts.desc = "See available code actions"
		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

		opts.desc = "Smart rename"
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

		opts.desc = "Show buffer diagnostics"
		keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

		opts.desc = "Show line diagnostics"
		keymap.set("n", "<leader>dg", vim.diagnostic.open_float, opts) -- show diagnostics for line

		opts.desc = "Go to previous diagnostic"
		keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

		opts.desc = "Go to next diagnostic"
		keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

		opts.desc = "Show documentation for what is under cursor"
		keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

		opts.desc = "Restart LSP"
		keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "oil://*" },
  callback = function()
    vim.keymap.set("n", "h", "<Cmd>lua require('oil').open()<CR>", { buffer = 0 })
    vim.keymap.set("n", "l", "<Cmd>lua require('oil').select()<CR>", { buffer = 0 })
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = { "oil://*" },
  callback = function()
    vim.keymap.del("n", "h", { buffer = 0 }) -- Remove custom keymap on exit
    vim.keymap.del("n", "l", { buffer = 0 }) -- Remove custom keymap on exit
  end,
})
