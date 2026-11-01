# Global agent guidelines

These apply to every repository on this machine, to every agent client
(OpenCode, Codex, Claude Code, and anything else that reads `AGENTS.md`).
A repository's own `AGENTS.md` wins wherever the two disagree.

## Working style

- Read the code before changing it. Do not edit a file you have not opened.
- Make the smallest change that fully solves the problem. No drive-by
  refactors, no reformatting untouched code, no speculative abstractions.
- Match the surrounding code: naming, error handling, comment density, and
  formatting. Consistency beats personal preference.
- Do not add a dependency, tool, or service without asking first.
- When the request is ambiguous, state the assumption you are making and
  proceed. Ask only when the wrong guess would be expensive or destructive.
- Prefer the simplest approach instead of complexity.

## Verify, do not assume

- Run the repository's documented check (build, test, lint, dry-run) after
  changing behavior, and report exactly which commands ran and what they
  printed. Never claim a check passed unless it ran.
- If a check cannot run, say why. A skipped check is not a passing check.
- Never invent file paths, command flags, API endpoints, config keys, or test
  results. Verify against the code, `--help`, or the docs.
- Prefer reading the implementation over recalling how a library usually works.

## Safety

- Never print, log, or commit secrets. Refer to environment variables by name.
- Never commit generated or rendered files that a `.gitignore` excludes.
- Ask before destructive or irreversible actions: `rm -rf`, `git reset --hard`,
  `git push --force`, branch deletion, history rewriting, package uninstalls,
  or anything touching files outside the repository.
- Never push to a shared branch with force, and never commit directly to
  `main` unless explicitly asked.

## Git

- Use the `commit-and-pr` skill for commit messages and pull requests.
- One logical change per commit. Keep refactors separate from behavior changes.
- Commit messages explain *why* the change exists, not just what changed.
- Review `git diff --staged` before committing. Stage deliberately, not with
  `git add -A`.

## Reviewing

- Use the `code-review` skill when asked to review a diff, branch, or PR.
- Findings first, ordered by severity, each with `path:line` and a concrete fix.
- Do not restate the diff or pad the review with praise.

## Reporting back

- Lead with the result: what changed, what you verified, what is still open.
- Give file paths so the user can open them. Use inline code for commands.
- Keep replies short. Do not narrate every tool call.
- If you could not finish something, say so plainly and say what remains.

## Portable skills

- Skills live in `.agents/skills/<id>/SKILL.md` (this repo, via
  `~/.agents/skills`).
- Follow the Agent Skills spec: `name` matches the directory, lowercase
  kebab-case, `description` present and specific.
- Keep provider-specific frontmatter out of the top level; put it under
  `metadata` so other clients ignore it instead of failing.
