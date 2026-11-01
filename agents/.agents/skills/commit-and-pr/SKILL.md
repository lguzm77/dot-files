---
name: commit-and-pr
description: Writes git commit messages and GitHub pull requests in the repo's house style: a short imperative subject and a body that explains why, with an honest verification section. Use when committing, amending, squashing, or opening a pull request.
---

# Commit and PR messages

The subject says what changed. The body says why it had to change and what you
verified. Nothing else belongs there.

## 1. Read the existing style first

```bash
git log --format="%s" -20              # subject style
git log --format="--- %s%n%b" -5       # body style
ls .github/PULL_REQUEST_TEMPLATE.md .github/ISSUE_TEMPLATE 2>/dev/null
```

Match what is there. If the repo already uses Conventional Commits
(`feat:`, `fix:`), use it. If it does not, do not introduce it.

## 2. Commit subject

- Imperative mood, as if completing: "Add", "Fix", "Remove", "Mirror", "Drop".
  Not "Added", "Fixes", "Adding".
- Capitalized, no trailing period.
- Roughly 50 characters, hard limit 72.
- Name the change, not the file: "Reject empty hostname in config loader", not
  "Update config.ts".
- No prefixes, emoji, or ticket numbers unless the repo already does that.

## 3. Commit body

Write the body when the reason is not obvious from the subject. Blank line after
the subject. Wrap at 72 columns.

Structure that works:

1. **Problem paragraph** — what was wrong or missing, and what broke because of
   it. Facts, not adjectives.
2. **Approach paragraph** — why this fix rather than the alternatives, if there
   was a real choice.
3. **Bullets** — the notable parts, when the change spans several files or
   areas. `- ` not `*`, one line each where possible, name files or commands.

Example, matching the style used in this repo:

```
Mirror $HOME in the stow layout

stow maps a package's contents into the target, so a flat layout like
nvim/init.lua with --target=~/.config produced ~/.config/init.lua.

Each package now contains the path it should occupy at $HOME:

  nvim/.config/nvim/...   kitty/.config/kitty/...

That makes one --target=$HOME correct for every package, so .stowrc no
longer needs a target and 'stow .' works.
```

Rules:

- Explain *why*. A body that only lists files is noise.
- State behavior changes and migration steps explicitly.
- Do not include tool or model attribution, and do not mention that an agent
  wrote the commit, unless the user asks for it.
- Do not claim verification you did not do. "Verified with `./setup.sh
  --dry-run stow`" is fine only if that command ran and passed.

## 4. Stage deliberately

```bash
git status --short
git add -p                             # review each hunk
git diff --staged                      # what is actually going in
```

- One logical change per commit. Refactors go in their own commit, before the
  behavior change, so the diff stays reviewable.
- Never `git add -A` without reading `git status` first.
- Never commit generated output that `.gitignore` excludes, rendered templates,
  or secrets.
- If unrelated changes are already staged, unstage them rather than bundling.

Commit with a heredoc so formatting survives:

```bash
git commit -F - <<'MSG'
Mirror $HOME in the stow layout

stow maps a package's contents into the target, so a flat layout produced
~/.config/init.lua instead of ~/.config/nvim/init.lua.
MSG
```

## 5. Amending and squashing

- Amend only commits that are not pushed, or are pushed only to your own branch
  and nobody else has based work on them.
- Never rewrite a shared branch: `main`, release branches, or anything with
  other authors' commits on top.
- Prefer `git commit --fixup <sha>` plus `git rebase -i --autosquash` over a pile
  of "fix typo" commits.

## 6. Pull requests

Title: same rules as a commit subject. It is what appears in the changelog.

Body sections, omit any that would be empty:

```markdown
## Summary

One or two sentences: what this PR changes and why it exists.

## Changes

- Package layout now mirrors `$HOME`; every package uses one stow target.
- `setup.sh` gained `--dry-run` and per-package conflict clearing.

## Verification

- `./setup.sh --dry-run stow` — clean, no conflicts.
- `./setup.sh stow && nvim` — config loads, no startup errors.
- Not covered: fresh-machine run (needs a clean home).

## Notes

Follow-ups, risks, or decisions a reviewer might question.

Closes #42
```

```bash
gh pr create --title "Mirror \$HOME in the stow layout" --body-file - <<'BODY'
## Summary
...
BODY
```

Rules:

- Verification lists commands that actually ran, with their real outcome. An
  untested area goes under "Not covered" — never omitted, never implied.
- Link issues with `Closes #N` when the PR resolves them.
- Keep the body readable in a terminal. No HTML, no screenshots of text.
- Do not open a PR for work that does not build or run unless it is a draft, and
  say so in the title (`Draft:` prefix or `--draft`).
- Never force-push a branch under review without saying what changed and why;
  prefer adding commits, then squash at merge if the repo does that.
