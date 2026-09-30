---
name: codebase-design
description: "Advisory engineering skill for focused code design: modules, interfaces, seams, dependencies, and testability. Investigate repository facts, resolve material design questions one at a time, and save a handoff for substantial decisions. Use for a new abstraction, a focused refactoring, or a hard-to-reverse design choice. Do not perform repository-wide architecture audits or implement refactors."
---

# Codebase Design

Use this skill as a reusable design lens for focused engineering decisions. Produce recommendations and trade-offs, not codebase modifications.

Return routine local recommendations in the conversation. For a substantial design decision that should survive the conversation, create a branch-scoped Design Recommendation handoff.

## Operating boundaries

- Stay advisory-only. Do not edit, refactor, or create production code unless the user explicitly switches to an implementation workflow outside this skill.
- Creating or updating a design handoff artifact does not authorize implementation. The artifact records the recommendation for downstream workflows; production code remains outside this skill.
- Keep the scope focused on the design problem or code area the user asks about. Do not silently expand into a repository-wide audit.
- If the real task is to discover architectural problems across a whole repository, recommend the `architecture-review` workflow instead.
- If repository context is available, discover and respect applicable repository instructions, architecture docs, conventions, existing patterns, tests, and constraints. Do not assume specific filenames or structures.
- Treat repository rules as constraints, not as universal design principles. Do not invent repository policy.
- Prefer existing coherent patterns unless there is a clear reason to change them.
- Optimize for maintainability and clarity for both humans and coding agents; do not optimize for AI at the expense of sound software design.

## Core vocabulary

Use these terms consistently when they clarify the discussion:

- **Module**: a unit with an interface and an implementation; it may be a function, class, package, subsystem, or vertical slice.
- **Interface**: everything a caller must know to use a module correctly, including inputs, outputs, invariants, error modes, ordering constraints, configuration, and meaningful performance characteristics.
- **Implementation**: behavior hidden behind the interface.
- **Seam**: a place where behavior can vary without callers needing to understand the implementation details.
- **Adapter**: a concrete implementation that connects a seam to another system or mechanism.
- **Depth**: useful behavior or complexity hidden behind a relatively small interface.
- **Locality**: how well knowledge, change, bugs, and verification stay concentrated rather than spreading across callers.
- **Leverage**: how much capability multiple callers gain from learning and depending on one stable interface.

Read `references/design-principles.md` when evaluating a non-trivial design or comparing alternatives.

## Interaction and checkpointing

Resolve design facts from the repository before asking the user. Ask only about material goals, constraints, or trade-offs that repository evidence cannot settle. Discuss one question at a time: explain why it matters, recommend an answer with reasons, and offer concise alternatives when useful. Wait for the answer before advancing to a dependent question. Do not deliver a completed recommendation with a list of user-resolvable questions.

For a substantial decision meeting the handoff criteria below, create a compact `draft` artifact after the initial investigation. Record the problem, evidence pointers, provisional options, confirmed decisions, and next unresolved question if any. Report its path so another conversation can resume. Update it only when material evidence or a decision changes; do not repeatedly rewrite a full recommendation. Before marking it `complete`, summarize the recommendation and ask the user to confirm it. Record unavailable external evidence as a limitation with its effect on the recommendation; resolve user-answerable questions that materially affect it.

## Workflow

### 1. Frame the design problem

Identify:

- what behavior or responsibility is being designed;
- who the callers are;
- what currently changes together;
- what is expected to vary independently;
- external systems or side effects involved;
- important repository constraints;
- the concrete pain being solved.

Do not propose an abstraction until the problem is explicit enough to explain why the abstraction should exist.

### 2. Inspect the current shape

When code or repository access is available, inspect only enough context to understand the relevant design:

- callers and call sites;
- dependencies and dependency direction;
- related tests and observable behavior;
- existing abstractions and conventions;
- duplicated orchestration or leaked knowledge;
- side effects and external boundaries.

Distinguish structural complexity from necessary domain complexity. Do not recommend refactoring merely because a module is large or a wrapper is thin.

### 3. Identify the natural interface and seam

Ask:

- What should callers need to know?
- What complexity can be hidden?
- What behavior belongs together because it changes together?
- Where does behavior genuinely vary?
- Which side effects should be isolated behind explicit seams?
- Would removing this abstraction distribute its complexity across multiple callers, or simply remove indirection?

Avoid speculative interfaces, factories, ports, or base classes when there is no demonstrated variation or meaningful complexity to hide.

### 4. Design alternatives when the decision matters

For high-impact or hard-to-reverse interfaces, produce at least two materially different designs before recommending one. Vary the actual interface or seam placement, not just class names.

Compare alternatives on:

- interface size and conceptual load;
- depth and hidden complexity;
- change locality;
- coupling and dependency direction;
- testability through observable behavior;
- side-effect isolation;
- migration/refactoring cost;
- consistency with repository conventions;
- ease of navigation and modification by future maintainers and agents.

For small or obvious decisions, do not manufacture alternatives just to satisfy a ritual.

### 5. Define the behavioral contract

For the recommended design, state the stable behavior that callers should rely on:

- responsibilities;
- inputs and outputs;
- important invariants;
- failure/error behavior;
- side effects;
- variability points;
- what remains intentionally hidden.

Prefer behavioral contracts over implementation-level prescriptions.

### 6. Describe verification implications

Recommend how the design should be verified without turning this skill into an implementation workflow.

Prefer tests at stable behavioral interfaces when they provide strong coverage of intent. Also preserve or recommend lower-level unit/property tests when they cheaply protect complex algorithms, edge cases, or important invariants.

For side-effecting modules, verify behavior at the narrowest useful seam. Do not introduce mocks, ports, or interfaces solely to make a test possible if a simpler realistic substitute or integration boundary already exists.

### 7. Give the recommendation

Keep the output decision-oriented. Include:

1. **Problem** — what design pressure exists.
2. **Recommendation** — the proposed module/interface/seam shape.
3. **Why** — the main trade-offs and why this option wins.
4. **Behavioral contract** — what callers should rely on.
5. **Verification** — what should prove the design works.
6. **Risks / open questions** — only material uncertainties.

If the current design is already appropriate, say so. Do not invent a refactoring opportunity.

### 8. Persist a substantial recommendation

Keep routine local recommendations in the conversation.

Produce a persistent Design Recommendation handoff when one or more of these apply:

- the decision affects multiple modules, interfaces, seams, or architectural boundaries;
- the recommendation is likely to result in multiple implementation tasks;
- important design drivers, alternatives, or trade-offs need to survive the current conversation;
- downstream discussion, planning, or implementation is expected to happen in a fresh context;
- the recommendation represents a significant or hard-to-reverse design decision;
- the user explicitly asks to preserve the recommendation.

Do not create a persistent artifact for routine local or easily reversible design
decisions unless requested.

When a persistent handoff is warranted:

1. Save the compact draft after initial investigation at `<repository-root>/.codex-tasks/branches/<branch-key>/<task-id>/design-recommendation.md`.
2. After the user confirms the conclusion, read `references/design-recommendation-template.md` and expand the same artifact into the complete handoff.
3. Record the final recommendation, confirmed decisions, and material reasoning, not the full exploration history.
4. Keep it concise enough for a downstream agent or human to consume without reconstructing the original conversation. Report the path and status.

Resolve the repository root with `git rev-parse --show-toplevel` and preserve the original name from `git branch --show-current` in artifact metadata. Make `<branch-key>` lowercase with only letters, digits, and hyphens: replace unsupported characters, collapse repeated hyphens, and trim them. For detached HEAD use `detached-<short-sha>`. Outside Git, use the current working directory as root and `no-git` as the branch key; record the fallback.

Reuse the current task ID when supplied or established by an existing discussion artifact. Otherwise generate `<YYYYMMDD-HHMM>-<short-design-slug>`. Normalize it with the same filesystem-safe rules and keep it stable. Check collisions only in the current branch directory; suffix an ID when it belongs to another task. Never overwrite an unrelated artifact. Create the task directory when saving the first draft.

A Design Recommendation is a working handoff. It is not authoritative repository
documentation and must not be treated as proof that the proposed design was
implemented.

## What not to do

- Do not equate "deep" with "large" or count lines to measure depth.
- Do not treat every thin adapter as a design smell; adapters at UI, network, storage, browser, device, or other external seams are often intentionally thin.
- Do not require pure functions where the responsibility is inherently side-effecting; isolate side effects instead.
- Do not delete valuable internal tests simply because interface-level tests exist.
- Do not add abstractions for hypothetical future implementations.
- Do not prescribe dependency injection, ports-and-adapters, DDD, clean architecture, or another named style by default.
- Do not optimize for maximum abstraction. Prefer the smallest design that meaningfully improves locality, leverage, or testability.
- Do not create persistent Design Recommendations for routine local decisions unless requested or a downstream handoff clearly benefits from one.
- Do not treat a Design Recommendation as permanent repository documentation, an implementation plan, or authorization to modify production code.
- Do not create permanent repository documentation for a design handoff.
