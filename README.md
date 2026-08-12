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
  branch-scoped discussion before planning or implementation.
- `to-tickets` — split an approved task definition into small, implementation-
  ready tickets with dependencies and acceptance criteria.
- `implement-ticket` — implement one bounded coding change from a direct
  request, approved discussion, or local ticket.
- `code-review` — independently review local changes, a branch diff, or a pull
  request for defects, regressions, security issues, and requirement gaps.

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
