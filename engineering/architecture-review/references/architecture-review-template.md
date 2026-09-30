# Architecture Review Template

Use this template as a stable handoff contract for a substantive architecture review.

Keep the artifact evidence-oriented and decision-oriented. Preserve conclusions, supporting evidence, and prioritization; do not reproduce the full exploration history.

The review is a working analysis artifact. It is not authoritative repository documentation, a detailed target design, or an implementation plan. Use a compact `draft` checkpoint during discussion; expand it into this template only after the user confirms the conclusions.

## Contents

- Stability rules
- Metadata
- Scope
- Repository Model
- Executive Summary
- Findings
- Prioritized Improvement Candidates
- Confirmed Review Decisions
- Cross-Cutting Guardrail Gaps
- Documentation Gaps
- Areas Intentionally Left Alone
- Open Questions

## Stability rules

The following sections form the stable handoff contract and should normally be present:

- Metadata
- Scope
- Repository Model
- Executive Summary
- Findings
- Prioritized Improvement Candidates
- Areas Intentionally Left Alone

The following sections may be omitted when they contain no material information:

- Cross-Cutting Guardrail Gaps
- Documentation Gaps
- Confirmed Review Decisions
- Open Questions

Do not invent findings, candidates, gaps, or open questions to fill the template.

---

# Architecture Review

## Metadata

- Status: `complete`
- Task ID: <task-id>
- Repository root: <absolute path>
- Branch: <original branch name, detached HEAD, or non-Git fallback>
- Branch key: <branch-key>
- Reviewed at: <ISO-8601 timestamp>
- Artifact path: <path to this file>

For a draft, use `Status: draft` and only the scope, evidence pointers, provisional conclusions, resolved decisions, and next unresolved question needed to resume. Do not fill the full template until completion.

## Scope

State what repository, subsystem, or area was reviewed and any important exclusions or access limitations.

Clarify whether the review is broad, targeted, or partial. Never imply exhaustive coverage when it was not achieved.

## Repository Model

Summarize the minimum architectural model needed to understand the review:

- major responsibilities/components;
- important dependency direction;
- external-system boundaries;
- important state/lifecycle ownership;
- major execution or data flows;
- primary verification boundaries.

Do not turn this into full repository documentation.

## Executive Summary

Give a concise assessment of the reviewed architecture.

State:
- the most important strengths or stabilizing characteristics;
- the highest-value architectural concerns, if any;
- whether substantial refactoring appears justified;
- the recommended order of attention.

## Findings

Record material evidence-backed observations. Group related evidence into one finding rather than listing every occurrence separately.

For each finding use:

### <Finding title>

**Category:** Architecture problem | Guardrail gap | Documentation gap  
**Confidence:** High | Medium | Low  
**Affected area:** <modules/packages/subsystem>

**Evidence**
- Concrete files, symbols, dependency relationships, repeated patterns, relevant history, tests, configuration, or documentation observations.

**Why it matters**
Explain the practical consequence: change cost, regression risk, verification difficulty, cognitive load, operational risk, or architectural drift.

**Direction**
State the direction of improvement without prescribing a detailed implementation design.

## Prioritized Improvement Candidates

Include only work that appears valuable enough to consider doing.

For each candidate use:

### <Candidate title>

**Type:** Refactoring | Guardrail | Documentation  
**Priority:** High | Medium | Low  
**Confidence:** High | Medium | Low

**Problem boundary**
State what related finding(s) this candidate addresses and where the boundary of the work should be.

**Expected payoff**
Describe the concrete engineering benefit: improved locality, lower blast radius, stronger verification, reduced accidental complexity, clearer ownership, or another material outcome.

**Approximate scope**
Identify the likely affected components without turning this into ticket decomposition.

**Cost / migration risk**
State meaningful disruption, compatibility concerns, or uncertainty.

**Suggested next step**
Choose the appropriate next activity, such as focused design, task discussion/planning, adding an executable guardrail, or synchronizing documentation.

## Confirmed Review Decisions

Record user decisions that materially shaped the findings, priorities, or recommended next step. Include the choice, brief rationale, and its effect on the review. Omit this section when no such decisions were needed. Do not reproduce the question-and-answer transcript.

## Cross-Cutting Guardrail Gaps

List important architectural invariants that are reasonable but insufficiently enforced.

Prefer describing the invariant that needs protection rather than prescribing a repository-specific tool unless that tool is already established.

Omit this section when there are no material cross-cutting guardrail gaps.

## Documentation Gaps

List architecture or engineering knowledge that is missing, stale, contradictory, or difficult to discover.

Do not duplicate findings already classified as documentation gaps unless this section is useful for consolidating cross-cutting documentation work.

Omit this section when documentation is adequate for the reviewed scope.

## Areas Intentionally Left Alone

Record notable areas where a possible imperfection was considered but no change is recommended.

For each, briefly state why intervention is not justified now, such as:
- low change frequency;
- high migration risk;
- acceptable deliberate trade-off;
- intentionally thin external adapter;
- duplication cheaper than abstraction;
- insufficient evidence of practical harm.

Keep this selective; do not inventory every acceptable part of the repository.

## Open Questions

List only questions requiring evidence unavailable during this review. State how each limits confidence or affects the next step. Resolve user-answerable questions that materially affect the conclusions before marking the review complete.

Do not include routine implementation details that can be resolved during delivery.

Omit this section when none remain.
