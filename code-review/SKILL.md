---
name: code-review
description: Review local changes, branch diffs, or pull requests independently by inspecting the actual diff and surrounding code for correctness, regressions, requirement gaps, security risks, and maintainability problems. Perform the initial review without task-planning artifacts. After forming provisional findings, selectively consult matching task-discussion and to-tickets artifacts from the reviewed branch only when intent, scope, or an approved decision could change whether a candidate finding is actionable. Ask the user only for unresolved product or scope decisions that repository evidence and branch-scoped artifacts cannot answer.
---

# Code Review

Review the implementation independently. Treat the changed code and repository state as the source of truth.

Do not modify code, create fixes, create tests, update task artifacts, commit, push, or publish review comments unless the user explicitly requests a separate action.

## Supported inputs

Review any one of these:

- uncommitted or staged changes in the current working tree;
- a branch compared with a specified base branch;
- a checked-out pull request;
- a diff, patch, commit range, or file set explicitly supplied by the user.

The skill must work without `.codex-tasks` artifacts. This is the normal case for reviewing another contributor's pull request.

## Review independence and requirement context

Preserve independence between implementation planning and initial review.

### Phase 1 - blind code review

Before forming provisional findings, do not read:

- task-discussion artifacts;
- to-tickets artifacts;
- implementation summaries;
- previous code-review artifacts.

Inspect only:

- the requested diff or branch changes;
- surrounding repository code;
- applicable repository instructions;
- interfaces, callers, tests, configuration, and architecture directly needed to understand the changed code.

The purpose of this phase is to discover candidate problems without being biased by implementation rationale or approved planning decisions.

### Phase 2 - finding adjudication

After provisional findings exist, determine for each candidate whether its validity depends on intent, scope, requirements, or an approved trade-off.

Do not consult task artifacts for a finding that can be proven or disproven from code and repository contracts alone.

For intent-dependent candidates, selectively consult matching task artifacts from the reviewed branch.

For a checked-out current branch, derive `<branch-key>` using the same normalization rules as `task-discussion` and search only under:

`.codex-tasks/branches/<branch-key>/`

Requirement context may come from:

- `<task-id>/discussion.md`
- `<task-id>/tickets/*.md`

Do not use:

- artifacts belonging to another branch;
- `reviews/` artifacts as requirement context;
- implementation chat summaries;
- checked acceptance boxes as proof of correctness.

Search narrowly using changed symbols, domain terms, affected components, requirement vocabulary, or concepts from the candidate finding.

Prefer targeted text search across branch task artifacts before opening any artifact.

Open only the matching artifact sections needed to adjudicate the candidate.

Do not enumerate or read every task artifact merely because it belongs to the current branch.

Artifacts may:

- confirm that a candidate is a real requirement violation;
- show that apparently unusual behavior is an explicitly approved decision;
- establish an intentional scope boundary;
- clarify an acceptance criterion;
- strengthen or dismiss an intent-dependent candidate.

Artifacts provide intent. Code remains the source of truth for whether that intent was implemented correctly.

## Review process

### 1. Establish the review scope

Determine exactly what is being reviewed and what baseline it should be compared against.

Prefer an explicitly supplied base branch, commit range, diff, or file set. Otherwise:

- for working-tree review, inspect staged, unstaged, and relevant untracked changes;
- for branch review, compare against the merge base with the likely target branch;
- for a checked-out pull request, use its target branch when available.

Do not broaden the review to unrelated pre-existing code.

### 2. Read repository guidance

Read applicable `AGENTS.md`, contribution instructions, nearby architecture documentation, and local conventions for the changed area.

Do not load broad documentation that is unrelated to the diff.

### 3. Inspect the actual change

Inspect:

- the complete diff;
- the full changed files, not only isolated diff hunks;
- callers, consumers, interfaces, schemas, and configuration directly affected by the change;
- existing tests only as evidence of expected behaviour and coverage, not as proof of correctness;
- relevant error handling, cleanup, concurrency, data flow, and boundary conditions.

Follow important symbols far enough to understand behavioural impact. Avoid repository-wide exploration when a narrower inspection is sufficient.

### 4. Check requirement alignment

When requirements are available, map the implementation to each material requirement or acceptance criterion.

Look for:

- missing behaviour;
- behaviour that contradicts a confirmed decision;
- accidental scope expansion;
- incomplete vertical slices;
- ticket work implemented before a genuine blocker;
- functionality that exists only partially across affected layers.

Artifacts provide intent. The code determines whether that intent was implemented.

### 5. Look for actionable defects

Prioritize findings in this order:

1. incorrect behaviour and regressions;
2. data loss, security, permissions, secrets, and unsafe side effects;
3. broken error handling, resource cleanup, retries, timeouts, concurrency, or state transitions;
4. API, schema, compatibility, configuration, and integration contract violations;
5. missing handling for realistic boundary conditions;
6. maintainability problems likely to cause defects.

Evaluate OOP, SOLID, KISS, DRY, YAGNI, and Clean Code pragmatically. Report a design issue only when it creates a concrete correctness, changeability, duplication, coupling, or readability risk. Do not demand patterns, abstractions, or refactors merely for stylistic purity.

Do not report:

- subjective style preferences already handled by formatters;
- speculative problems without a plausible failure scenario;
- unrelated pre-existing issues;
- requests for unit tests merely because a change lacks unit tests;
- broad refactoring suggestions outside the reviewed scope;
- praise or a summary disguised as a finding.

### 6. Verification policy

Do not run application code or any runtime verification unless the user explicitly authorizes it in the current request.

Without explicit authorization, do not run:

- unit, integration, end-to-end, API, or UI tests;
- application or service entry points;
- scripts that execute project behaviour;
- builds, containers, migrations, pipelines, or external systems.

Static inspection is always allowed. Run static commands only when they are relevant, safe, and read-only or check-only, such as:

- `git diff`, `git status`, and history inspection;
- type checking;
- lint in check-only mode;
- formatting checks that do not rewrite files;
- static syntax, configuration, or schema validation.

Never create unit tests or any other tests during review. A review reports findings; it does not implement fixes or test coverage.

### 7. Validate each proposed finding

Before reporting a finding:

1. identify the exact changed code that introduced or exposed it;
2. trace the relevant execution or data path;
3. verify that the repository does not already handle the case elsewhere;
4. describe a concrete failure scenario;
5. confirm that the issue is within the review scope and actionable by the author.

Omit findings that cannot pass this validation.

### 8. Classify provisional findings

Before reporting a candidate, classify it as one of:

#### Intrinsic technical finding

Its validity can be established from code, repository contracts, execution/data flow, or concrete engineering constraints without knowing product intent.

Examples include:

- a reachable null dereference;
- broken cleanup or error handling;
- incompatible API/schema usage;
- incorrect data flow;
- a security exposure;
- a demonstrated regression against an existing repository contract.

Validate these from repository evidence. Do not ask the user whether they are technically valid.

#### Intent-dependent candidate

Its validity depends on intended behavior, task scope, compatibility policy, an approved trade-off, or another product decision.

Examples include:

- whether historical data should be migrated;
- whether an existing output contract should change;
- whether a deliberately narrow implementation should have been generalized;
- whether a special input state is intentionally excluded.

Adjudicate these against current-branch task artifacts before asking the user.

## Severity levels

Use these levels:

- **P0 — Critical:** causes catastrophic data loss, severe security exposure, or widespread system failure and must block merge.
- **P1 — High:** causes incorrect behaviour or a serious regression in a realistic common path and should block merge.
- **P2 — Medium:** causes a real but narrower defect, reliability problem, or material maintainability risk that should normally be fixed.
- **P3 — Low:** causes a minor concrete problem worth addressing but does not normally block merge.

Do not inflate severity. Most valid findings should be P1 or P2 only when the demonstrated impact justifies it.

## Final finding gate

Do not report provisional findings.

A candidate may appear in the final review only after:

1. its technical basis has been validated;
2. relevant repository handling has been checked;
3. requirement-dependent ambiguity has been adjudicated against matching branch task artifacts when applicable;
4. any remaining user-owned decision has been resolved interactively.

Discard candidates that are explicitly allowed by confirmed requirements or scope.

Do not include dismissed candidates merely for transparency unless the user asks for the review reasoning.

## Output format

Lead with findings, ordered by severity and then by confidence. 

For each finding, use:

```markdown
### [P1] Short actionable title

**Location:** `path/to/file.ext:line`

Explain the concrete problem, the conditions that trigger it, and the resulting impact. Keep the explanation focused on why the changed code is wrong or risky.

**Recommended direction:** Describe the smallest reasonable correction without implementing it.
```

Keep location ranges as narrow as possible and point to changed lines whenever feasible.

After findings, include:

```markdown
## Review summary

- Scope reviewed: ...
- Initial review context: code/repository only
- Requirement adjudication: none / current-branch task artifacts consulted
- User clarifications: none / <count>
- Static checks: ...
- Runtime verification: Not run by policy
- Result: blocking findings / non-blocking findings / no findings
```

If no valid findings exist, say:

```markdown
No actionable findings found.
```

Then provide the review summary and any material limitations. Do not invent findings to make the review appear useful.

## Review artifact policy

Do not create a persistent review artifact until all provisional findings have been adjudicated.

When the user explicitly requests a persistent review report, write it under:

`.codex-tasks/branches/<branch-key>/reviews/<YYYYMMDD-HHMM>-code-review.md`

Include only final validated findings.

Do not persist:

- provisional findings;
- candidates dismissed by repository evidence;
- candidates resolved by confirmed task decisions;
- the interactive question-and-answer transcript;
- implementation-planning rationale unrelated to a final finding.

Review artifacts are outputs of review and must never be used as requirement context by future code-review runs.

## Interaction rules

Ask the user only when:

- the review target or comparison base cannot be determined safely; or
- an intent-dependent provisional finding cannot be resolved from repository evidence or matching branch-scoped task artifacts.

For unresolved review decisions:

- ask exactly one question at a time;
- explain why the decision changes whether the candidate is actionable;
- provide a recommended answer and short rationale;
- ask about product behavior, scope, compatibility, risk acceptance, or another user-owned decision.

Do not ask the user to explain technical implementation rationale that can be determined from the repository.

The user is not expected to know why generated code chose a specific function, abstraction, call order, or technical mechanism.

Do not ask:

"Is this a problem?"

Instead ask the unresolved decision itself, for example:

"Should existing worksheets intentionally remain unchanged, or should this change migrate them too?"

After the user answers, adjudicate the candidate yourself.

A user may choose to accept or defer a confirmed technical risk, but that does not make a technically validated finding invalid.
