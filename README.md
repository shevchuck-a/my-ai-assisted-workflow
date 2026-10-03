# AI-Assisted Workflow Skills

This repository contains reusable Codex skills for an AI-assisted software
development workflow. Skills are organized into two groups:

- **Delivery Workflow** skills support day-to-day task delivery.
- **Engineering** skills support architecture, design, and documentation work.

Each directory beneath either group that contains a `SKILL.md` file is treated
as one skill.

## Included skills

### Delivery Workflow

- `task-discussion` — clarify a coding task interactively and record an agreed
  branch-scoped discussion. After confirmation, return bounded work for direct
  implementation or automatically delegate larger or uncertain scopes to one
  context-isolated ticket worker.
- `to-tickets` — split an approved task definition into small, implementation-
  ready tickets with dependencies and acceptance criteria. Standalone use asks
  for breakdown approval; the explicit discussion handoff uses confirmation
  as authorization for generation and alignment.
- `implement-ticket` — implement one bounded coding change from a direct
  request, approved discussion, or local ticket.
- `code-review` — independently review local changes, a branch diff, or a pull
  request for defects, regressions, security issues, and requirement gaps.

After each confirmed discussion revision, generated tickets are aligned with the
new scope, including removal of obsolete tickets. If the revised task becomes
bounded, its previous generated tickets are removed and the discussion becomes
the implementation input. Alignment is limited to that discussion's generated
tickets; unrelated artifacts are preserved.

The handoff returns exact artifact paths, compact ticket descriptions,
dependencies, and a recommended starting ticket. If isolated delegation is
unavailable or fails, the confirmed discussion is preserved, incomplete ticket
generation or alignment is reported, and an exact `$to-tickets <discussion-path>`
manual retry is provided. Implementation always requires a separate request.

### Engineering

- `architecture-review` — assess a repository or subsystem for evidence-backed
  architecture problems, guardrail gaps, and documentation gaps.
- `codebase-design` — recommend a focused design for modules, interfaces,
  seams, dependencies, and testability.
- `repository-docs` — create, audit, or synchronize human and AI-facing
  repository documentation.

## Use the skills locally

Create symlinks in your Codex skills directory:

```bash
./scripts/install-skills.sh
```

Remove the symlinks later:

```bash
./scripts/uninstall-skills.sh
```

By default, the scripts use `~/.codex/skills`. Set `CODEX_HOME` to use another
Codex home directory. Both scripts leave unrelated files and links untouched.
