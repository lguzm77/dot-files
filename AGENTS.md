# AGENTS.md - Dotfiles Development Guide

This is a **dotfiles repository** managed by GNU Stow. It contains configuration files for shell, Neovim, terminal emulators, git, and other development tools.

## Repository Structure

```
dot-files/
├── .zprofile              # Zsh environment variables (sourced first)
├── setup.sh               # Bootstrap script for new machines
├── .stowrc                # Stow configuration
├── aerospace/             # Tiling window manager config
├── corporate-nvim/        # Work-specific Neovim config
├── ghostty/               # Ghostty terminal config
├── git/                   # Git configuration & .gitconfig
├── homebrew/              # Homebrew dependencies list
├── k9s/                   # Kubernetes terminal UI config
├── kitty/                 # Kitty terminal config
├── nvim/                  # Neovim configuration (main)
├── shell/                 # Additional shell scripts
├── starship/              # Starship prompt config
├── wal/                   # pywal color schemes
├── wezterm/               # Wezterm terminal config
└── zsh/                   # Zsh configuration & plugins
```

---

## Build/Lint/Test Commands

### Symlink Management (Stow)

```bash
# Preview what stow will do without making changes
stow --dry-run .

# Apply all stow packages (creates symlinks in ~/.config)
stow .

# Stow specific package
stow nvim
stow zsh

# Restow (recreate symlinks) after config changes
stow -R nvim

# Unstow (remove symlinks)
stow -D nvim
```

### Bootstrap New Machine

```bash
# Full setup (dependencies, shell, render templates, symlinks)
./setup.sh

# Run individual steps
./setup.sh dependencies
./setup.sh shell
./setup.sh render
./setup.sh symlinks
```

### Code Formatting

```bash
# Format all Lua files (Neovim configs)
stylua nvim/**/*.lua
stylua wezterm/**/*.lua

# Format specific file
stylua nvim/init.lua
```

### Linting

```bash
# Shell scripts
shellcheck setup.sh
shellcheck shell/*.sh

# Lua files
luacheck nvim/lua/

# Python files
flake8 --select=E9,F63,F7,F82 --show-source --statistics kitty/pass_keys.py
flake8 --select=E9,F63,F7,F82 --show-source --statistics kitty/navigate_kitty.py

# YAML files (ensure yamllint is installed)
yamllint k9s/config.yaml
yamllint aerospace/aerospace.toml
```

---

## Code Style Guidelines

### General Principles

1. **XDG Base Directory Specification**: Config files go in `$XDG_CONFIG_HOME` (`~/.config`)
2. **No hardcoded paths**: Use environment variables like `$HOME`, `$XDG_CONFIG_HOME`
3. **Cross-platform awareness**: Some configs are macOS-specific (Homebrew paths)

---

### Lua (Neovim & Wezterm)

**Style Rules** (per `.stylua.toml`):

```lua
-- Column width: 80
-- Indentation: 2 spaces (no tabs)
-- Quote style: Double quotes preferred
-- No space after function names: require "module"
-- Trailing commas: Yes
-- Line endings: Unix

-- CORRECT
local function setup()
  vim.opt.clipboard:append("unnamedplus")
end

-- INCORRECT
local function setup( ) -- no spaces in parens
  vim.opt.clipboard:append( 'unnamedplus' ) -- single quotes
end

-- Module pattern for Wezterm
local module = {}

function module.set_up_keybindings(config)
  -- ...
end

return module
```

**Lua LSP Configuration**:
- Add `vim` to `diagnostics.globals` in `.luarc.json`
- Use `vim.` functions without lint warnings

**Lazy Plugin Spec Pattern**:
```lua
return {
  {
    "plugin/repo",
    event = "VeryLazy",  -- or "BufReadPre", etc.
    dependencies = { "dep1", "dep2" },
    opts = {},
    config = function(_, opts)
      -- setup code
    end,
  },
}
```

---

### Shell Scripts (Bash/Zsh)

```bash
# Shebang: use #!/usr/bin/env bash
#!/usr/bin/env bash

# Local variables with local
local var="value"

# Use [[ ]] for conditionals (not [ ])
if [[ "$var" == "value" ]]; then
  echo "match"
fi

# Check command existence before use
if command -v brew > /dev/null; then
  echo "brew exists"
fi

# Use $() for command substitution (not backticks)
path=$(pwd)

# Always quote variables containing paths
ln -s "$PWD/.zprofile" "$HOME/.zprofile"

# Use set -e to exit on error
set -e

# Use set -u to error on undefined variables
set -u
```

---

### Configuration Files

**TOML** (Aerospace, Starship, stylua):
```toml
# Standard TOML syntax
[section]
key = "value"
nested.key = 123

# Arrays
items = ["a", "b", "c"]
```

**YAML** (k9s):
```yaml
# Standard YAML (2-space indent)
key: value
nested:
  key: value
```

**Ghostty Config**:
```bash
# ghostty uses key=value syntax (no quotes needed)
font-family = Fira Code
font-size = 12

# Keybindings
keybind = ctrl+s>r=reload_config
```

**Kitty Config**:
```bash
# INI-style with sections
# Comments use #

[section]
key value

# Maps
map cmd+shift+t new_tab_with_cwd
```

---

### Git Configuration

- Use `.gitconfig.template` for sensitive data
- Template variables: `{{ GITHUB_EMAIL }}`, `{{ GITHUB_NAME }}`
- Render template with `sed` before use

```bash
sed "s/{{ GITHUB_EMAIL }}/$email/g" .gitconfig.template |
  sed "s/{{ GITHUB_NAME }}/$name/g" > .gitconfig
```

---

### Neovim Keymaps

```lua
-- Use <leader> for user commands
vim.keymap.set("n", "<leader>rp", function_name, { noremap = true, silent = true })

-- Use descriptive { desc = "" } for leader keys
vim.keymap.set("n", "<leader>l", function()
  conform.format({ lsp_fallback = true })
end, { desc = "Format file or range" })
```

---

### Error Handling

**Shell**:
```bash
# Exit on error
set -e

# Print commands before executing
set -x

# Exit on undefined variable
set -u
```

**Lua**:
```lua
-- Use vim.validate for argument checking
vim.validate({
  name = { value, "string", true },
})

-- Use pcall for protected calls
local ok, result = pcall(some_function, arg)
if not ok then
  vim.notify("Error: " .. result, vim.log.levels.ERROR)
end
```

---

### Dependencies

**Homebrew packages** are tracked in `homebrew/leaves.txt` (formulae) and the setup script installs casks separately.

To update dependencies on leaving a machine:
```bash
brew leaves > ./homebrew/leaves.txt
```

---

### Editor Setup

- **EDITOR**: Set to `nvim` in `.zprofile`
- **XDG Compliance**: All configs go to `$XDG_CONFIG_HOME`
- **Plugins**: Use LazyVim/LazyNvim plugin manager for Neovim
