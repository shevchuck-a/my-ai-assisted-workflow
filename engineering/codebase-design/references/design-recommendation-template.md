# Design Recommendation Template

Use this template when a design decision needs to survive the current conversation
and serve as input to downstream discussion, planning, or implementation.

The artifact is a design handoff, not repository documentation and not an
implementation plan.

Keep it concise and decision-oriented. Record conclusions and material reasoning,
not the full exploration history.

## Stability rules

The following sections form the stable handoff contract and should normally be
present:

- Metadata
- Problem
- Design Drivers
- Recommendation
- Proposed Boundaries
- Behavioral Contract
- Trade-offs
- Verification Implications

The following sections are optional and may be omitted when they provide no useful
downstream information:

- Current Shape
- Alternatives Considered
- Confirmed Design Decisions
- Open Questions

Do not invent alternatives, risks, constraints, or open questions merely to fill
the template.

Do not prescribe repository-specific tools or conventions unless they were
discovered from the repository context.

---

# Design Recommendation

## Metadata

- Task ID: <task-id>
- Repository root: <absolute path>
- Branch: <original branch name, detached HEAD, or non-Git fallback>
- Branch key: <branch-key>
- Status: `complete`
- Updated: <ISO-8601 timestamp>
- Artifact path: <path to this file>

For a draft, use `Status: draft` and record only the problem, evidence pointers,
provisional options, confirmed decisions, and next unresolved question needed
to resume. Expand the full template after the user confirms the conclusion.

## Problem

Describe the concrete design pressure being addressed.

Explain why the current or proposed design requires a decision. Focus on the
problem rather than the preferred solution.

## Current Shape

Summarize only the existing responsibilities, dependencies, boundaries, or
limitations needed to understand the recommendation.

Omit this section when designing something new and there is no meaningful current
shape.

## Design Drivers

List the constraints and qualities that materially influenced the decision.

Include only relevant drivers, such as:

- change locality;
- interface simplicity;
- testability;
- dependency direction;
- compatibility;
- external-system boundaries;
- side-effect isolation;
- operational complexity;
- repository conventions or constraints;
- maintainability and navigability.

## Recommendation

Describe the recommended design.

Explain the central design decision and why it best satisfies the identified
drivers.

Keep implementation details out unless they are necessary to define the design.

## Proposed Boundaries

Describe the important structural boundaries introduced, removed, or changed.

Where relevant, identify:

- module responsibilities;
- interfaces;
- seams;
- adapters;
- dependency direction;
- ownership of side effects;
- intentionally hidden implementation details.

Use diagrams or short pseudocode only when they materially improve clarity.

## Behavioral Contract

Describe what callers or neighboring modules should be able to rely on.

Include relevant:

- responsibilities;
- inputs and outputs;
- invariants;
- error or failure behavior;
- externally visible side effects;
- variability points;
- behavior intentionally hidden behind the interface.

Prefer behavioral guarantees over implementation prescriptions.

## Alternatives Considered

Include only materially different viable alternatives that were seriously
considered.

For each alternative, briefly state:

- what differs;
- its main advantage;
- why it was not preferred.

Omit this section when no meaningful alternative needed evaluation.

## Trade-offs

State the meaningful costs, benefits, and risks introduced by the recommendation.

Do not list generic software-engineering trade-offs that do not affect this
decision.

## Verification Implications

Describe what downstream implementation should prove in order to preserve the
design intent.

Identify relevant behavior or invariants and the appropriate verification level
when useful, such as:

- behavioral or unit tests;
- regression tests;
- property tests;
- contract or integration tests;
- architecture or dependency checks;
- static verification.

Do not turn this section into an implementation checklist.

## Confirmed Design Decisions

Record user choices that materially shaped the recommendation, with brief
rationale and their effect on the design. Omit when none were needed.

## Open Questions

List only questions requiring evidence unavailable during this design work.
State how each limits confidence or affects the next step. Resolve
user-answerable questions that materially affect the recommendation before
marking the handoff complete.

Do not include implementation details that can safely be decided during normal
delivery work.

Omit this section when no material design questions remain.