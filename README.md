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
  request, approved discussion, or local ticket. Standalone use requires explicit
  commit authorization; an orchestration child has ticket-scoped commit authority.
- `implement-discussion` — on a separate explicit request, implement an approved
  ticket set through one fresh, context-isolated `implement-ticket` child at a
  time, verify local commits, and record progress in `execution.md`.
- `code-review` — independently review local changes, a branch diff, or a pull
  request for defects, regressions, security issues, and requirement gaps.

After each confirmed discussion revision, generated tickets are aligned with the
new scope, including removal of obsolete tickets and alignment of the compact
`execution.md` beside `discussion.md`. The record links the source, repository,
branch, ticket definitions, blockers, progress, and commit references. Changed
definitions invalidate obsolete completion. If the revised task becomes bounded,
its previous generated tickets and owned execution record are removed and the
discussion becomes the implementation input. Alignment is limited to that
discussion's generated artifacts; unrelated artifacts are preserved.

The handoff returns exact artifact paths, compact ticket descriptions,
dependencies, the exact execution-record path, and a recommended starting ticket.
If isolated delegation is unavailable or fails, the confirmed discussion is
preserved, incomplete ticket
generation or alignment is reported, and an exact `$to-tickets <discussion-path>`
manual retry is provided. Implementation always requires a separate request.

Use `$implement-ticket implement <discussion-or-ticket-path>` for bounded work
or individual tickets. Optionally request
`$implement-discussion <discussion-path-or-execution-path>` for the approved set.
This explicit orchestration request authorizes scoped local implementation and
commits. The parent owns execution progress; each child may update only its own
ticket's status after implementation, permitted automatic verification, and a
successful commit. Discussion and ticket specifications stay unchanged.
`.codex-tasks/` is ignored local progress; actual Git commits supply independent
implementation evidence. Neither flow authorizes remote Git operations or review.

Required permitted checks must run. Completion and an already-authorized scoped
commit may coexist with proven unrelated pre-existing failures only when the
required ticket behavior remains verified and no explicit clean-check requirement
is unmet. Evidence must establish pre-existence, unrelatedness, and baseline
equivalence: the same relevant diagnostic at an identified pre-ticket revision/state
with equivalent command/scope, inputs, and environment. Historical unverified
reports or unchanged affected paths alone are insufficient. Uncertain attribution,
environment/permission blockers, unavailable required verification, and baseline
errors masking required behavior prevent completion. Task regressions still
require bounded correction or stopping; expected TDD RED is intermediate and
required behavior checks must reach GREEN when test-first applies.

Collect baseline evidence within existing permissions, without modifying production
code to manufacture a baseline, repairing unrelated errors, or weakening tests.
Child completion evidence, the parent's existing `execution.md` reconciliation
field, reconciliation of completed rows, and final reports retain each exempted
check's concise diagnostic, affected files, baseline proof, and why required
behavior remains verified. Report residual errors visibly; never claim all checks
passed. Suggest follow-up tickets only, without automatic creation/implementation,
unrelated repairs, replanning, decomposition/review, or detailed error artifacts.
Commit/scope/status validation, definition hashes, ownership, manual gates, and
explicit recovery boundaries remain binding; this exception grants no new authority.

Orchestration preserves the same lifecycle-running child and execution
`in-progress` through silence, wait timeouts, elapsed time, absent replies, or
unchanged files. Parent and child share compact stage changes and long-check
start/end updates, including observed times and known active check/process or
session identity. Pending tool calls may delay replies; no strict heartbeat is
required. The parent ordinarily waits up to 60 seconds per call, keeps user
updates concise, and avoids repeated nudges, short wait/sleep loops, and full logs.

After five minutes without observable progress, the parent asks once whether to
keep waiting or interrupt. Actual progress resets the inactivity interval; the
threshold is a notification, never a ticket deadline. An unanswered choice keeps
the same child and `in-progress` without repeated prompts. Choosing to wait starts
a new full five-minute notification interval from that answer or later progress,
without granting future cancellation authority. Only an actual interrupt choice
or applicable stop request authorizes interruption. Further launches stop, and a
stopped claim requires lifecycle confirmation; an unconfirmed stop retains
`in-progress` with advancement prevented. Confirmed interruption records `blocked`
and the observed stage/outcome, preserves edits, and requires explicit recovery
without guessing the cause of silence.

If the execution record is missing, orchestration waits for a choice between
explicitly authorizing parent creation from existing ticket metadata and
addressing `to-tickets` first. Failures stop further implementation and preserve
partial edits; there is no automatic retry, replacement child, or skipped ticket.
An explicit resume reconciles commits, status, and progress before continuation;
ambiguous evidence or changed definitions requires user resolution.

Completed implementation is separate from manual acceptance. Deferrable manual
checks accumulate for final user verification; a prerequisite manual check pauses
before dependent work and waits for the required input. Existing test creation
and execution permissions remain in effect. Request `code-review` separately.

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
