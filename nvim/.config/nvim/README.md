# Lev's Personal NVIM setup

A minimal yet feature-rich Neovim configuration managed via GNU Stow as part of the dot-files repository.

## Structure

| Path | Description |
|------|-------------|
| `init.lua` | Entry point — requires `config` module |
| `lua/config/init.lua` | Module loader (`options`, `keymaps`, `diagnostics`, `autocmds`, `lazy`) |
| `lua/config/options.lua` | Editor options (tabs, search, UI, file handling, splits) |
| `lua/config/keymaps.lua` | Custom keybindings (buffer nav, windows, line movement, editing, terminal) |
| `lua/config/diagnostics.lua` | Diagnostic configuration, highlights, and keymaps |
| `lua/config/autocmds.lua` | Autocommands (checktime, yank highlight, resize, filetype detection) |
| `lua/config/lazy.lua` | Plugin bootstrap and lazy.nvim setup |
| `lua/plugins/` | Plugin specs (currently: `theme.lua`) |
| `lazy-lock.json` | Locked plugin versions |
| `.stylua.toml` | StyLua formatter config |
| `lua/.luarc.json` | Lua LSP config (globals: `vim`) |

## Plugin Manager

Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management. Bootstrap clones lazy.nvim if not present, then imports all specs from `lua/plugins/`.

## Theme

[Cyberdream](https://github.com/scottmckendry/cyberdream.nvim) — loaded eagerly (`lazy = false`, `priority = 1000`) as the default colorscheme.

## Notable Settings

- **Leader key**: Space
- **Clipboard**: Syncs with system clipboard (`unnamedplus`) unless in SSH
- **Line numbers**: Absolute + relative with cursorline
- **Indentation**: 2 spaces, smart indent, expand tabs
- **Undo**: Persistent undo with directory auto-creation
- **Format**: `rg --vimgrep` for grep, `linematch:60` for diffs
- **Conceal**: Level 2 by default, disabled for JSON files
- **Folding**: `expr` method, starts with all folds open

# Backlog

- Configure nvim native LSP [ ]
- Configure treesitter [ ]

