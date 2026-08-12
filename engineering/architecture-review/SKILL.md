---
name: architecture-review
description: "Advisory engineering skill for reviewing the architecture of an existing repository or substantial subsystem, identifying evidence-backed structural problems, guardrail gaps, and documentation gaps, and prioritizing refactoring candidates by expected engineering value. Use for repository setup reviews, periodic architecture health checks, pre-refactoring analysis, or when a codebase has become hard to change, test, navigate, or reason about. Respect repository-specific instructions and conventions. Do not implement refactors, redesign a selected solution in detail, or generate permanent repository documentation."
---

# Architecture Review

Use this skill to determine which architectural problems in an existing repository are worth addressing and in what order. Review the repository as a system, not as a collection of isolated code smells.

The skill is advisory-only. Its normal durable output is an Architecture Review handoff that can feed focused design, discussion, planning, or delivery work.

## Operating boundaries

- Do not edit, refactor, or create production code.
- Creating or updating an Architecture Review handoff does not authorize implementation.
- Do not redesign a selected module or interface in implementation-level detail. Once a candidate is selected, focused design belongs in a separate design workflow.
- Review the scope requested by the user. Do not claim repository-wide coverage when only a subset was inspected.
- Discover and respect applicable repository instructions, architecture docs, conventions, build/test configuration, and existing constraints. Do not assume specific filenames, directories, frameworks, or tooling.
- Treat repository rules as evidence about intended architecture, not as universal engineering principles.
- Prefer evidence from code, dependencies, tests, configuration, CI, documentation, and relevant history over aesthetic preference.
- Do not recommend refactoring merely because a design is imperfect. Recommend work only when the expected engineering benefit justifies the cost and migration risk.
- Optimize for maintainability and clarity for humans and coding agents without adding ceremony solely for AI.

Read `references/architecture-review-criteria.md` before evaluating findings or ranking refactoring candidates.

## Review model

Classify material observations into three categories:

- **Architecture problem** — a structural issue in responsibilities, boundaries, dependencies, state, effects, or abstractions that makes the system materially harder or riskier to change.
- **Guardrail gap** — the intended architecture is reasonable, but important invariants are weakly or only manually enforced.
- **Documentation gap** — the architecture or engineering contract may be sound, but important knowledge is missing, stale, contradictory, or difficult to discover.

Do not turn a guardrail or documentation gap into a redesign recommendation unless the underlying architecture is itself problematic.

## Workflow

### 1. Establish scope and repository contract

Identify the requested review scope and discover the repository's own sources of truth. Inspect what is relevant, such as:

- repository or scoped agent instructions;
- README, CONTRIBUTING, architecture/design docs, ADRs, or equivalent records;
- project/build/dependency configuration;
- CI and verification configuration;
- tests and test organization;
- source/package/module structure;
- ownership or boundary conventions;
- relevant version-control history when it materially helps identify repeated change hotspots or architectural drift.

Do not require any particular artifact to exist. Record important missing sources as possible documentation or guardrail gaps rather than inventing them.

### 2. Build a working architectural map

Create a concise internal model of the reviewed scope:

- major responsibilities and components;
- dependency direction and high-value boundaries;
- external-system seams and side-effect ownership;
- important state/lifecycle ownership;
- major execution or data flows;
- primary verification boundaries;
- documented architectural invariants.

Do not document every directory or class. Capture only what is necessary to reason about architecture.

### 3. Identify evidence-backed hotspots

Look for areas where architecture creates real change or verification cost. Useful evidence includes:

- one behavior requiring coordinated edits across many unrelated places;
- high or unstable fan-in/fan-out;
- circular, inverted, or unclear dependencies;
- responsibilities leaking across intended boundaries;
- duplicated policy or orchestration;
- hidden global/shared state or lifecycle coupling;
- side effects mixed into unrelated decision logic;
- pass-through layers that add indirection without hiding knowledge;
- inheritance or abstraction structures with disproportionate conceptual cost;
- code that cannot be verified without broad environment setup despite containing meaningful isolated behavior;
- tests tightly coupled to implementation structure rather than stable behavior;
- documented rules repeatedly violated or unenforced;
- architecture knowledge that exists only implicitly or has drifted from documentation;
- areas where safe modification requires understanding an unnecessarily large portion of the repository.

Do not infer severity from file size, class count, naming style, or abstraction count alone.

### 4. Evaluate findings

Use `references/architecture-review-criteria.md` as heuristics, not a scoring formula.

For every material finding:

1. State the observed evidence.
2. Explain the architectural concern.
3. Describe the practical consequence: change cost, regression risk, verification difficulty, cognitive load, or operational risk.
4. Classify it as an architecture problem, guardrail gap, or documentation gap.
5. Assign confidence based on the strength and completeness of evidence.

Do not promote speculative concerns to findings. Mark uncertain observations explicitly or omit them.

### 5. Form refactoring candidates

Create a refactoring candidate only when resolving one or more architecture problems is likely to produce meaningful engineering value.

A candidate should identify:

- the problem boundary;
- the expected payoff;
- the approximate affected scope;
- major migration or compatibility risks;
- important dependencies or prerequisites;
- whether focused design is required before planning implementation.

Keep recommendations directional. Do not prematurely prescribe detailed class structures, APIs, or implementation steps.

Guardrail gaps and documentation gaps may become their own improvement candidates when they are valuable, but label them clearly rather than presenting them as architectural redesigns.

### 6. Prioritize by expected value

Rank candidates qualitatively using factors such as:

- impact on current development or reliability;
- frequency with which the affected area changes;
- expected reduction in blast radius or cognitive load;
- improvement in verification strength;
- reduction of real accidental complexity;
- migration risk;
- implementation cost and disruption;
- confidence in the diagnosis.

Use **High / Medium / Low** priority and **High / Medium / Low** confidence. Explain the judgment briefly. Do not manufacture numeric architecture scores.

Prefer a small set of high-value candidates over a long backlog of cosmetic improvements.

### 7. Record what should not be changed

Identify notable areas that were considered but should intentionally be left alone when doing so prevents unnecessary work.

Examples include:

- intentionally thin adapters at external boundaries;
- stable legacy areas with high migration risk and little active change;
- duplication that is cheaper and clearer than a shared abstraction;
- local imperfections whose refactoring would not improve meaningful outcomes.

This section is part of the review discipline, not an obligation to defend every existing design.

### 8. Produce the Architecture Review handoff

For a substantive review, read `references/architecture-review-template.md` and use it as the stable handoff contract.

The artifact should preserve conclusions and evidence needed by a downstream human or agent without requiring the original conversation.

When repository context is available:

- prefer an existing convention for temporary task, design, or review artifacts;
- do not assume a particular directory or filename;
- do not create a new permanent documentation structure solely for the review.

If no persistence convention exists, return the Architecture Review in the template structure so the caller can persist or pass it downstream.

The Architecture Review is a working analysis artifact. It is not authoritative repository documentation and does not prove that any recommendation was implemented.

## Completion behavior

End with a short decision-oriented summary:

- the overall architectural health of the reviewed scope;
- the highest-value candidate(s), if any;
- important guardrail/documentation gaps;
- whether focused design should precede delivery work;
- areas intentionally not recommended for change.

If the architecture is already appropriate for the observed needs, say so. A valid review may conclude that no substantial refactoring is justified.

## What not to do

- Do not produce a generic catalogue of architecture smells without repository evidence.
- Do not equate large modules with bad design or small modules with good design.
- Do not treat every thin wrapper or adapter as a refactoring target.
- Do not recommend interfaces, dependency injection, ports, factories, layers, DDD, clean architecture, or other named patterns by default.
- Do not convert documentation drift into code redesign when documentation synchronization is sufficient.
- Do not convert missing enforcement into code redesign when an executable guardrail is sufficient.
- Do not rank low-value cleanup above recurring high-cost architectural friction.
- Do not create a refactoring backlog merely to make the repository look more structured or AI-friendly.
- Do not claim exhaustive review coverage when evidence or access was limited.
- Do not invent repository-specific artifact locations or permanent documentation conventions.
