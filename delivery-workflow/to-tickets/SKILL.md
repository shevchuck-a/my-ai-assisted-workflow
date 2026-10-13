---
name: to-tickets
description: Break an approved task discussion, specification, plan, or current coding-task conversation into small tracer-bullet implementation tickets with explicit blocking dependencies, acceptance criteria, decision traceability, and the minimum confirmed repository context needed for a fresh implementation agent, plus a compact source-linked execution record. Use when the user wants an implementation-ready ticket breakdown saved under the same branch-scoped .codex-tasks task directory as its source discussion. Also support an explicit context-isolated task-discussion handoff after confirmation, without separate breakdown approval. Do not implement the tickets or modify product code.
---

# To Tickets

Turn an agreed task definition into a small set of implementation-ready tickets. Prefer vertical slices that deliver independently verifiable behavior and fit into one fresh Codex context.

A ticket must normally be sufficient for `implement-ticket` to start without loading the complete parent discussion. Preserve the confirmed decisions and repository anchors that materially constrain or accelerate implementation, while avoiding a file-by-file implementation recipe.

Do not implement code. Do not start a ticket. Do not publish to a remote issue tracker.

## Inputs

Use the first available source in this order:

1. A path explicitly provided by the user.
2. `<repository-root>/.codex-tasks/branches/<branch-key>/<task-id>/discussion.md` from the current task.
3. An approved specification or plan already present in the conversation.
4. The current conversation, but only when the user confirms it contains the agreed task definition.

When a source path contains:

`.codex-tasks/branches/<branch-key>/<task-id>/`

reuse both `<branch-key>` and `<task-id>`.

When no branch scope is encoded in the source, resolve the current Git branch using the same branch-key normalization rules as `task-discussion`.

When no task ID exists, create one in this format:

`YYYYMMDD-HHMM-short-task-slug`

Use the current repository root and current branch directory as the base location.

If multiple plausible task directories exist inside the current branch and the correct task cannot be determined safely, ask the user which task ID to use.

Do not search other branch directories and do not choose the newest task automatically.

## Invocation modes

Standalone invocation retains proposal approval and approval before replacing existing generated tickets or their execution record. Include the execution record in the proposed output and replacement scope.

Automatic invocation applies only when `task-discussion` explicitly delegates this skill with the exact saved confirmed discussion path and authorization to generate or align its tickets. Discussion confirmation authorizes that breakdown and synchronization without another proposal or replacement approval. This exception does not apply merely because the source status is `confirmed`, or because a standalone invocation supplies a discussion path.

In automatic mode, use only the saved discussion as task context, do not inherit the interview conversation, and do not delegate further. Preserve all decomposition, traceability, context, and template rules below. If a material decision is missing, return an incomplete handoff with the specific decision question for the parent to ask; do not invent an answer or claim completion.

## Process

### 1. Gather the agreed context

Read the complete primary source artifact.

Extract:

- task goal;
- confirmed requirements and decisions;
- decision IDs or other stable decision references, when present;
- accepted assumptions;
- constraints and non-goals;
- relevant repository findings and implementation anchors;
- relevant verification expectations;
- unresolved blockers.

Do not silently resolve a product decision that the source leaves open. If an unresolved decision materially changes the ticket breakdown, ask the user to resolve it before drafting tickets in standalone mode; in automatic mode, return the blocker and decision question to the parent.

Treat confirmed repository findings as already-paid investigation. Preserve the subset that a fresh implementation agent would otherwise need to rediscover in order to locate the change, respect an approved boundary, or avoid a known-wrong implementation direction.

### 2. Explore the repository only as needed

Inspect the repository when codebase facts are required to produce realistic slices, dependencies, or implementation context.

Look up facts rather than asking the user, including:

- existing architecture and domain vocabulary;
- established service, API, UI, test, and configuration patterns;
- relevant ADRs or repository instructions;
- whether a proposed slice can land and verify independently;
- opportunities for a small prefactor that makes later work safer;
- stable symbols, components, or paths that materially reduce rediscovery for the implementation agent.

Keep exploration targeted:

- start with repository instructions and files named by the source artifact;
- search for relevant symbols before opening files;
- avoid broad repository scans;
- stop once enough evidence exists to produce the breakdown;
- do not use subagents.

Do not repeat repository investigation merely to restate facts already established by an approved discussion unless current repository evidence contradicts them or the facts are insufficient to split the work safely.

### 3. Draft tracer-bullet tickets

Break the work into narrow but complete vertical slices.

Each ticket must:

- deliver behavior that is independently demoable or verifiable;
- include every layer needed for that behavior, when applicable;
- fit into one fresh Codex context window;
- have clear acceptance criteria;
- declare only genuine blocking dependencies;
- avoid depending on later tickets;
- use project vocabulary rather than generic terms;
- preserve every confirmed decision that applies to that slice;
- carry enough confirmed implementation context that `implement-ticket` normally does not need the complete parent discussion.

Prefer fewer meaningful tickets over many tiny mechanical tickets.

Do not create separate horizontal tickets such as "add models", "add service", "add tests", and "update pipeline" when those pieces are required for one behavior. Keep them together as one vertical slice.

A ticket with no blockers can start immediately.

### 4. Preserve decision traceability

When the source artifact contains explicit decision IDs such as `D1`, `D2`, and `D3`, map every applicable decision to one or more tickets.

Before presenting the breakdown, verify internally that:

- every confirmed decision that requires implementation is represented by at least one ticket;
- every ticket contains the decisions needed to implement that slice correctly;
- no decision is copied into an unrelated ticket merely for completeness;
- no ticket weakens, reinterprets, or silently broadens a confirmed decision.

Record applicable decision IDs in the ticket as `**Decision refs:** ...`.

Use `None` when the source has no explicit decision IDs or no decision reference applies.

Decision references are traceability aids, not permission for `implement-ticket` to load the entire parent discussion by default.

### 5. Preserve implementation context without prescribing implementation

For each ticket, include a compact `Implementation context` section containing only confirmed repository facts or boundaries that materially help a fresh implementation agent.

Include facts such as:

- an existing component or symbol that already owns the relevant behavior;
- an existing representation or contract that must remain canonical;
- an established boundary where the new behavior belongs;
- a current capability that should be reused rather than rebuilt;
- a known existing behavior that must be retained or verified rather than duplicated;
- a stable path when it is the clearest anchor discovered during the approved analysis.

Do not include:

- speculative implementation choices;
- a layer-by-layer coding checklist;
- exact function bodies or large code snippets;
- guesses about files that were not actually established;
- low-value paths that do not reduce rediscovery or constrain the solution.

Prefer symbols, components, and responsibilities over paths when equally precise. Preserve an exact path when the approved source or targeted repository inspection has already established it as a useful implementation anchor.

The distinction is:

- ticket says **what** behavior to deliver;
- ticket records **which confirmed boundaries and repository facts matter**;
- implementation agent decides **how** to make the smallest coherent code change.

### 6. Handle prefactors and wide refactors

Use a separate prefactor ticket only when it makes a later behavior change materially safer or smaller. The prefactor must preserve behavior and be independently verifiable.

Wide mechanical refactors are an exception to vertical slicing. Use expand-contract:

1. **Expand** - introduce the new form beside the old form while keeping existing callers working.
2. **Migrate** - move callers in independently verifiable batches sized by blast radius.
3. **Contract** - remove the old form only after every migration ticket is complete.

Make every migrate ticket depend on the expand ticket. Make the contract ticket depend on all migrate tickets.

When individual migration batches cannot remain green, explicitly describe the integration constraint and add a final integrate-and-verify ticket.

### 7. Assign blocking edges

Order tickets so blockers appear before blocked tickets.

For every ticket, identify the smallest real dependency set.

Do not add a blocking edge merely because another ticket is listed earlier. A ticket is blocked only when it cannot be implemented or verified correctly before the blocker is complete.

Allow parallel work when tickets have no genuine dependency.

### 8. Present the proposed breakdown

In automatic mode, draft and check the breakdown internally, then proceed to writing without a proposal approval round or full ticket contents in the parent chat.

In standalone mode, before writing files, present a numbered proposal containing, for every ticket:

- **Title**
- **Blocked by**
- **What it delivers**
- **Decision refs**, when the source has explicit decisions
- **Acceptance criteria**

In standalone mode, then ask one concise approval question:

> Approve this breakdown, or tell me which tickets to merge, split, reorder, or rewire.

In standalone mode, revise the proposal until the user explicitly approves it.

In standalone mode, do not write ticket files before approval.

### 9. Write approved tickets and execution record

Create:

```text
<repository-root>/.codex-tasks/branches/<branch-key>/<task-id>/tickets/
```

Write one Markdown file per ticket:

```text
<NN>-<short-slug>.md
```

Number tickets from `01` in dependency order, blockers first.

Do not create one combined ticket document. Do not overwrite unrelated existing tickets.

In standalone mode, if the target directory already contains ticket files or the task has an execution record, stop and ask whether to replace them or create a revised set. Do not silently overwrite them.

In automatic mode, align the generated set with the current confirmed discussion without replacement approval, including replacing ticket edits or statuses and removing obsolete generated tickets. Identify existing generated tickets by source metadata resolving to the exact discussion and the existing numbered ticket format within this task's `tickets/` directory. Never overwrite or remove unrelated files, search other task directories, or delete the directory wholesale. If ownership is unclear or a proposed path collides with an unrelated file, preserve it and return an incomplete alignment with the conflict.

Prepare the complete new ticket set and execution record before modifying existing generated files. Check decision coverage, genuine dependencies, and the execution metadata against the proposed tickets. Require unique identities and paths, resolvable blockers, and an acyclic dependency graph; every ticket must have exactly one execution row and every row must name a ticket in this set. An earlier number alone is never a blocker.

An existing execution record is owned only when its source, repository, branch scope, and task identity match this generated set. Preserve unrelated or ambiguously owned records and report a collision as incomplete alignment. Before modifying an owned set, mark its existing execution record's alignment `incomplete`; if that write fails, stop before changing tickets. Write the replacement tickets, then remove obsolete source-matched tickets, then write the execution record last. Mark it `complete` only after successful ticket writes and cleanup, and validate the saved paths, definition hashes, and blockers against the actual saved ticket set before claiming completion. If any write, cleanup, or read-back validation fails, leave or mark the owned record `incomplete` when possible and report the exact known partial/stale ticket and execution-record paths. If marking fails too, explicitly report the old record as stale; never present it as usable aligned progress. Do not remove unrelated files or directories wholesale.

When the primary source is the task discussion at `../discussion.md` relative to the ticket directory, record that stable relative source path in each ticket. When the source is elsewhere, record the actual source path only if it is a stable local artifact; otherwise use a concise source description.

## Compact execution record

Both approved standalone generation and explicitly authorized automatic decomposition create `<task-directory>/execution.md`, beside `discussion.md` when that is the source. For other supported inputs, use the same resolved branch-scoped task directory and the actual stable source path or confirmed source description; do not invent a discussion artifact.

`to-tickets` owns generation and alignment of this record. A later, separately requested implementation parent owns progress and commit-reference updates. Creating the record never authorizes implementation. Keep scheduling facts here and implementation details in the tickets; do not create separate detailed result artifacts.

Use this compact structure, with paths relative to the execution record and an exact resolved source path in the handoff:

```markdown
# Execution - <task-id>

**Source:** <./discussion.md or actual stable source path/confirmed description>
**Repository:** <absolute Git repository root>
**Branch:** <exact Git branch name>
**Branch key:** <source task's branch directory key>
**Task:** <task-id>
**Alignment:** complete

| Ticket | Path | Definition SHA-256 | Blocked by | Progress | Commit refs | Reconciliation evidence |
| --- | --- | --- | --- | --- | --- | --- |
| 01 - <title> | tickets/01-<slug>.md | <full definition hash> | None | pending | None | None |
```

- Ticket identity consists of its number, exact path, and definition hash; a reused number is not proof of the same specification. Include every genuine blocker by ticket number, or `None`, so a parent can identify pending tickets whose blockers are completed without loading ticket bodies or the entire discussion. An incomplete or stale record is not a scheduling input.
- Compute each definition hash as SHA-256 of the ticket's UTF-8 text with CRLF/CR normalized to LF and only its single `**Status:** ...` line in the metadata block before `## Context` (including its terminating newline, if present) removed. Retain all other content, including source, blockers, acceptance criteria, verification, and formatting. Reject missing or duplicate status metadata in that block. Do not hash progress, commit refs, or this execution record into the ticket definition. A status-only ticket update leaves its definition identity unchanged.
- Initialize progress to `pending`, with commit refs and reconciliation evidence `None`. Progress may later be `in-progress`, `completed`, or `blocked`; ticket specification status remains a separate field. Commit refs must be actual Git commit IDs in this repository, never invented hashes or local artifact paths. `.codex-tasks` records are local workflow artifacts and cannot substitute for Git evidence.
- On regenerated or revised specifications, default to resetting progress, commit refs, and reconciliation evidence. Never retain obsolete completion merely because numbers or paths match. Carry unchanged definitions' progress forward only through explicit reconciliation: verify the same definition hash, confirm that the ticket still covers the revised confirmed source, and record concise evidence with verified Git commit references for retained completion. Changed definitions and tickets transitively depending on invalidated completion must be reset. If reconciliation evidence is unavailable, reset rather than guess. Removed tickets have no rows in the new record.
- Ordinary implementation progress/status updates preserve the definition hashes and do not count as specification revisions. Alignment checks still compare hashes and dependencies with the actual ticket files; status-only edits do not require invalidating completion.

## Ticket Template

Use this exact structure:

```markdown
# <NN> - <Ticket title>

**What to build:** <The complete end-to-end behavior this ticket delivers from the user or system perspective. Do not provide a layer-by-layer implementation checklist.>

**Blocked by:** <Ticket numbers and titles, or "None - can start immediately".>

**Status:** ready-for-agent

**Source:** <`../discussion.md`, another stable artifact path, or a concise source description>

**Decision refs:** <Applicable decision IDs such as `D1, D2`, or `None`>

## Context

<Only the task-specific decisions, constraints, and domain context needed to implement this ticket correctly.>

## Implementation context

- <Confirmed repository fact, implementation boundary, existing capability, or stable anchor that materially reduces rediscovery.>
- <Another relevant confirmed fact, or `None` when no such context is needed.>

## Acceptance criteria

- [ ] <Observable or verifiable result>
- [ ] <Observable or verifiable result>

## Verification

- <The expected targeted checks or evidence. Do not invent authorization for external or state-changing checks.>

## Out of scope

- <Related work intentionally excluded from this ticket.>
```

## Writing Rules

- Describe outcomes, not a file-by-file implementation recipe.
- Keep each ticket self-contained for normal implementation while avoiding duplication of irrelevant parent-task context.
- Preserve all confirmed decisions that materially constrain the slice.
- Preserve confirmed repository anchors when they materially reduce rediscovery or prevent a wrong implementation direction.
- Prefer symbols, components, and responsibilities over exact paths when equally precise.
- Include an exact path when it is an established and useful anchor, not merely because it was encountered during exploration.
- Do not repeat the entire discussion artifact in every ticket.
- Do not copy rationale that is not needed to preserve a constraint or prevent reinterpretation.
- Include a short decision rationale only when omitting it could plausibly cause an implementation agent to choose a rejected alternative.
- Use acceptance criteria that can be checked, not vague statements such as "works correctly".
- Keep context compact enough for a fresh implementation chat.
- Do not create speculative follow-up tickets outside the approved scope.
- Do not turn `Implementation context` into an ordered coding plan.
- Never import requirement context from another branch's `.codex-tasks` directory.

## Completion

After writing the files, report:

- task ID;
- output directory;
- ticket count;
- exact source discussion path, when applicable;
- exact execution-record path and whether ticket/record generation and alignment completed;
- every generated ticket path with a short description and blocking dependencies;
- tickets that can start immediately;
- the recommended first ticket.

In either mode, explicitly distinguish completed ticket and execution-record generation/alignment from an incomplete result. Include the specific blocker or failure and every known partial or stale ticket/record path when incomplete; distinguish an intended output path from a successfully saved artifact. In automatic mode, return this compact handoff to the parent without full ticket contents or another review request.

Do not implement any ticket. The next step must be explicitly initiated by the user in a separate implementation request or chat.
