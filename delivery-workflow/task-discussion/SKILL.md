---
name: task-discussion
description: Interview the user interactively to reach a shared understanding of a coding or repository task before planning or implementation. Use when requirements are incomplete, ambiguous, risky, or contain meaningful implementation choices. Explore the repository to resolve facts, ask one implementation-relevant decision at a time with a recommended answer, and after explicit user confirmation write a structured discussion artifact under the current branch at .codex-tasks/branches/{branch-key}/{task-id}/discussion.md. Do not modify product code or begin implementation.
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
11. Only after explicit confirmation, create the discussion artifact.

If new repository evidence invalidates an earlier assumption or decision context, explain the conflict and ask the user to revisit only the affected decision.

## Confirmation boundary

Do not modify product code, configuration, tests, pipelines, or external systems during this skill.

Do not begin implementation planning or implementation.

Do not create the final artifact until the user explicitly confirms that shared understanding has been reached.

Creating the confirmed discussion artifact is the only allowed write operation, apart from creating its parent directory.

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

If this confirmed task is one bounded implementation outcome, implement it directly from this discussion artifact with `implement-ticket`.

If the task contains multiple independently implementable outcomes or needs dependency-aware decomposition, create tickets from this discussion artifact with `to-tickets`.

Do not reinterpret confirmed decisions without returning to the user.
```

Use `None` explicitly for empty sections. Do not omit sections silently.

## Completion response

After writing the artifact:

- report the exact artifact path;
- state that no implementation changes were made;
- stop unless the user explicitly asks for the next step.
