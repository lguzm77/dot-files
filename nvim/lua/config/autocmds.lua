-- For custom callbacks
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup(
    "kickstart-highlight-yank",
    { clear = true }
  ),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local keymap = vim.keymap
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP keymaps",
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local options = { buffer = ev.buf, silent = true }

    options.desc = "Show LSP references"
    keymap.set("n", "gR", vim.lsp.buf.references, options) -- show definition, references

    options.desc = "Go to declaration"
    keymap.set("n", "gD", vim.lsp.buf.declaration, options) -- go to declaration

    options.desc = "Show LSP definitions"
    keymap.set("n", "gd", vim.lsp.buf.definition, options) -- show lsp definitions

    options.desc = "Show LSP implementations"
    keymap.set("n", "gi", vim.lsp.buf.implementation, options) -- show lsp implementations

    options.desc = "Show LSP type definitions"
    keymap.set("n", "gt", vim.lsp.buf.type_definition, options) -- show lsp type definitions

    options.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, options) -- see available code actions, in visual mode will apply to selection

    options.desc = "Smart rename"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, options) -- smart rename

    options.desc = "Show buffer diagnostics"
    keymap.set("n", "<leader>D", vim.diagnostic.get, options) -- show  diagnostics for file

    options.desc = "Show line diagnostics"
    keymap.set("n", "<leader>dg", vim.diagnostic.open_float, options) -- show diagnostics for line

    options.desc = "Go to previous diagnostic"
    keymap.set("n", "[d", vim.diagnostic.goto_prev, options) -- jump to previous diagnostic in buffer

    options.desc = "Go to next diagnostic"
    keymap.set("n", "]d", vim.diagnostic.goto_next, options) -- jump to next diagnostic in buffer

    options.desc = "Show documentation for what is under cursor"
    keymap.set("n", "K", vim.lsp.buf.hover, options) -- show documentation for what is under cursor

    options.desc = "Restart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", options) -- mapping to restart lsp if necessary
  end,
})
