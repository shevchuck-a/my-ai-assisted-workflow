# Architecture Review Criteria

Use these criteria as evidence-oriented heuristics, not absolute rules or a numeric scoring system. The repository's actual responsibilities, constraints, and change patterns take precedence.

## Contents

- Change locality
- Responsibility and module depth
- Dependency direction
- Coupling and blast radius
- Boundary integrity
- State and lifecycle ownership
- Side-effect locality
- Testability and behavioral contracts
- Abstraction value
- Consistency and conceptual integrity
- Verification strength and executable guardrails
- Documentation alignment
- AI and human navigability
- Evolution and migration cost
- Candidate value gate

A concern becomes a material finding only when there is concrete evidence that it creates or is likely to create meaningful engineering cost or risk.

## 1. Change locality

Healthy architecture keeps a coherent behavior change concentrated in a small number of obvious places.

Look for:
- repeated coordinated edits across unrelated modules;
- policy or orchestration duplicated among callers;
- one concept represented differently in multiple layers;
- fixes that repeatedly require broad regression work.

Do not penalize changes that naturally span true system boundaries.

## 2. Responsibility and module depth

A useful module owns a coherent responsibility and hides meaningful knowledge, policy, coordination, or complexity behind a manageable interface.

Look for:
- responsibilities scattered among callers;
- modules that expose internal decomposition instead of behavior;
- god modules that own unrelated reasons to change;
- layers that only forward calls without hiding knowledge.

Do not treat intentionally thin UI, network, storage, browser, device, or protocol adapters as problems merely because they are shallow.

## 3. Dependency direction

Dependencies should reflect stable ownership and make important boundaries understandable.

Look for:
- circular dependencies;
- lower-level mechanisms depending on higher-level scenarios without an intentional inversion;
- domain/framework decisions depending directly on volatile external mechanisms;
- packages that act as shared dumping grounds and attract unrelated dependencies.

A dependency is not bad merely because it crosses a directory boundary; judge whether it violates responsibility ownership.

## 4. Coupling and blast radius

Evaluate how much unrelated knowledge a component must carry and how widely its changes propagate.

Look for:
- high fan-out caused by mixed responsibilities;
- high fan-in to unstable interfaces;
- callers that know lifecycle, error, ordering, or protocol details that should be hidden;
- modules whose internal changes routinely force caller changes.

Prefer reducing harmful coupling over minimizing dependency counts mechanically.

## 5. Boundary integrity

Important architectural boundaries should correspond to real differences in responsibility, volatility, ownership, or external systems.

Look for:
- infrastructure details leaking into decision logic;
- test/scenario layers owning reusable framework policy;
- external-system concepts contaminating otherwise independent modules;
- duplicated translation logic across a boundary.

Do not create boundaries solely to match a fashionable architecture diagram.

## 6. State and lifecycle ownership

State should have an understandable owner and lifecycle.

Look for:
- hidden mutable globals;
- state shared across tests/requests/tasks without explicit ownership;
- implicit initialization or teardown dependencies;
- caches or registries whose invalidation rules are distributed;
- components that rely on call ordering that is not part of an explicit contract.

Some global state is legitimate; the concern is hidden ownership and surprising coupling.

## 7. Side-effect locality

UI, network, filesystem, database, device, clock, queue, and other effects should be explicit enough that decision logic and verification remain understandable.

Look for:
- side effects occurring deep inside unrelated helpers;
- business/framework decisions inseparable from external mechanisms;
- repeated protocol handling across callers;
- failure behavior that depends on hidden I/O.

Do not require pure functions for inherently effectful responsibilities. Prefer clear seams and ownership.

## 8. Testability and behavioral contracts

Architecture should make important behavior verifiable at stable, meaningful boundaries.

Look for:
- meaningful logic testable only through a full environment because effects and decisions are inseparable;
- tests that must mirror internal call chains or private state;
- regressions with no stable place to express the violated behavior;
- complex algorithms or invariants lacking cheap focused verification.

Do not judge testability by unit-test count or coverage percentage alone.

## 9. Abstraction value

Abstractions should reduce distributed knowledge or make real variation manageable.

Look for:
- interface/implementation pairs with no meaningful variation or hidden complexity;
- factories, managers, providers, base classes, or wrappers that only add indirection;
- inheritance used mainly for code sharing despite divergent responsibilities;
- abstractions whose removal would reduce complexity without redistributing it elsewhere.

Do not remove an abstraction that intentionally protects an external seam or stable contract merely because it is thin.

## 10. Consistency and conceptual integrity

Similar concepts should usually be modeled and verified consistently unless differences are intentional.

Look for:
- multiple competing patterns for the same responsibility;
- naming or lifecycle rules that imply different mental models;
- duplicated concepts with subtly divergent semantics;
- new architecture layered on top of old architecture without a clear boundary or migration path.

Do not pursue cosmetic uniformity when different contexts genuinely need different models.

## 11. Verification strength and executable guardrails

Important architectural invariants are more reliable when they can be mechanically checked.

Look for:
- dependency rules documented but easy to violate silently;
- recurring review comments about the same structural mistake;
- architecture expectations enforced only by tribal knowledge;
- CI that cannot detect important forbidden dependencies or contract regressions.

Classify this as a guardrail gap when the underlying architecture is sound. Prefer the smallest effective executable check over more prose.

## 12. Documentation alignment

Repository documentation should make important architecture and engineering constraints discoverable without competing sources of truth.

Look for:
- architecture docs that contradict code;
- important boundaries or test strategy existing only in chat/history;
- multiple documents describing the same rule differently;
- outdated diagrams or setup instructions that mislead maintainers;
- critical design decisions with no durable rationale when that rationale affects future changes.

Classify this as a documentation gap unless the mismatch reveals a deeper architectural problem.

## 13. AI and human navigability

A maintainer should be able to answer where behavior lives, what it depends on, what must remain true, and how to verify a change without loading an unnecessarily large portion of the repository.

Look for:
- behavior ownership that is difficult to locate;
- convention-heavy magic requiring broad implicit context;
- duplicated sources of truth;
- deep indirection with little information hiding;
- important commands or constraints that require rediscovery every task.

Do not add metadata, layers, files, or abstractions solely for agent convenience. Prefer improvements that also benefit human maintainability.

## 14. Evolution and migration cost

Architecture quality includes the cost of changing the architecture itself.

Look for:
- high-value boundaries that can be improved incrementally;
- refactors requiring synchronized changes across many consumers;
- compatibility obligations that make a theoretically cleaner design impractical;
- stable areas where migration risk exceeds expected benefit.

A real smell with poor return on investment may belong in "Areas Intentionally Left Alone" rather than the refactoring backlog.

## Candidate value gate

Promote a finding to a refactoring candidate only when the expected benefit is concrete enough to justify change.

Consider:
- current impact;
- recurrence/frequency;
- future blast-radius reduction;
- verification improvement;
- accidental-complexity reduction;
- migration risk;
- implementation cost;
- confidence in the evidence.

Use qualitative judgment. Do not calculate synthetic architecture scores.
