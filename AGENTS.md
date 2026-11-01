# AGENTS.md - Dotfiles Development Guide

Personal dotfiles managed with **GNU Stow** (symlinks) and **Homebrew** (packages).
There is no Nix dependency: `nix/` is legacy and pending deletion.

## Repository Structure

The repo mirrors `$HOME`, so a file's path in the repo is its path on disk.

```
dot-files/
├── setup.sh                     # bootstrap: deps, render, stow, fonts
├── .stowrc                      # stow ignores (no --target; see below)
├── homebrew/Brewfile            # every brew formula and cask
├── macos/defaults.sh            # macOS defaults, idempotent
├── zsh/
│   ├── .zshenv                  # XDG vars + ZDOTDIR  -> ~/.zshenv
│   └── .config/zsh/             # .zprofile, .zshrc   -> ~/.config/zsh/
├── git/.gitconfig.template      # rendered to git/.gitconfig -> ~/.gitconfig
├── starship/.config/starship.toml
├── nvim/.config/nvim/           # canonical Neovim config
├── corporate-nvim/nvim/.config/nvim/  # alternate config (NVIM_CONFIG=corporate-nvim)
├── kitty/.config/kitty/
├── k9s/.config/k9s/
├── fonts/Library/Fonts/         # -> ~/Library/Fonts/
├── agents/                      # portable agent skills and guidelines
│   ├── .agents/                 # -> ~/.agents (AGENTS.md, skills/)
│   ├── .claude/                 # -> ~/.claude/CLAUDE.md, ~/.claude/skills
│   ├── .codex/AGENTS.md         # -> ~/.codex/AGENTS.md
│   └── .config/opencode/        # -> ~/.config/opencode (AGENTS.md, agents/)
└── nix/                         # LEGACY, no longer used
```

## Commands

```bash
./setup.sh              # deps -> render -> stow -> nvim -> fonts
./setup.sh deps         # brew bundle --file homebrew/Brewfile
./setup.sh render       # render gitconfig template
./setup.sh stow         # stow kitty, k9s, starship, zsh, git, agents
./setup.sh nvim         # stow only the Neovim config
./setup.sh fonts        # stow fonts into ~/Library/Fonts
./setup.sh macos        # apply macOS defaults
./setup.sh check        # report missing tools and dangling links
./setup.sh --dry-run all
```

Environment overrides:

```bash
NVIM_CONFIG=corporate-nvim ./setup.sh nvim
GITHUB_NAME=lev GITHUB_EMAIL=lev@example.com ./setup.sh render
DOTFILES_DIR=/path/to/repo ./setup.sh stow
```

Raw stow still works, because the repo mirrors `$HOME` and the default target
is the repo's parent:

```bash
stow --dir=. --target="$HOME" --restow kitty
stow -D --target="$HOME" kitty      # unstow
stow -n -v --target="$HOME" kitty   # dry run
```

`stow` maps a package's **contents** into the target. `nvim/` therefore contains
`.config/nvim/`, not the config files directly.

## Adding a New Config

1. Create the package directory mirroring its real location, e.g.
   `mkdir -p foo/.config/foo` and add the file there.
2. Add `foo` to the package list in `stow_all()` in `setup.sh`.
3. Run `./setup.sh --dry-run stow`, then `./setup.sh stow`.

Rules:

- Prefer `~/.config/...` (XDG) over dotfiles in `$HOME`.
- Never commit rendered output. `git/.gitconfig` is generated and gitignored.
- `.stowrc` holds ignores only. Do not add a global `--target`: packages under
  different roots (fonts, zsh) would silently land in the wrong place.

## Agent Config

`agents/` is one stow package holding portable agent configuration. The rule is
canonical content once, provider paths as links:

```
agents/.agents/AGENTS.md                  canonical guidelines
agents/.agents/skills/<id>/SKILL.md       portable skills (Agent Skills spec)
agents/.claude/CLAUDE.md     -> ../.agents/AGENTS.md
agents/.claude/skills        -> ../.agents/skills
agents/.codex/AGENTS.md      -> ../.agents/AGENTS.md
agents/.config/opencode/AGENTS.md -> ../../.agents/AGENTS.md
agents/.config/opencode/agents/reviewer.md   OpenCode-only subagent
```

- `~/.agents/skills` is read natively by OpenCode and Codex; Claude Code only
  reads `~/.claude/skills`, which is why a link exists.
- Stow this package with `--no-folding`: `~/.codex`, `~/.agents/skills`, and
  `~/.config/opencode` collect their own state (auth, installed skills,
  `cli.json`), and folding them would put that state in the repo.
- Edit the canonical file, never the symlink target at a provider path.
- Adding a skill: `mkdir -p agents/.agents/skills/<id>`, write `SKILL.md` with
  `name` equal to the directory and a specific `description`, re-run
  `./setup.sh stow`.
- Keep provider-specific frontmatter out of the top level; nest it under
  `metadata`.
- Subagent definitions are not portable. Keep the procedure in a skill and make
  the provider agent file a thin wrapper that loads that skill by ID.

## Neovim Configs

`nvim/` is **canonical**. `corporate-nvim/` is an alternate used on work
machines, selected with `NVIM_CONFIG=corporate-nvim`. Only one is linked at a
time, always as `~/.config/nvim`.

When changing behaviour that should exist in both, change `nvim/` first, then
port it. Do not fork a third copy.

## Package Management

`homebrew/Brewfile` is the source of truth. After installing something new:

```bash
brew bundle dump --force --file homebrew/Brewfile
```

Review the diff before committing: the dump includes anything you installed by
hand. Every entry is checked against formulae.brew.sh.

## Code Style

### Shell

- `#!/usr/bin/env bash`, `set -euo pipefail`
- `setup.sh` must stay **bash 3.2 compatible** (macOS ships 3.2): no
  associative arrays, no `mapfile`, no `${var,,}`
- Use `[[ ]]`, `$(...)`, and quote every path
- Quote variables and check `command -v` before calling optional tools

### Lua (Neovim)

Per `nvim/.config/nvim/.stylua.toml`: 80 columns, 2-space indent, double quotes,
trailing commas, no space before call parens.

```lua
local function setup()
  vim.opt.clipboard:append("unnamedplus")
end

vim.keymap.set("n", "<leader>l", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "Format file or range" })
```

### Zsh

- Split by lifecycle: `.zshenv` (everything, fast), `.zprofile` (login env),
  `.zshrc` (interactive)
- Keep `.zshrc` plugin-free; guard optional integrations with `command -v`
- Never add a hand-rolled `PROMPT` when starship is in use

## Formatting and Linting

```bash
stylua nvim/.config/nvim
stylua corporate-nvim/nvim/.config/nvim
shellcheck setup.sh macos/defaults.sh
bash -n setup.sh
zsh -n zsh/.zshenv zsh/.config/zsh/.zprofile zsh/.config/zsh/.zshrc
flake8 --select=E9,F63,F7,F82 kitty/.config/kitty/*.py
yamllint k9s/.config/k9s/config.yaml
```

## Secrets

`git/.gitconfig.template` uses `{{ GITHUB_NAME }}` and `{{ GITHUB_EMAIL }}`.
`./setup.sh render` fills them from the environment, or from the previously
rendered file, or by prompting. Never commit the rendered `git/.gitconfig`.

## Legacy

`nix/` documents the abandoned nix-darwin/home-manager setup. Nothing reads it.
Delete it once `./setup.sh all` is verified on a fresh machine.
