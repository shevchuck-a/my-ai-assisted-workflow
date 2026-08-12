# Design Principles

Use these as heuristics, not absolute rules. Repository-specific constraints and the actual problem take precedence.

## 1. Prefer depth where complexity is real

A useful module lets callers achieve meaningful behavior through a small, stable interface while hiding implementation complexity. Depth is valuable when it creates leverage and locality. It is not a target for trivial adapters or declarations.

## 2. Favor locality of change

Design so a coherent behavior change is usually implemented and verified in one obvious place. Repeated orchestration, duplicated policy, or knowledge copied across callers suggests a missing module or misplaced responsibility.

## 3. Put seams where behavior genuinely varies

A seam is justified by real variation, an external boundary, or a meaningful testing/substitution need. Avoid ports, factories, abstract bases, and interfaces created only because another implementation might exist someday.

A production adapter plus a purposeful test substitute can justify a seam when the external dependency is remote, expensive, unstable, or outside process boundaries. Prefer realistic local substitutes when available.

## 4. Keep external effects explicit

UI, network, filesystem, database, device, clock, queue, and similar effects are normal. Concentrate them near explicit seams so core decisions and transformations do not become tangled with mechanism-specific details.

Thin adapters at these seams are acceptable and often desirable.

## 5. Design interfaces around behavior

The interface should express what callers need to accomplish, not expose the internal decomposition of the implementation. Avoid interfaces that merely mirror a chain of internal helper methods.

Include meaningful invariants, errors, ordering, lifecycle rules, and configuration in the mental model of the interface; a type signature alone is not the full contract.

## 6. Prefer composition over pass-through layers

An abstraction should hide knowledge, policy, coordination, or complexity. If deleting it simply shortens the call chain without redistributing complexity, it is likely unnecessary indirection.

Do not confuse a deliberately thin external adapter with a useless pass-through abstraction.

## 7. Use behavioral test surfaces

Stable interfaces make strong test surfaces because tests can describe observable behavior and survive internal refactoring. Prefer these tests for module contracts and regressions.

Keep lower-level tests when they add distinct value: algorithmic edge cases, property/invariant checking, difficult failure modes, or much faster diagnostic feedback.

## 8. Make dependencies visible

Dependencies that materially affect behavior should be visible through construction, parameters, configuration, or an explicit seam. Avoid hidden global state and surprising dependency creation when it harms testability or reasoning.

Do not introduce dependency injection machinery when simple explicit construction is enough.

## 9. Design important interfaces more than once

For interfaces with wide blast radius or high migration cost, compare materially different designs before committing. Explore different responsibility groupings and seam placements rather than cosmetic variations.

Judge alternatives by conceptual load, depth, locality, coupling, testability, side-effect isolation, migration cost, and consistency with the repository.

## 10. Optimize for navigability without creating ceremony

Code should make it easy to answer: where does this behavior live, what depends on it, what must remain true, and how is it verified? Predictable ownership and explicit contracts help both humans and coding agents.

Do not add layers, metadata, documentation, or patterns solely to make a repository look "AI-friendly." Good software boundaries and executable verification remain the priority.
