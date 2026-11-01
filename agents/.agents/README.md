# Agent skills and guidelines

Portable agent configuration: written once, read by every agent client.

```
.agents/
├── AGENTS.md                 # canonical global guidelines
├── README.md                 # this file
└── skills/
    ├── code-review/SKILL.md
    ├── commit-and-pr/SKILL.md
    └── neovim-config/SKILL.md
.claude/
├── CLAUDE.md -> ../.agents/AGENTS.md
└── skills    -> ../.agents/skills
.codex/
└── AGENTS.md -> ../.agents/AGENTS.md
.config/opencode/
├── AGENTS.md -> ../../.agents/AGENTS.md
└── agents/reviewer.md        # OpenCode-only subagent wrapper
```

Stowed with `target=$HOME`, so the canonical files land at `~/.agents/` and the
symlinks land at each client's expected path.

## Why this layout

`.agents/skills` is the open [Agent Skills](https://agentskills.io) location.
Clients read it directly:

| Client      | Reads `~/.agents/skills` | Needs the symlink |
| ----------- | ------------------------ | ----------------- |
| Codex       | yes                      | no                |
| OpenCode    | yes                      | no                |
| Claude Code | no                       | `.claude/skills`  |

Global guidelines have no shared location, so the canonical file is symlinked to
each client's path:

| Client      | Path                              |
| ----------- | --------------------------------- |
| Codex       | `~/.codex/AGENTS.md`              |
| OpenCode    | `~/.config/opencode/AGENTS.md`    |
| Claude Code | `~/.claude/CLAUDE.md`             |

Edit `.agents/AGENTS.md`; the copies follow. Never edit through a symlink at the
client path and expect the change to live only there.

## Adding a skill

1. `mkdir -p .agents/skills/<id>` — the directory name is the skill ID.
2. Write `SKILL.md` with frontmatter:

   ```markdown
   ---
   name: <id>
   description: What it does and when to use it, with trigger words.
   ---
   ```

3. Put long reference material in `references/`, scripts in `scripts/`.
   Paths inside the skill are relative to its directory.
4. Validity rules: `name` matches the directory, lowercase kebab-case, no
   leading or trailing hyphen, `description` under 1024 characters.
5. Run `./setup.sh stow` from the repo, then check the skill appears in the
   client's skill list.

Keep `SKILL.md` under roughly 150 lines. Only `name` and `description` are
loaded up front; the body loads on demand, so do not put anything there that a
wrong trigger would waste.

Provider-specific frontmatter (`metadata.opencode/autoinvoke`,
`disable-model-invocation`, `context: fork`) is optional and ignored elsewhere.
Put such keys under `metadata`, never as bare top-level keys that another client
might reject.

## Scope

- `~/.agents/skills` — personal, applies to every project. Keep it small; a
  permanent context cost is paid on every session.
- `<repo>/.agents/skills` — project-specific. Prefer this for anything that
  encodes one repository's conventions.

## Subagents

Subagent definitions are not portable: OpenCode reads `.config/opencode/agents/`,
Claude Code reads `.claude/agents/`, Codex has no equivalent. Keep the procedure
in a portable skill and make the per-client agent file a thin wrapper that loads
that skill by ID, so there is one source of truth.
