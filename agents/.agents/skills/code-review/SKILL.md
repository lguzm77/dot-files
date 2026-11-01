---
name: code-review
description: Reviews a git diff, branch, commit, or pull request for correctness, regressions, security problems, and missing tests. Use when asked to review changes, check a PR, audit a commit, or double-check work before merging.
---

# Code review

Review the change, not the request. A finding with no file, line, or fix is not
a finding.

## 1. Establish scope

Ask which review this is when it is not obvious, then gather the exact diff:

```bash
git status --short                     # what is even in flight
git diff                               # unstaged
git diff --staged                      # staged
git diff main...HEAD                   # branch vs base
git log --oneline main..HEAD           # commits under review
gh pr diff <number>                    # PR
gh pr view <number> --json title,body,files
```

Read the commit messages: they should explain why the change exists. If a diff
and its message disagree, that is a finding.

## 2. Read enough context

Do not review hunks in isolation. For every changed file, open the whole file
around the change and read the callers of anything whose signature, return
value, or behavior changed:

```bash
git diff --stat
git diff -U20                         # wider context
rg -n "functionName" --type-add 'code:*.{ts,tsx,js,lua,sh,py,nix}' -tcode
```

Check for the same problem elsewhere: if a bug pattern appears once, grep for
the other copies instead of letting the author fix only the reported site.

## 3. What to look for

In priority order:

1. **Broken behavior** — wrong condition, inverted check, off-by-one, missing
   `await`, swallowed error, unhandled empty/null case, race, wrong default.
2. **Regressions** — behavior another caller depended on that silently changed.
3. **Data and security** — unvalidated input reaching a shell, file path, SQL,
   or template; secrets or tokens in code, logs, or committed files; widened
   permissions; destructive commands without a guard.
4. **Missing verification** — behavior change with no test, or a test that
   would pass even if the change were reverted.
5. **Resource and lifecycle** — leaked handles or listeners, unbounded growth,
   missing cleanup, work repeated per item that belongs outside the loop.
6. **Conventions** — violations of the repository's `AGENTS.md` or obvious
   local patterns. Lowest priority; never block on taste.

Use [references/checklist.md](references/checklist.md) for language specifics.

## 4. Report

Output, in this order:

```markdown
## Findings

### Blocker — src/server.ts:142
The retry loop reuses `attempt` after it is reset, so a failed request can
retry forever. Move the reset outside the loop.

### Should fix — scripts/setup.sh:88
Path is unquoted; the package name with a space splits into two arguments.
Quote `"$dir/$pkg"`.

### Nit — README.md:12
"recieve" -> "receive".

## Checked
- Ran `bun test` (2 failures, both pre-existing on main).
- Traced callers of `loadConfig`, no other call site passes the old shape.

## Not reviewed
- Vendored code under `vendor/`, and the generated migration SQL.
```

Rules:

- Severity: **Blocker** (must fix before merge), **Should fix** (real defect,
  not urgent), **Nit** (style, wording, preference).
- Every finding gets `path:line`, the reason, and the concrete change.
- No findings is a valid answer. Say what you checked so the claim is credible.
- Do not restate the diff, do not praise, do not pad. Order findings by
  severity, not by file.
- If something is uncertain, label it uncertain and say what would settle it.
- For a diff too large to review honestly, review by area and list what was
  skipped rather than skimming and implying full coverage.

## 5. Stay read-only

Review means review. Do not edit files, do not stage, do not commit, do not run
tests that mutate state or touch the network. When the user asks for fixes after
the review, hand the findings back and let the main agent apply them.
