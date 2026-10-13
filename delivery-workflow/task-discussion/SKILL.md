---
name: task-discussion
description: Interview the user interactively to reach a shared understanding of a coding or repository task before planning or implementation. Use when requirements are incomplete, ambiguous, risky, or contain meaningful implementation choices. Explore the repository to resolve facts, ask one implementation-relevant decision at a time with a recommended answer, and after explicit user confirmation write a structured discussion artifact under the current branch at .codex-tasks/branches/{branch-key}/{task-id}/discussion.md. After confirmation, return bounded tasks for direct implementation or delegate generation of tickets and a compact execution record for larger or uncertain scopes. Do not modify product code or begin implementation.
---

# Task Discussion

Build a shared, explicit understanding of the task before planning or implementation.

## Core behavior

Interview the user thoroughly about every implementation-relevant aspect of the task until both sides reach a shared understanding.

Walk down the meaningful branches of the decision tree and resolve dependencies between decisions in order. Ask exactly one question at a time and wait for the user's answer before continuing.

For every question:

- explain why the decision matters;
- provide a recommended answer;
- give a short rationale;
- offer concise alternatives when useful.

Do not ask multiple questions in one message.

## Facts versus decisions

Resolve facts by exploring the environment instead of asking the user.

Use available repository and filesystem tools to determine facts such as:

- existing architecture and conventions;
- relevant files, symbols, configuration, and tests;
- current behavior;
- available APIs and abstractions;
- established verification commands;
- repository-specific constraints.

Ask the user only about decisions that cannot be settled reliably from repository evidence.

A decision belongs to the user when it materially affects one or more of:

- user-visible behavior;
- task scope;
- architecture or public interfaces;
- failure handling;
- compatibility;
- data integrity or security;
- external side effects;
- operational cost;
- verification expectations;
- trade-offs between multiple valid approaches.

Do not ask about trivial, reversible implementation details unless they create a meaningful trade-off. Follow clear repository conventions for those details.

Never silently convert an unresolved decision into an assumption. If the user explicitly delegates a class of decisions, record that delegation and apply it only within the stated scope.

## Test strategy decision

When the task changes production behavior and automated code-level tests are
in scope, explicitly resolve the implementation test strategy before
confirming the discussion.

Unless the user has already specified a preference, ask whether the behavior
should be implemented test-first.

Recommend test-first development by default:

1. express the required behavior in an automated test;
2. verify that the test fails for the expected behavioral reason;
3. implement the smallest production change that makes it pass;
4. refactor only while the relevant tests remain green.

Do not ask this question for documentation-only, configuration-only, or other
tasks where code-level behavioral tests are clearly not applicable.

Do not infer the expected test behavior from a proposed implementation.
Derive it from confirmed requirements, decisions, and acceptance criteria.

Record the confirmed choice under `Confirmed Decisions` and reflect the
authorized test execution under `Verification Expectations`.

If the user explicitly delegates test strategy, record that delegation and
apply the recommended test-first approach unless repository constraints make
it unsuitable.

## Investigation discipline

Inspect only files relevant to resolving the current fact or decision.

Prefer targeted searches and focused file reads. Do not perform broad repository exploration without a concrete need.

Keep a compact internal record of:

- confirmed user requirements;
- repository facts and evidence;
- decisions already resolved;
- decisions still blocked by dependencies;
- explicit user delegations;
- out-of-scope items.

Do not repeat a question that the user has already answered directly or indirectly.

## Interview flow

1. Read the user's task description.
2. Identify the task goal and likely decision areas.
3. Explore the repository to resolve facts before asking questions.
4. Identify the next unresolved decision whose dependencies are already resolved.
5. Ask exactly one question with a recommendation and rationale.
6. Wait for the answer.
7. Record the decision and reconsider the remaining decision tree.
8. Continue until no implementation-relevant decisions remain unresolved.
9. Summarize the shared understanding concisely.
10. Ask the user to confirm that the shared understanding is complete.
11. Only after explicit confirmation, save the discussion artifact, then perform the post-confirmation handoff below. For a confirmed revision, update the same artifact and align its generated tickets.

If new repository evidence invalidates an earlier assumption or decision context, explain the conflict and ask the user to revisit only the affected decision.

## Confirmation boundary

Do not modify product code, configuration, tests, pipelines, or external systems during this skill.

Do not begin implementation planning or implementation during the interview. After confirmation, only the scope assessment and delegated ticket decomposition described below are allowed; never start implementation.

Do not create the final artifact until the user explicitly confirms that shared understanding has been reached.

Allowed writes are the confirmed discussion artifact and its parent directory, its resulting recommendation, and generation or alignment of its own tickets and compact execution record after confirmation. Ticket and execution-record drafting belong exclusively to the delegated worker. When a confirmed revision becomes bounded, the discussion agent may remove its prior generated tickets and record as described below. Never modify unrelated task artifacts.

## ## Branch, task ID, and artifact path

Resolve `<repository-root>` with:

`git rev-parse --show-toplevel`

If the current directory is not inside a Git repository, use the current working directory and record that fallback in the artifact.

Resolve the current Git branch with:

`git branch --show-current`

Preserve the original branch name for artifact metadata.

Create `<branch-key>` as a lowercase filesystem-safe form of the branch name:

- allow only lowercase letters, digits, and hyphens;
- replace path separators and other unsupported characters with hyphens;
- collapse repeated hyphens;
- trim leading and trailing hyphens.

If Git is in detached HEAD state, use `detached-<short-commit-sha>` as the branch key and record that detached state in metadata.

Use this artifact path:

<repository-root>/.codex-tasks/branches/<branch-key>/<task-id>/discussion.md

Resolve `<task-id>` as follows:

1. If the user supplied a task or ticket ID, use a lowercase filesystem-safe form of it.
2. Otherwise generate `<YYYYMMDD-HHMM>-<short-task-slug>`.
3. Allow only lowercase letters, digits, and hyphens.
4. Keep the ID concise and stable for the remainder of the task.
5. Check for collisions only inside the current branch directory.
6. If the target directory already exists for an unrelated task, append `-2`, `-3`, and so on.
7. Never overwrite an unrelated task artifact.

Create the directory only after the user confirms the shared understanding.

## Artifact contents

Write `discussion.md` with this structure:

```markdown
# Task Discussion

## Metadata

- Task ID: `<task-id>`
- Repository root: `<absolute-path>`
- Branch: `<original-git-branch-name>`
- Branch key: `<branch-key>`
- Status: `confirmed`
- Created: `<ISO-8601 timestamp>`

## Goal

<Concise description of the desired outcome.>

## Confirmed Requirements

- <Requirement>

## Repository Findings

- `<path or symbol>` — <relevant fact and why it matters>

## Confirmed Decisions

### D1 — <Decision title>

- Decision: <confirmed choice>
- Rationale: <reason or trade-off>
- Alternatives considered: <brief alternatives, or `None`>

## Delegated Decisions

- <Any decision category the user explicitly delegated, or `None`>

## Acceptance Criteria

- [ ] <Observable completion criterion>

## Verification Expectations

- <Checks the user expects or authorizes>
- <When automated tests are in scope, state whether test-first execution is required and which local test execution is authorized>

## Constraints and Risks

- <Constraint or risk>

## Out of Scope

- <Explicit exclusion>

## Unresolved Items

- `None`

## Recommended Next Step

<After the post-confirmation handoff, record the actual result: direct `implement-ticket` invocation using this exact discussion path for a bounded task; the resulting ticket paths, exact execution.md path, and recommended starting ticket for a completed breakdown; or incomplete ticket/record generation/alignment, known partial/stale paths, and an exact manual `to-tickets` invocation using this discussion path.>

Do not reinterpret confirmed decisions without returning to the user.
```

Use `None` explicitly for empty sections. Do not omit sections silently.

## Post-confirmation scope assessment and handoff

Confirmation authorizes decomposition within the saved scope and alignment of tickets and `execution.md` generated from it, including replacement of edited tickets or statuses and removal of obsolete generated artifacts. The execution record lives beside the discussion and links its source, repository/branch identity, ticket definitions and blockers, progress, and commit references under the `to-tickets` contract. No separate breakdown or replacement approval is needed for this automatic handoff. It does not authorize implementation.

After saving each confirmed discussion or revision:

1. Assess boundedness using the existing `implement-ticket` scope gate and already established findings. Direct implementation is suitable when there is one primary behavioral outcome, clear requirements, one coherent code area, no missing product, architectural, migration, or risk decision, and safe review without decomposition. Multiple independent outcomes, several subsystems, broad refactoring, or more than about five production files for unrelated reasons suggest decomposition. File count is a qualified signal: an explicitly named atomic mechanical change may involve more files.
2. If clearly bounded, skip `to-tickets`. On a confirmed revision, remove previous generated tickets for this discussion only. Identify them by their source metadata resolving to this exact discussion and the existing numbered ticket format inside this task's `tickets/` directory. Remove its obsolete `execution.md` only after successful ticket cleanup and when its source, repository, branch scope, and task identity establish ownership. Before ticket cleanup, mark an owned record `incomplete`; if that fails, stop cleanup and report it as stale. Never delete unrelated files or the directory wholesale. If ownership is unclear or cleanup fails, preserve unresolved artifacts and report alignment as incomplete with exact known partial/stale paths, including the execution record. Return the discussion as the implementation input with a brief boundedness explanation.
3. If decomposition is needed or boundedness is uncertain, explicitly instruct exactly one ticket subagent to apply `to-tickets`. Do not inherit conversation history: use `fork_turns="none"` when available, or an equivalent context-isolated capability. If isolation or delegation is unavailable, use the failure behavior below. An uncertain scope may produce one ticket.
4. Give the child only the exact saved discussion path, the exact local `to-tickets/SKILL.md` path and instructions to read it, and the automatic invocation contract below. Resolve that skill path from this skill's real filesystem location (following installation symlinks) and its sibling `to-tickets` directory; do not rely on implicit invocation. Keep `allow_implicit_invocation: false` in both skills' metadata.
5. Consume the compact child result without repeating repository investigation, reviewing the decomposition a second time, or rereading every ticket. Update the discussion's `Recommended Next Step` to reflect the actual result. Never begin implementation.

### Automatic invocation contract

The child must:

- read the saved confirmed discussion as its complete primary input;
- apply `to-tickets` with automatic generation/alignment authorization from discussion confirmation;
- reuse confirmed repository findings and perform only targeted investigation needed for realistic slices;
- use the existing decomposition logic, decision traceability, self-contained context, and ticket template;
- skip standalone proposal approval and replacement approval, while retaining unresolved material decisions as blockers;
- generate and align tickets plus `execution.md` beside the discussion under the `to-tickets` execution-record contract; prepare/check the complete set before alignment and verify metadata against saved tickets;
- align existing generated artifacts with the current confirmed scope, removing obsolete generated tickets only within this discussion's task directory and source-matched generated set; preserve unrelated artifacts and ambiguously owned execution records;
- distinguish status-only updates from changed definitions using definition hashes; invalidate obsolete progress on revised definitions or explicitly reconcile it with evidence, never by reused ticket numbers alone;
- use no subagents and return no full ticket contents;
- report completion or incomplete ticket/record generation/alignment, the discussion path, every generated ticket path with a short description and blocking dependencies, the exact execution-record path, immediately available tickets, and the recommended starting ticket; include a concise reason for any blocker or failure and exact known partial/stale paths, distinguishing intended paths from saved artifacts.

### Failure behavior

If delegation is unavailable, lacks context isolation, or fails, preserve the confirmed discussion. Do not generate tickets or an execution record in the main discussion agent or launch a replacement child. Clearly report ticket/record generation/alignment as incomplete, including the intended exact execution-record path and any known partial or stale ticket/record paths, and provide the exact recovery command:

`$to-tickets <exact-saved-discussion-path>`

A missing material decision also means the handoff is incomplete: surface the child's specific decision question to the user without silently choosing an answer. A manual retry follows standalone `to-tickets` approval rules. Do not imply that existing tickets or execution progress are fully aligned when the child did not confirm completion.

## Completion response

After the handoff:

- report the exact discussion artifact path;
- for a bounded task, briefly explain suitability for direct implementation and provide `$implement-ticket implement <exact-discussion-path>`;
- for completed decomposition, list every ticket path with a short description and blocking dependencies, report the exact execution-record path, identify immediately available tickets, and recommend the starting ticket;
- for incomplete ticket/record generation or alignment, report the blocker, intended execution-record path, exact known partial/stale paths, and exact manual recovery invocation;
- state that no implementation changes were made;
- stop; implementation requires a separate explicit user request.
