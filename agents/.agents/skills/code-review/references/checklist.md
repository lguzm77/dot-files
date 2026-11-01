# Review checklist by language

Load the section that matches the diff. Skip anything the change does not touch;
a checklist entry that does not apply is noise that hides the real finding.

## Shell (bash / zsh)

- `set -euo pipefail` present in scripts meant to fail fast; note that `set -e`
  does not fire inside `cmd || true`, `if`, or pipeline left-hand sides.
- Every expansion quoted: `"$var"`, `"$@"`, `"${arr[@]}"`. Unquoted paths break
  on spaces, which macOS home directories and repo names routinely have.
- `[ ]` vs `[[ ]]` — use `[[ ]]` in bash; `[ ]` is correct and portable in sh.
- Command substitution in `$(...)`, never backticks.
- `command -v foo >/dev/null` before calling optional tools.
- `local` for function variables; no reliance on undeclared globals.
- Cleanup via `trap` when the script creates temp files or changes directory.
- GNU vs BSD differences on macOS: `sed -i` needs an argument, `readlink -f`
  does not exist, `date -d` does not exist, `grep -P` is unavailable.
- **bash 3.2** (macOS system bash): no associative arrays, no `mapfile`,
  no `${var,,}` / `${var^^}`, no `&>>`.
- Loops over `$(find ...)` break on whitespace; prefer `while IFS= read -r`.

## Zsh

- Startup files split by lifecycle: `.zshenv` (all shells, keep fast),
  `.zprofile` (login), `.zshrc` (interactive only).
- Optional integrations guarded with `command -v`, so a missing tool cannot
  break every new shell.
- No hand-rolled `PROMPT` when a prompt framework is configured.
- `autoload -Uz` before `compinit`, `compinit` guarded against re-running.

## Lua / Neovim

- `vim.keymap.set` with `desc`, `noremap` semantics are the default in
  `vim.keymap.set`; do not pass the removed `vim.api.nvim_set_keymap` options.
- Plugin specs return a table of specs; `lazy = false` only for colorschemes and
  things that must load before `VeryLazy`.
- Use `pcall` around calls that may error in startup code, and `vim.notify`
  with a level instead of `print` for user-facing errors.
- `vim.validate` for public function arguments.
- Formatting: `stylua` with the repo's config; do not hand-format around it.
- `lazy-lock.json` is generated. Never hand-edit; regenerate with `:Lazy`.

## Python

- Mutable default arguments, bare `except:`, `is` vs `==`, shadowed builtins.
- `subprocess` with `shell=True` and interpolated input is a finding.
- Path handling through `pathlib`, not string concatenation.
- Resources in `with`; `open()` without a context manager leaks on error.

## YAML / TOML / JSON config

- Indentation errors that parse but change meaning (YAML anchors, list nesting).
- A key that is silently ignored because it is misspelled or misplaced: check it
  against the consumer's schema or docs rather than eyeballing.
- Duplicate keys: YAML silently keeps the last, JSON parsers vary.
- Secrets or machine-specific absolute paths committed into shared config.
- Values quoted where a type matters (`"8080"` vs `8080`, `"yes"` as a boolean).

## Docs and instruction files

- Commands in the doc actually work as written (copy-paste, not from memory).
- Paths and file names exist in the repo.
- `AGENTS.md` / `README.md` still match the code after the change. Stale docs are
  a real defect: they cause the next agent or human to do the wrong thing.
- No claim stronger than the evidence ("fully tested" when one case ran).

## Tests

- Does the test fail if the change is reverted? If not, it proves nothing.
- Assertions on behavior, not on implementation internals that will churn.
- No network, wall-clock, or filesystem-order dependence without a guard.
- New branch of logic covered; error path covered, not just the happy path.

## Git hygiene

- Rendered or generated files not staged (`.gitconfig`, lockfiles that are
  ignored, build output).
- No unrelated formatting churn mixed into a behavior change.
- No secrets in the diff, including deleted lines that remain in history.
- Commit message matches the change; one logical change per commit.
