# How do I add an LSP?

- Create a new lua file to hold the LSP configuration. e.g pyright.lua
- Search [nvim-lsp-config](https://github.com/neovim/nvim-lspconfig/tree/master/lsp) for your language's LSP config. These configs are designed to work with nvim's native LSP system.
- Copy the content's file and paste it into the new file.
- Enable the new lsp in /lua/config/lsp.lua by adding a new entry to `vim.lsp.enable`

```
 vim.lsp.enable({
  ../
  "new_lsp_name"
  })
```

