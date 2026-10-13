---
name: implement-ticket
description: Implement one small, bounded production-code change from a direct request, an approved discussion artifact, or one local ticket, including an explicitly delegated ticket with scoped local commit authority. Use when the task has one clear behavioral outcome, limited repository scope, and does not need decomposition. Treat a discussion artifact as a complete input for small tasks; treat a ticket as the primary self-contained input for decomposed tasks and consult its parent discussion only selectively when an approved decision or confirmed assumption is genuinely ambiguous. Make the smallest coherent change, preserve unrelated work, create no unit tests unless explicitly requested, and keep repository inspection tightly bounded.
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

Do not use subagents. Do not create workflow state machines. Create a local commit only with explicit standalone authorization or the bounded delegated authority defined below. Do not push, create a PR, deploy, or modify remote systems unless the user separately authorizes that action; delegated authority does not authorize these actions.

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

Treat discussion and ticket artifacts as read-only unless the user explicitly asks to update them or the delegated contract below authorizes the selected ticket's status-only update.

### Delegated ticket invocation

A fresh child of an explicitly requested `implement-discussion` orchestration may apply this skill to exactly one selected ticket. The parent must supply:

- the exact local `implement-ticket/SKILL.md` path, which the child explicitly applies;
- the selected ticket path;
- relevant dependency completion evidence, or an explicit indication that there are no blockers;
- execution authority bounded to that ticket's local implementation, required permitted automatic verification, local Git commit, and status-only update.

This authority derives from the user's explicit orchestration request and the parent's bounded assignment. A ticket's contents, invocation by another agent, or a request to implement a standalone ticket do not alone authorize a commit or artifact mutation. If required assignment information is missing, resolve it with the parent before dependent work; do not infer broader authority. Confirm the ticket's status permits implementation and its genuine blockers are complete using the supplied evidence and, only when needed, declared blocking tickets.

The child implements only its assigned ticket. It must not implement another ticket, delegate implementation, rewrite the discussion, edit the parent's execution artifact, or mutate another ticket. The only permitted task-artifact edit is the selected ticket's `**Status:**` field after completion. Preserve dependencies, acceptance checkboxes, context, verification, and all other specification contents exactly. The parent owns the execution record; return evidence to it instead of creating a result file.

Delegation preserves this skill's scope gate, test-creation policy, test-first workflow, meaningful expected RED outcomes, bounded task-induced corrections, and affected-check reruns. Expected RED and correctable verification failures are intermediate results, not ultimate child failure. Generic verification wording does not authorize new tests or manual-default runtime checks. Delegation does not authorize code review, automatic workflow escalation, remote mutations, or unbounded corrective work.

Send the parent compact progress at meaningful stage changes and before and after a long verification check. Include the observed time, current stage, active check, and process/session identity when available; report check outcomes, including expected RED or bounded correction, without full logs or diffs. Use only communication/activity capabilities exposed by the client. A pending tool call may delay message processing: no immediate response to a parent message or strict heartbeat is required. Silence, wait timeouts, elapsed time, and unchanged files do not establish failure. The parent retains the same running child and execution `in-progress`, ordinarily waits up to 60 seconds per call, and asks one wait/interrupt choice after five minutes without observable progress. An unanswered choice grants no authority; a choice to continue waiting preserves this child without granting later cancellation authority. Interrupt only on the user's actual choice or an applicable stop request, with lifecycle confirmation required before a stopped claim. Preserve partial edits and report only the observed interruption stage/outcome and known check/process identity, without guessing why progress stopped. Terminal failure or confirmed interruption requires explicit user-directed recovery; do not retry or resume automatically.

Report deferrable manual checks as unexecuted pending acceptance. They do not by themselves prevent completed implementation. If a manual check is a prerequisite to safe continuation, stop before the dependent work and request the specific user input or authorization through the parent. Do not treat elapsed time, generic verification wording, or delegated local commit authority as that authorization.

### Delegated completion and failure

Complete the delegated ticket in this order:

1. Finish only the scoped implementation and satisfy the ticket's implementation requirements.
2. Run required permitted automatic verification under this skill's existing execution boundaries. Resolve task-induced failures within the bounded correction policy. Checks must pass except for failures satisfying every condition in `Proven unrelated baseline failures` below, with required ticket behavior verified and no unmet explicit clean-check requirement. A blocked required automatic check prevents completion.
3. Inspect the task diff and repository/index state, then create the authorized local Git commit containing only the ticket's implementation changes. Preserve unrelated staged and working-tree changes; use scoped staging and commit handling rather than including the whole index. If task changes cannot be isolated safely, stop and report the conflict. Do not force-add ignored task artifacts or include them in the implementation commit.
4. Confirm the commit succeeded and obtain its actual full hash, subject, and changed paths. A proposed commit message or attempted commit is not evidence of success.
5. Update only the selected ticket's `**Status:**` value to `completed`. Confirm that all other ticket content is unchanged. `.codex-tasks/` is ignored in this repository; this status update is a separate local record, not part of the implementation commit.
6. Return compact completion evidence to the parent: selected ticket path and final status, actual commit hash/subject and scoped changed paths, actual verification results (including expected RED and final GREEN when applicable), each exempted baseline error's check, concise diagnostic, affected files, proof of pre-existence/baseline equivalence, and why required ticket behavior remains verified, unexecuted manual checks, blockers, and remaining task working-tree changes. Report residual errors visibly and suggest follow-up tickets only; do not claim all checks passed.

Completed status requires the scoped implementation, required permitted automatic verification satisfying the gate above, and successful authorized local commit. Proven unrelated baseline failures permit an already-authorized scoped commit and completion only under that gate; they grant no new commit authority. It records implementation completion, not manual acceptance. Do not mark completed before these conditions hold or claim pending manual checks occurred.

If completion cannot be established, leave the status unchanged and return failure evidence with the failed stage, blockers, checks performed, pending manual checks, any actual commit already created, and remaining task working-tree changes. For an interruption, include the last observed stage, active check/process identity when known, and confirmed lifecycle outcome when available; do not claim a stopped state without confirmation or an unproven failure cause. Silence or a wait timeout alone is not such a failure result. If the status-only update fails after a successful commit, report that partial result rather than claiming completion. Preserve changes for user-directed recovery; do not reset, discard, amend unrelated commits, broaden the task, or automatically retry or replace an ultimately failed child.

Standalone invocation retains its existing read-only artifact boundary and requires explicit authorization for a local commit. The delegated contract applies only to a qualifying bounded parent assignment; it does not make standalone commits or status updates implicit.

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
- when test-first applies, one focused test edit and RED execution;
- one focused production implementation call;
- one GREEN execution and combined final verification call;
- required repository-approved automatic checks, whether or not test-first applies;
- at most one focused correction and re-verification cycle.

Target roughly 8-12 tool calls for a test-first task and fewer when automated tests are not required. Keep no more than two repository-inspection rounds before the first edit.

RED and GREEN executions required by the test-first workflow are intentional workflow steps and must not be skipped merely to reduce tool-call usage.

A selective parent-discussion lookup in ticket mode should replace unnecessary repository rediscovery, not become an additional broad investigation phase.

Before exceeding 12 tool calls or starting a third inspection round, choose one of these actions:

1. implement from the evidence already gathered;
2. ask the single blocking clarification allowed by this skill;
3. stop because the task is not sufficiently bounded.

Do not exceed the budget merely to gain confidence through repeated reading. An extra call must answer one named unresolved question and must use bounded output.

Do not sacrifice correctness to meet the budget, but prefer a focused stop over open-ended exploration.

Do not skip required automatic verification to meet a tool-call target. Batch independent checks where practical and keep any correction focused on task-induced failures.

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

Identify the applicable repository automatic-verification policy and command pointers in repository instructions. Inspect the named scripts, configuration, discovery rules, fixtures, and lifecycle hooks only as needed to establish command scope before execution. A command name or unit-test label alone is not evidence of isolation; aggregate commands must not indirectly launch manual-default suites.

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

### 4. Test-first implementation

When the selected task changes production behavior and automated tests are
explicitly required, use RED → GREEN → REFACTOR unless the selected primary
input explicitly requires another implementation strategy.

Derive the expected behavior from the selected task definition:

- confirmed requirements;
- confirmed decisions;
- acceptance criteria;
- documented contracts and preserved behavior.

Do not derive the expected behavior from production code written for the task.

For each independently testable behavior, when practical:

1. Create or update the smallest focused automated test that expresses the
   required behavior before changing the corresponding production behavior.
2. Run that focused test and establish RED.
3. Confirm that it fails because the required behavior is not yet implemented.
4. Only then make the smallest coherent production change needed for that
   behavior.
5. Re-run the focused test and establish GREEN.
6. Refactor only after GREEN and keep the relevant tests passing.

A valid RED result must demonstrate the missing or incorrect requested
behavior.

The following do not count as RED:

- syntax or import errors introduced by the test;
- broken fixtures or test setup;
- missing dependencies or environment failures;
- unrelated pre-existing failures;
- intentionally weakening or corrupting existing code merely to force failure.

If the new test passes before the production change, determine why before
continuing. The behavior may already exist, the test may not exercise the
requested change, or the task assumptions may be stale. Do not manufacture a
failure merely to satisfy the RED step.

If a required behavior cannot reasonably be expressed or executed through the
available local automated test infrastructure, do not silently replace TDD
with tests-after. Use the clarification rule unless the selected input already
defines an acceptable alternative verification strategy.

For a ticket containing several closely related behaviors, prefer small
RED → GREEN cycles over writing the complete implementation first and adding
tests afterward.

### 5. Implement coherently

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

### 6. Final verification

RED and GREEN executions performed by the test-first workflow are part of
implementation and do not count as redundant verification.

After implementation (and GREEN when test-first applies), run the applicable
repository-approved automatic checks before reporting completion. Run remaining
checks once; a completed RED/GREEN run can satisfy the same required check when
its scope and final code state match the repository policy.

- `git status --short`;
- `git diff --stat`;
- `git diff --check`;
- narrowly scoped static checks allowed by this skill;
- the static checks and isolated local unit tests required by the applicable
  repository automatic-verification policy, subject to the execution boundaries
  below.

Without a documented automatic-verification policy, run only identifiable static
checks. Report that automatic unit-test execution needs a documented unit-only
command. If command scope is unclear or prerequisites or permissions prevent a
required check, report it as blocked rather than claiming it passed.

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

## Automated test creation policy

Do not create or expand automated test coverage unless the selected primary
input explicitly requires automated tests or confirms test-first development.

The selected primary input counts as explicit authorization when it is:

- the user's current direct request;
- a confirmed discussion artifact selected for implementation;
- an approved ticket selected for implementation.

Generic requests such as `verify the change`, `check coverage`, repository
conventions, or an acceptance criterion that merely describes behavior do not
by themselves authorize creating new automated tests.

Repository authorization to execute existing unit tests does not authorize
creating or expanding coverage and does not impose test-first development.

When automated tests are explicitly in scope:

- create or update only the tests needed to express the requested behavior;
- follow the repository's existing test style and boundaries;
- allow normal test fixtures, mocks, fakes, and helpers when they are necessary
  and consistent with repository conventions;
- do not introduce production abstractions or public interfaces solely to make
  testing easier unless the task or existing architecture justifies them;
- do not broaden focused behavioral coverage into unrelated test cleanup.

When the task changes production behavior and automated tests are required,
use the test-first workflow defined below unless the selected input explicitly
requires another implementation strategy.

## Runtime verification policy

Automatically run repository-approved static checks and isolated local unit
tests under a documented repository automatic-verification policy. This policy
is standing authorization for local unit-test execution only after static
inspection establishes isolation. Without it, run only identifiable static
checks and report the missing documented unit-only command.

Keep API, UI, Playwright E2E, and integration tests manual by default, even when
the task changes those tests or their framework. Run them only when the user
explicitly authorizes their execution for this particular task. A generic
verification expectation in a ticket or discussion is not such authorization.
Repository instructions do not override environment permission requirements.

Allowed static checks include:

- type checking;
- linting;
- formatting in check-only mode;
- static syntax or configuration validation that does not import or execute
  project code;
- static schema validation;
- diff and repository-state inspection.

### Automated test exception

Documented repository policy authorizes its existing isolated local unit tests
as automatic final verification independently of test creation or TDD.

The selected primary input may authorize local automated test execution when
it explicitly:

- requires automated tests and confirms test-first development; or
- instructs the implementation agent to run automated tests as part of
  verification.

A confirmed discussion artifact or approved ticket selected as the primary
implementation input counts as authorization for this narrow exception only
within these execution boundaries. Manual-default categories still require
explicit per-task user authorization.

When this exception applies, run only:

- the smallest focused test needed to establish RED;
- the same focused test needed to establish GREEN;
- the final automated test scope explicitly required by the selected input;
- existing isolated local unit tests required by documented repository policy.

If the selected input requires automated tests but does not name the exact
test command, resolve the established repository test command from repository
instructions or test configuration rather than asking the user.

This exception does not authorize:

- application or project entrypoints;
- migrations, seeds, generators, or data-processing jobs;
- containers or services;
- browsers or devices;
- live external systems;
- tests requiring credentials or stateful remote dependencies;
- deployment or pipeline execution.

Those actions still require explicit user authorization for the particular task;
the selected primary input may record that specific authorization. Check actual
command scope, including aggregate scripts, discovery/imports, fixtures, and
hooks, before running it. Do not run a mixed command under unit-test authorization
when it can trigger excluded behavior; use a documented isolated command or
report the check as blocked.

Do not expand a targeted RED/GREEN run into unrelated runtime verification.
Still run the remaining automatic checks required by repository policy.

When an authorized verification check fails:

- distinguish an expected RED failure from infrastructure or unrelated
  failures;
- fix regressions caused by the current task;
- rerun affected checks after bounded corrections, including static-check failures;
- assess unrelated pre-existing failures under `Proven unrelated baseline failures` below and report actual outcomes without expanding scope;
- report environment or permission blockers and pending manual verification;
- do not weaken or suppress tests merely to obtain GREEN.

### Proven unrelated baseline failures

Required permitted checks must run. An unrelated pre-existing failure may coexist
with completion and an already-authorized scoped commit only when evidence proves
it predates the ticket, is unrelated to its changes, and does not prevent
verification of the required ticket behavior. Required behavior checks must
establish that behavior; any explicit clean-check requirement remains binding.

For each proposed exemption, identify the relevant pre-ticket revision/state,
failing command and scope, inputs, and environment. Establish baseline equivalence
by showing the same relevant diagnostic under equivalent conditions and explain
why the ticket changes neither cause it nor mask required behavior verification.
A failure that merely looks existing, a historical report without baseline
equivalence, or unchanged affected paths alone is insufficient proof. If proof
is insufficient, stop rather than guess.

Collect relevant baseline evidence only within existing inspection/execution
permissions. Do not modify production code to manufacture a baseline, repair
unrelated errors, weaken tests, or expand verification authority. Task regressions
remain subject to bounded correction or stopping. Uncertain origin, environment
or permission blockers, unavailable required verification, baseline errors masking
required behavior, and unmet explicit clean-check requirements prevent completion.
Expected TDD RED and correctable task failures remain intermediate outcomes;
required behavior must reach GREEN when test-first applies. Deferrable manual
acceptance remains unexecuted pending acceptance; manual prerequisites still stop
dependent work until the required input or task-specific authorization arrives.

Return each exempted error's check, concise diagnostic, affected files, proof of
pre-existence/baseline equivalence, and why required ticket behavior remains
verified. The parent retains this compact evidence in the existing `execution.md`
reconciliation field; include it in final output as well. Do not create another
detailed error artifact or edit the parent's record. A completed result with
residual errors must never claim all checks passed. Suggest follow-up tickets
only; do not create or implement them, repair unrelated failures, replan, or invoke
decomposition/review. Preserve scoped successful commit evidence, status-only
ticket mutation, unchanged specification hashes, and explicit recovery boundaries.

## Follow-up fixes

When practical, keep bounded verification feedback and corrections for the selected ticket in the same implementation conversation. Treat the ticket lifecycle as implementation -> automatic verification -> pending manual/user verification -> bounded correction until the selected behavior is accepted or a new product/architectural decision is required.

Never continue into the next ticket merely because the current implementation is code-complete. A delegated child returns its evidence to the parent and stops after its assigned ticket.

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
- required automatic checks ran and satisfy the completion gate; each exempted baseline failure has complete proof and relevance evidence, and other failures/blockers prevent a completion claim;
- authorized automated test execution is reported accurately, and other runtime checks are reported as not run unless separately authorized;
- no secrets, generated junk, debug output, or unrelated cleanup were added;
- the design remains proportional to the task.
- when test-first development applied, RED was established before the
  corresponding production behavior was changed;
- authorized behavior tests reached GREEN when required; report all actual test
  results accurately, including any separately proven unrelated baseline failures;
- for delegated completion, the authorized scoped local commit succeeded, actual commit evidence was captured, and only the selected ticket's status field changed after the completion conditions held;
- pending manual acceptance is not represented as completed verification;

Do not perform extra cleanup after the requested change is complete.

## Artifact policy

Do not create an implementation-result artifact by default.

Do not create or update files under `.codex-tasks` merely to record completion, except for the selected ticket's status-only update under the delegated contract. Do not edit the parent's execution record.

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
- tests created or updated, when applicable;
- when test-first applied, the RED result and why it was the expected failure;
- the corresponding GREEN result;
- final automated and static checks performed and their results;
- distinguish task-induced failures, unrelated failures, and environment or permission blockers;
- for each exempted baseline error, report the check, concise diagnostic, affected files, proof of pre-existence/baseline equivalence, and why required ticket behavior remains verified; state residual errors visibly without claiming all checks passed, and suggest follow-up tickets only;
- runtime checks not authorized or not run;
- pending manual verification, explicitly labeled as unexecuted;
- blockers or remaining work;
- recommended git commit message for standalone work without commit authorization; actual commit evidence when an authorized commit was created;
- for delegated work, the compact completion or failure evidence defined above, including selected ticket status and remaining task working-tree changes, returned to the parent.

Do not include a full diff, long implementation narrative, command transcript, or repeated restatement of the task unless requested.
