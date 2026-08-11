---
name: implement-ticket
description: Implement one small, bounded production-code change from a direct request, an approved discussion artifact, or one local ticket. Use when the task has one clear behavioral outcome, limited repository scope, and does not need decomposition. Treat a discussion artifact as a complete input for small tasks; treat a ticket as the primary self-contained input for decomposed tasks and consult its parent discussion only selectively when an approved decision or confirmed assumption is genuinely ambiguous. Make the smallest coherent change, preserve unrelated work, create no unit tests unless explicitly requested, and keep repository inspection tightly bounded.
---

# Implement Ticket

Implement one bounded coding task completely, narrowly, and with a context-efficient workflow.

Support both intended workflow shapes:

```text
task-discussion -> implement-ticket
```

for a small bounded task whose confirmed discussion already defines one coherent implementation outcome, and:

```text
task-discussion -> to-tickets -> implement-ticket
```

for a larger task that was decomposed into independently implementable slices.

Do not require ticket creation for a discussion artifact that already passes the scope gate. Do not require loading the complete parent discussion for a ticket that already contains sufficient implementation context.

Do not use subagents. Do not create workflow state machines. Do not commit, push, create a PR, deploy, or modify remote systems unless the user separately authorizes that action.

## Invocation isolation

While this skill is active:

- do not invoke `task-discussion`, `to-tickets`, `code-review`, or another workflow skill;
- do not turn the task into a larger workflow automatically;
- treat a bounded follow-up correction as another direct implementation task;
- if the work is no longer bounded, stop and name the skill the user should invoke explicitly in a separate chat;
- do not invoke the suggested skill yourself;
- do not open or print this `SKILL.md` from disk after invocation because its instructions are already in context.

## Supported input modes

Accept one of these inputs:

1. **Direct task** - the request and current conversation define the change sufficiently.
2. **Discussion artifact** - an approved `.codex-tasks/branches/<branch-key>/<task-id>/discussion.md` defines one bounded implementation outcome.
3. **Ticket** - one `.codex-tasks/branches/<branch-key>/<task-id>/tickets/<NN>-<slug>.md` defines one bounded slice.

Prefer an explicit artifact path when supplied. Otherwise, use the current request directly.

If several plausible artifacts or tickets exist, ask which one to use. Do not choose the newest file automatically.

### Discussion input mode

When the explicit input is an approved discussion artifact:

- treat the discussion as the complete primary task definition;
- read the complete discussion artifact once;
- use its confirmed requirements, decisions, repository findings, constraints, out-of-scope items, and verification expectations directly;
- treat its repository findings as already-established implementation anchors and do not rediscover them without a named reason;
- proceed directly when the discussion passes the scope gate;
- do not invent or require a ticket merely because `to-tickets` exists;
- if the confirmed discussion contains several independent implementation outcomes or otherwise fails the scope gate, stop and recommend `to-tickets` in a separate chat.
- do not search sibling task discussions merely because they exist under the same branch.

A discussion artifact may therefore be the only workflow artifact used for a small task.

### Ticket input mode

When the explicit input is a ticket:

- confirm that its status permits implementation;
- confirm genuine blockers are complete;
- implement only that ticket;
- do not implement dependent tickets;
- treat the ticket as the complete primary implementation input;
- use its `Implementation context`, source metadata, and decision references as navigation and constraints;
- do not load the complete parent `discussion.md` by default.
- do not search sibling task directories under the current branch for additional context;
- never search `.codex-tasks` directories belonging to other branches;
- use only the selected ticket and its explicitly referenced parent source unless the user supplies another artifact.

If the ticket contains `**Source:** ../discussion.md` or another parent source plus `**Decision refs:** ...`, consult the source only when a specific unresolved question requires it.

Allowed reasons for selective parent-source lookup are:

- the ticket is ambiguous about an approved behavioral or architectural constraint;
- a decision rationale is needed to distinguish between an approved choice and a rejected alternative;
- repository evidence appears to contradict a confirmed assumption recorded by the ticket;
- a referenced decision is clearly incomplete or internally inconsistent in the ticket;
- correct implementation would otherwise require guessing about an approved decision.

When consulting the parent source:

- read only the referenced decision, finding, constraint, or surrounding section needed to answer the named question;
- use targeted search or bounded line extraction when possible;
- do not print or load the complete discussion merely for extra confidence;
- do not use the parent discussion to broaden, re-plan, or reinterpret the selected ticket;
- return to the ticket as the implementation scope after resolving the ambiguity.

If the ticket is sufficient, never read the parent discussion merely because it exists.

### Direct task mode

For a direct task, use the current request and conversation as the primary definition. Do not invent a discussion or ticket.

Treat discussion and ticket artifacts as read-only unless the user explicitly asks to update them.

## Scope gate

Before repository exploration, determine whether the task is genuinely bounded.

Proceed when all of these are true:

- there is one primary behavioral outcome;
- acceptance criteria or confirmed requirements are clear enough to implement;
- the change is expected to stay within one coherent area of the codebase;
- no product, architectural, migration, or risk decision is missing;
- the work does not require a ticket breakdown to review safely.

Treat the task as likely unbounded when it contains multiple independent outcomes, crosses several subsystems, combines schema changes with unrelated UI or workflow changes, requires broad refactoring, or is likely to touch more than about five production files for unrelated reasons.

If the task is unbounded:

- stop before broad exploration or editing;
- explain the specific scope issue in one concise paragraph;
- recommend `task-discussion` when decisions or requirements are unclear;
- recommend `to-tickets` when the work is clear but needs decomposition;
- do not invoke either skill yourself.

A larger file count may still be acceptable when all files participate in one atomic mechanical change and the input names the affected areas explicitly.

For discussion input, judge boundedness from the confirmed outcome rather than from the artifact type. A discussion artifact does not need to pass through `to-tickets` when it already describes one coherent bounded change.

## Clarification rule

Resolve repository facts by inspection rather than asking the user.

Ask exactly one question only when a missing product, behavioral, scope, or risk decision prevents correct implementation. Include a recommended answer and wait.

Do not re-plan an approved artifact.

Do not ask the user to repeat information that is already present in the selected discussion or ticket.

If the repository contradicts an approved assumption or makes the requested change unsafe, explain the conflict and ask one focused question.

For ticket input, first use the ticket's implementation context and, when justified, a selective lookup of its referenced parent decision before asking the user.

## Execution budget

Use the following default budget for a bounded task:

- one intake/status call;
- one or two targeted inspection calls;
- one implementation call;
- one combined verification call;
- at most one focused correction and re-verification cycle.

Target roughly 6-10 tool calls and no more than two repository-inspection rounds before the first edit.

A selective parent-discussion lookup in ticket mode should replace unnecessary repository rediscovery, not become an additional broad investigation phase.

Before exceeding 12 tool calls or starting a third inspection round, choose one of these actions:

1. implement from the evidence already gathered;
2. ask the single blocking clarification allowed by this skill;
3. stop because the task is not sufficiently bounded.

Do not exceed the budget merely to gain confidence through repeated reading. An extra call must answer one named unresolved question and must use bounded output.

Do not sacrifice correctness to meet the budget, but prefer a focused stop over open-ended exploration.

## Context-efficient workflow

### 1. Intake once

Start with `git status --short` and preserve unrelated user changes.

Read according to the selected input mode.

For a direct task, read only:

- the current request and relevant current conversation;
- applicable repository instructions such as `AGENTS.md`;
- repository files needed for this implementation.

For a discussion artifact, read only:

- the complete explicit discussion artifact;
- applicable repository instructions such as `AGENTS.md`;
- repository files needed for this implementation.

For a ticket, read only:

- the complete explicit ticket;
- applicable repository instructions such as `AGENTS.md`;
- blocking tickets only when the selected ticket declares blockers;
- a narrowly selected parent-discussion section only when the ticket-mode rules justify it;
- repository files needed for this implementation.

Do not load all `.codex-tasks` artifacts, all tickets, all instructions, or the full repository.

Do not reread unchanged content already present in the conversation or returned by a prior command.

For discussion input, start repository inspection from the `Repository Findings` already recorded by the approved artifact.

For ticket input, start repository inspection from the ticket's `Implementation context` and named domain terms. Do not rediscover a confirmed repository fact unless current code needs to be checked because it may have changed or because the implementation requires details beyond the recorded fact.

### 2. Search narrowly

Begin with files, directories, modules, symbols, responsibilities, and domain terms named by the input.

- use direct path lookup when a useful established path is known;
- prefer symbols or component names when paths may have moved;
- use targeted `rg -l` or exact `rg -n` searches;
- start without context lines;
- restrict searches to the narrowest plausible directory;
- cap matches with `--max-count`, `head`, or a more specific pattern;
- keep ordinary search output below approximately 4 KB;
- do not run recursive tree dumps or broad root searches when the input already names an area;
- do not use `rg -C` until a focused match proves surrounding context is needed.

Search for a symbol before opening a large file.

Treat implementation context as a starting map, not as proof that repository contents are unchanged. Verify only what is needed to edit safely.

### 3. Inspect bounded ranges

After locating a symbol, inspect one range of approximately 40-100 lines with enough surrounding code to understand it.

- expand only when the implementation crosses the current boundary;
- batch closely related ranges into one command when this keeps output bounded;
- do not print a complete file unless it is short and directly relevant;
- inspect adjacent implementations or existing tests only when needed to learn a local convention;
- stop exploring as soon as enough evidence exists to edit safely.

Keep each normal inspection response below approximately 8 KB. If output is truncated or excessive, narrow it; do not repeat the same command.

### 4. Implement coherently

Implement only the requested behavior and acceptance criteria.

- make the smallest coherent change that fully solves the task;
- preserve behavior outside the requested scope;
- follow existing architecture, naming, typing, error handling, and vocabulary;
- preserve confirmed boundaries and invariants from the selected artifact;
- avoid speculative configurability, extension points, compatibility layers, frameworks, and unrelated cleanup;
- allow a small behavior-preserving prefactor only when it directly makes the requested change safer or clearer;
- use comments only for rationale, constraints, or non-obvious tradeoffs;
- remove debug output, dead code, and obsolete comments introduced by the change.

Prefer focused patches over one large multi-file patch. Group tightly coupled edits, but do not combine unrelated files merely to reduce the number of commands.

If a patch fails:

- inspect only the failed location;
- adjust the patch using current file content;
- retry once;
- do not reread every touched file or regenerate a repository-wide patch.

### 5. Verify once, then inspect only concerns

Run compatible final checks together when practical:

- `git status --short`;
- `git diff --stat`;
- `git diff --check`;
- narrowly scoped static checks allowed by this skill.

Inspect the final diff only for files changed by the task.

- inspect each changed area at most once unless a later edit changed it;
- do not print a repository-wide full diff;
- do not print the same multi-file diff twice;
- keep ordinary diff output below approximately 8-12 KB;
- for a large diff, inspect only named hunks or small per-file ranges;
- use `git diff --stat`, `--numstat`, `--name-only`, or targeted `git diff -- <path>` before requesting more content.

When checks identify a concrete problem, inspect and fix only that problem, then re-run only the affected checks plus final repository-state checks.

## Coding defaults

Apply OOP, SOLID, KISS, DRY, YAGNI, and Clean Code pragmatically.

Do not introduce classes, interfaces, abstractions, or indirection without a requirement or an existing architectural seam.

Keep touched code focused, readable, and no less understandable than before.

## Test creation policy

Never create new unit tests unless the user explicitly requests unit tests in the current task.

Do not add test-only wrappers, mocks, fixtures, fake implementations, or harnesses merely to unit-test automation or test-framework code.

Do not interpret `verify the change`, `add coverage`, an acceptance criterion, or a repository convention as permission to create unit tests.

Existing test code may be modified when that test code is itself the requested product. This does not authorize separate tests for the test code.

Do not broaden a coding task into a test-writing task.

## Static verification only

By default, never execute project code. Run only narrowly scoped static checks.

Allowed checks include:

- type checking;
- linting;
- formatting in check-only mode;
- static syntax or configuration validation that does not import or execute project code;
- static schema validation;
- diff and repository-state inspection.

Do not run, start, import, or execute:

- the application or a project entrypoint;
- unit, integration, end-to-end, API, UI, or smoke tests;
- test runners or coverage tools;
- migrations, seeds, generators, or data-processing jobs;
- builds that execute project code, plugins, generators, or lifecycle hooks;
- containers, services, browsers, devices, pipelines, or external-system checks.

Do not treat a ticket, discussion artifact, acceptance criterion, repository convention, or existing command as authorization to execute code.

Only an explicit instruction from the user in the current task may override this policy. Run only the requested command and scope.

Do not ask for runtime authorization by default. Complete useful static verification and report runtime verification as not run.

When a static check fails:

- determine whether the current change caused it;
- fix regressions caused by the task;
- report unrelated pre-existing failures without expanding scope;
- do not suppress or weaken checks to make them pass.

## Follow-up fixes

When practical, keep bounded verification feedback and corrections for the selected ticket in the same implementation conversation. Treat the ticket lifecycle as implementation -> user verification -> bounded correction until the selected behavior is accepted or a new product/architectural decision is required.

Never continue into the next ticket merely because the current implementation is code-complete.

Treat a reported runtime error as a direct follow-up task when its cause and expected behavior are bounded.

Inspect the error and affected code directly. Do not recreate the original exploration phase.

Do not create a new discussion, plan, ticket, result artifact, or confirmation cycle unless the user explicitly invokes the corresponding skill.

If the error reveals a missing product or architectural decision, apply the clarification rule.

## Completion review

Before declaring completion, confirm:

- the requested behavior and acceptance criteria are satisfied;
- confirmed decisions and boundaries from the selected input were preserved;
- only intended files and areas changed;
- unrelated user changes remain preserved;
- static-check results are reported accurately;
- runtime checks are reported as not run unless explicitly authorized;
- no secrets, generated junk, debug output, or unrelated cleanup were added;
- the design remains proportional to the task.

Do not perform extra cleanup after the requested change is complete.

## Artifact policy

Do not create an implementation-result artifact by default.

Do not create or update files under `.codex-tasks` merely to record completion.

Treat repository code and the Git diff as the source of truth.

Create a persistent handoff artifact only when the user explicitly asks for one. Keep it concise and include only:

- what changed;
- static checks and results;
- runtime checks not run;
- blockers or remaining work.

Do not include full diffs, long logs, or a work transcript.

## Final response

Report concisely:

- what was implemented;
- files or areas changed;
- static checks performed and their results;
- runtime checks not run by policy;
- blockers or remaining work;
- recommended git commit message.

Do not include a full diff, long implementation narrative, command transcript, or repeated restatement of the task unless requested.
