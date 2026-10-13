---
name: implement-discussion
description: Coordinate an approved discussion's ticket set only on explicit request, using its compact execution record and one fresh, context-isolated implement-ticket child at a time. Authorize bounded local implementation and commits, verify completion against Git evidence, collect pending manual acceptance, and stop at failures, ambiguous recovery, or user prerequisites. Do not implement production code in the parent, automatically review, regenerate specifications, or mutate remote systems.
---

# Implement Discussion

Implement the selected approved ticket set sequentially. This skill is an optional
alternative to requesting each `implement-ticket` separately; discussion
confirmation and ticket generation never invoke it or authorize implementation.

## Authority and ownership

An explicit `$implement-discussion <discussion-path-or-execution-path>` request
authorizes the selected set's local implementation, required permitted automatic
verification, local Git commits, each child's assigned status-only update, and
parent updates to execution progress and evidence. Explicit resume must identify
the same set. Existing artifacts, completed statuses, or elapsed time do not
constitute an invocation, approval, or resume request.

The parent coordinates and updates only the selected `execution.md`. It makes no
production-code changes and never edits the discussion or ticket specifications,
including ticket statuses. The assigned child alone may change its ticket's
status under the exact local `../implement-ticket/SKILL.md` contract. Do not
create another detailed result artifact or a workflow engine.

Do not invoke discussion, decomposition, or review skills automatically. No push,
PR, deployment, remote mutation, automatic retry, replacement child, skipped
failure, reset, or destructive cleanup is authorized. Preserve unrelated staged
and working-tree changes. Shared filesystem changes survive fresh child contexts.

## Intake and capability checks

1. Resolve the explicit input and its task directory. For a discussion input,
   locate `execution.md` beside it; for an execution input, resolve its source.
   Ask which set to use if the input is ambiguous; never choose the newest set.
2. Capture repository root, exact branch (or explicit detached state), HEAD, and
   `git status --short`, including the index. Retain mechanical source/ticket
   content hashes and ticket statuses for the later immutability comparisons;
   do not load their bodies into the conversation. Read applicable repository
   instructions and the compact execution record. Inspect source approval
   metadata only as needed to establish a confirmed discussion and its identity;
   do not load the complete discussion or sibling ticket bodies for scheduling.
3. Verify available tools and permissions support delegation, a fresh child with
   no inherited parent history, waiting for outcomes, contacting/interrupting the
   sole active child, and local Git inspection and commits. Resolve the exact
   absolute local `implement-ticket/SKILL.md` path and verify it exists. If any
   capability is unavailable, stop before launching or changing progress; name
   the blocker and the separate standalone alternative. Instructions cannot
   grant unavailable tools or bypass environment approval requirements.
4. Validate the record and reconcile any prior progress before choosing a ticket.
   Pre-existing changes must be preserved and disclosed. If they overlap or make
   scoped implementation/commit evidence ambiguous, stop for user instructions.

### Missing execution record

If `execution.md` is absent, stop before artifact creation or implementation.
Ask one choice: explicitly authorize this parent to create the compact record
from the existing approved ticket metadata, or address generation/alignment with
`to-tickets` first (recommended). Wait for the answer. Do not invoke `to-tickets`
or interpret silence as permission.

Only explicit parent-creation authorization permits creation. Reuse the exact
`Compact execution record` contract in `../to-tickets/SKILL.md`: source,
repository/branch/task identity, one row per existing ticket, definition hashes,
genuine blockers, and progress/evidence fields. Validate the existing set before
writing; do not rewrite, renumber, regenerate, or decompose specifications. New
rows start `pending` with `None` commit refs and reconciliation evidence. An
already-completed ticket then requires the Git reconciliation below; never
invent completion evidence. Missing approval, inconsistent metadata, or a failed
write stops recovery. Choosing generation first ends this run with its exact
standalone invocation; creation and implementation remain unexecuted.

## Execution contract and validation

Use the existing `to-tickets` record directly, with paths relative to that record:

```text
Source, Repository, Branch, Branch key, Task, Alignment
Ticket | Path | Definition SHA-256 | Blocked by | Progress | Commit refs | Reconciliation evidence
```

Alignment must be `complete`. Progress values are `pending`, `in-progress`,
`completed`, or `blocked`; specification status is a separate ticket field.
Preserve source, identities, hashes, paths, and blockers during implementation.
Use reconciliation evidence for compact checks, failure stage, blockers, remaining
changes, and unexecuted manual checks, not duplicated implementation context.
For each exempted baseline error, retain the check, concise diagnostic, affected
files, proof of pre-existence and baseline equivalence, and why the required
ticket behavior remains verifiable. Use this existing column; add no schema or
detailed error artifact.

Before launch, and again before advancing after a child, check:

- The resolved repository root, exact branch/detached identity, branch key, task
  directory, and source match the actual selected set. Do not change branches to
  make metadata fit. Ticket sources must resolve to the record's approved source.
- Every source-matched numbered ticket in this task's `tickets/` directory has
  exactly one row, with a unique number and resolved path inside that directory.
  Reject missing references, duplicate identities, escaped paths, incomplete
  records, or an unmatched ticket. Preserve unrelated artifacts.
- Parse only ticket metadata for scheduling. Confirm number/title/path, source,
  status, and genuine blockers agree with the record. Normalize blocker numbers
  from the ticket's `Blocked by` field; earlier numbers alone are never blockers.
  All blockers must exist in this set, with no self-dependencies or cycles.
- Recompute each full SHA-256 exactly as `to-tickets` specifies: normalize the
  UTF-8 text's CRLF/CR to LF and remove only its single `**Status:** ...` metadata
  line before `## Context`, including that line's terminating newline if present.
  Reject missing/duplicate status metadata; retain every other byte of normalized
  content. Process text mechanically without loading ticket bodies into the
  parent conversation. Status-only updates do not change definition identity.
- A new eligible ticket has status `ready-for-agent`, progress `pending`, no
  unexplained commit refs, and every genuine blocker reconciled as completed.
  `completed` status alone is insufficient; other status/progress combinations
  require reconciliation or a user gate, not automatic scheduling.

Changed definitions, reused numbers with different hashes, or inconsistent
metadata stop advancement. Do not refresh hashes or silently reuse stale
completion, reset progress, replan, or regenerate. Report affected tickets and
transitive dependents whose prior completion cannot support continuation. Ask
for explicit resolution of the revised approved set in a separate request.

## Sequential delegation

Choose one eligible ticket at a time; use ascending ticket number only as a
deterministic tie-breaker. Several eligible tickets still execute sequentially.
If pending tickets remain with no eligible ticket, report the blocking evidence
and stop. Never skip a failed or unresolved prerequisite.
An unresolved intermediate manual prerequisite also prevents a dependent launch,
even when the prerequisite ticket's implementation is recorded as completed.

Before launch, capture HEAD and repository/index state, mark this row
`in-progress`, retain the baseline HEAD in its reconciliation evidence, and
confirm the write succeeded. Launch exactly one fresh child
with no inherited parent conversation (for example `fork_turns: "none"`). Supply
only this bounded assignment, using exact resolved paths:

```text
Explicitly apply <absolute-local-implement-ticket/SKILL.md> to
<absolute-selected-ticket-path>.
Dependency evidence: <only relevant completed blockers: identities, definition
hashes, verified commit refs; or an explicit statement that there are no blockers>.
Authority: implement only this ticket, perform its required permitted automatic
verification, create its scoped local Git commit, and then update only its Status
value under the skill's delegated completion contract. Return compact evidence
to this parent. You are not alone in the shared repository: preserve other edits
and the index. Do not delegate, continue into another ticket, edit execution.md,
rewrite specifications, review, or mutate remote systems.
```

Do not attach the parent history, full discussion, sibling specifications, full
diffs/logs, or duplicate repository investigation. The child reads its own ticket
and applicable instructions, and uses selective source lookup under its skill.
Wait for this child's final result and termination before any next launch. Do
not start another child while it is waiting, correcting, blocked, or interrupted.

Observe the same child using only lifecycle/activity capabilities exposed by the
client. A wait timeout, silence, elapsed time, an absent reply, or unchanged files
alone establishes neither failure nor blocking. While its lifecycle remains
running, retain that child and execution `in-progress`; never interrupt or launch
another child on those grounds. If lifecycle cannot be established, report the
uncertainty and do not infer termination or launch a replacement.

Track actual elapsed time since the last observable progress, starting at launch
until progress is observed. Compact stage changes, long-check start/end updates,
or exposed activity that demonstrates advancement are progress; repeated running
status and wait timeouts are not. Retain the observed time, stage, active check,
and process/session identity when available. Reset the inactivity interval on
actual progress, whether it arrives before or after the notification threshold;
do not estimate elapsed time from poll counts.

After five minutes without observable progress, ask the user once whether to
keep waiting (recommended while the child is running) or interrupt. Five minutes
is a notification threshold, never a ticket deadline. While that decision is
unanswered, keep the same child and `in-progress`, continue observing, and do not
repeat the unresolved request. Progress may be reported while the answer remains
pending; neither progress nor silence supplies interruption authority. An actual
choice to continue waiting keeps the same child active and starts a new full
five-minute notification interval from that answer, or later observable progress.
It grants no future cancellation authority. An interrupt choice follows the
confirmed-stop contract below; an independently established terminal outcome
instead follows the ordinary completion or failure contract.

Ordinarily wait up to 60 seconds per call using the exposed waiting capability,
and keep concise user visibility within the environment's update requirements.
Report meaningful stage changes and long-check start/end information economically,
including the known active check and process/session identity. Pending tool calls
may delay child message processing; require neither an immediate reply nor a
strict heartbeat. Avoid redundant status nudges, alternating short waits and
sleeps, repeated context loading, and full logs/diffs. Waiting itself never
supplies approval.

Preserve the child's bounded correction and test-first rules. Meaningful expected
RED and correctable verification failures are intermediate outcomes, not ultimate
failure. Do not stop the normal authorized RED/GREEN/correction cycle or expand
it into additional tests or runtime permissions.

## Evidence before advancement

Require the child's exact ticket path/status, actual full commit hash and subject,
scoped changed paths, permitted verification results (including RED/GREEN when
applicable), unexecuted manual checks, blockers, and remaining task changes.
Then independently check concise actual evidence:

1. The commit exists in this repository, is reachable from current HEAD on the
   same branch, and belongs to the captured execution interval. Check the actual
   subject and changed paths against the return. Investigate unexpected commits
   or branch movement; an unrelated historical commit is not completion proof.
2. Inspect commit metadata/path summaries and narrow changed areas only when
   needed to establish ticket scope. Preserve the baseline's unrelated staged
   and working-tree changes; task artifacts must not be force-added or substitute
   for the implementation commit. Any unexplained inclusion or remaining task
   implementation changes blocks completion. Avoid full logs or repository diffs.
3. Confirm required permitted automatic checks ran and their actual outcomes
   satisfy the ticket. Checks must pass except for failures meeting every
   condition in `Baseline failure exemption` below. Assess the child's compact
   baseline proof and behavior-verification evidence before accepting an
   exemption. Distinguish task failures, unrelated baseline failures, environment
   blockers, expected RED, and final GREEN. A blocked required check prevents
   completion; expected RED and bounded corrections remain intermediate results.
4. Confirm this ticket now has status `completed` and its definition hash is
   unchanged. Confirm discussion and all other ticket contents/statuses remain
   unchanged using mechanical comparisons against intake snapshots. Revalidate
   the scheduling metadata; unexpected shared-state changes stop advancement.
5. Only then write parent progress `completed`, actual commit refs, and compact
   reconciliation/verification evidence, including each exempted baseline error
   and pending manual acceptance. Confirm
   the record was saved. If recording fails, stop; report the verified commit and
   status as an interrupted partial result rather than advancing without a record.

Ignored `.codex-tasks` artifacts record local progress, not independent Git proof.
Do not record completion merely from a child's claim, ticket status, attempted
commit, suggested subject, or ignored artifact. Capture actual evidence before
marking progress or declaring the set implemented.

### Baseline failure exemption

An already-authorized scoped commit and completion may coexist with unrelated
pre-existing failures only when required permitted checks ran, evidence proves
the failures predate the ticket and are unrelated to its changes, and the
required ticket behavior is verified. An explicit clean-check requirement
remains binding. Confirm baseline equivalence for the failing check: identify
the relevant pre-ticket revision/state, command and scope, inputs, and environment,
and show the same relevant diagnostic under equivalent conditions. Explain why
the ticket changes neither cause the failure nor obscure verification of its
required behavior. A merely plausible existing failure, historical unverified
report, or unchanged affected paths alone is insufficient proof.

Obtain and assess evidence only within existing inspection/execution permissions.
Do not change production code to manufacture a baseline, repair unrelated errors,
weaken tests, or expand verification authority. Task regressions require bounded
correction or stopping. Uncertain attribution, environment/permission blockers,
unavailable required verification, baseline errors masking required behavior,
and unmet explicit clean-check requirements prevent completion and advancement.
Preserve manual acceptance/prerequisite gates and all independent Git, scope,
status, definition-hash, and ownership checks.

Retain each exempted check's concise diagnostic, affected files, baseline proof,
and behavior-verification assessment in `execution.md` and final output. Report
actual outcomes; a completed result with residual errors must never claim all
checks passed. Suggest follow-up tickets only; do not create or implement them,
repair unrelated errors, replan, invoke decomposition/review, or create another
detailed error artifact.

## Failures, manual checks, and interruption

An ultimate child failure stops all subsequent implementation. Record `blocked`
and compact failure evidence when safe, highlight the failed stage and remaining
working-tree/index changes, preserve them, and wait for explicit instructions.
Do not automatically retry, replace the child, skip ahead, reset, or resume. A
failure to save progress is also a stop; report stale record fields accurately.

Collect deferrable manual checks in the record for final user acceptance after
the set completes. Completed implementation does not mean manual acceptance.
If a manual prerequisite prevents safe continuation, pause before dependent
work, record the gate separately from implementation completion, and explain the
specific input/action needed. Wait for an actual answer. Route a child's gate
through the parent to the user and return the answer to the same waiting child;
do not create a replacement child. Preserve explicit per-task permission rules
for API/UI/E2E/integration tests, services, browsers, and external systems.
Generic verification wording and local commit authority do not authorize them.
Code review remains a separate manually requested workflow.

Interrupt only on the user's actual interrupt choice or an applicable stop
request. Prevent further launches and contact/interrupt the sole child as needed
to honor that choice or request. Do not declare quiescence until its lifecycle
confirms it has stopped; if confirmation is unavailable, report the stop as
unconfirmed and retain `in-progress` while preventing advancement. After confirmed
interruption, record `blocked` and compact evidence of the observed stage, active
check/process identity when known, user choice or stop request, and confirmed
lifecycle outcome. Preserve partial edits and evidence; never assume an
interrupted child left a clean tree or attribute an unproven cause to its silence.
Confirmed interruption, like terminal failure, requires explicit user-directed
recovery; no automatic retry, replacement child, skipped failure, or resume.

### Explicit resume and reconciliation

Resume only on explicit user request. First confirm no prior child is still
running; if lifecycle state cannot be established, stop. Revalidate identity,
alignment, definitions, dependencies, source approval, and repository/index state
before selecting anything. Reconcile commit, status, and progress separately:

- Matching completed status, unchanged definition, and verified scoped commit
  and required verification evidence may reconcile a pending/in-progress row to
  `completed` without reimplementation. Apply the same baseline failure exemption
  and retain each error's proof and relevance assessment; missing or unproven
  exemption evidence prevents reconciliation. Record how the missing parent
  update was established.
- A commit with a still-ready status is an interrupted status update, not a new
  pending implementation. The parent cannot edit ticket status. Stop and request
  the specific user-directed status-only recovery after proving the commit and
  verification; do not launch another implementation automatically.
- Completed status or progress without verifiable commit/scope/check evidence,
  unrecorded commits of uncertain ownership, partial edits, or an in-progress row
  without a complete outcome is ambiguous. Surface the actual evidence and ask
  how to recover; never infer success or assume nothing ran and rerun the ticket.
- A `blocked` row requires explicit recovery instructions in addition to resume;
  do not clear it or retry its child automatically. A prerequisite manual gate
  requires its actual answer/authorization even if a resume was requested.
- Changed definitions invalidate obsolete evidence even with reused numbers.
  Stop for explicit resolution; unchanged downstream rows cannot rely on a
  prerequisite whose completion is stale. No automatic replanning/decomposition.

Validate existing completed rows' actual commits and recorded verification before
using them as blockers' completion evidence, including the complete evidence for
each exempted baseline error under the same completion gate. A lost record or missing child
outcome cannot be repaired by trusting statuses alone. If compact retained
evidence cannot establish the required facts, ask instead of guessing.

## Final response

Report the exact discussion and execution paths, implemented tickets with actual
commit hashes/subjects and scoped paths, permitted check results, and all
unexecuted manual acceptance checks. State blockers, stopped stage, stale or
partial progress, and remaining task changes when applicable. Distinguish full
implementation from pending manual acceptance; do not claim review or runtime
checks occurred when they did not. Keep the handoff compact and provide the
specific next user action only when a gate or recovery is required.
For every exempted baseline error, include the check, concise diagnostic, affected
files, baseline-equivalence proof, and why required ticket behavior was verified.
State residual errors visibly without claiming all checks passed, and suggest
follow-up tickets only; do not create or implement them or expand the workflow.
