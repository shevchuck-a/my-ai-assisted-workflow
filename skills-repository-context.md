# Skills Repository Context

## Purpose

This repository contains reusable skills for an AI-assisted software development workflow.

The skills are intentionally split into two groups:

1. **Delivery Workflow skills** — used frequently during day-to-day development work.
2. **Engineering skills** — used less frequently for architecture, design, repository setup, refactoring, and documentation maintenance.

The repository exists to make these skills versioned, reviewable, testable, and evolvable as a coherent system rather than as unrelated prompt files.

The skills should remain as repository-agnostic as practical. They define **how an agent should work**, while each target repository remains responsible for its own architecture, conventions, testing policy, verification commands, and local instructions.

A useful mental model is:

```text
Reusable skills
    HOW to work

Repository instructions and docs
    HOW THIS repository is designed

Executable checks
    WHAT MUST remain true

Task artifacts
    WHAT was decided for this change

Code
    CURRENT implementation
```

---

# Design Principles

## 1. Skills define workflows, repositories define local rules

Skills must not hard-code assumptions such as:

- a specific directory structure;
- a particular programming language;
- a specific test framework;
- a fixed CI provider;
- a required `AGENTS.md` layout;
- repository-specific architectural rules.

Instead, skills should discover and respect the target repository's own sources of truth, such as:

- `AGENTS.md` and scoped agent instructions;
- README / CONTRIBUTING files;
- architecture and testing documentation;
- code structure and existing patterns;
- build configuration;
- tests;
- CI configuration;
- repository-specific scripts and verification commands.

The general rule is:

> The skill adapts to the repository; the repository does not adapt to the skill.

## 2. Repository discovery is part of the workflow

A reusable skill should determine what is relevant in the current repository before acting.

Typical discovery may include:

```text
applicable instructions
language and frameworks
affected components
architecture boundaries
existing implementation patterns
testing strategy
available verification commands
relevant CI requirements
```

This repository context should be treated as dynamic input, not encoded permanently inside a reusable skill.

## 3. Prefer executable guardrails over prose-only rules

Documentation and agent instructions are important, but critical invariants should be mechanically verifiable when practical.

Examples:

```text
behavioral / regression tests
type checking
linting
dependency checks
architecture tests
build validation
CI
```

A useful rule:

> Prose explains intent; executable tooling enforces important invariants.

## 4. Progressive disclosure

Skills should remain compact and load detailed references only when needed.

A typical skill layout is:

```text
skill-name/
├── SKILL.md
├── agents/
│   └── openai.yaml
└── references/
    └── ...
```

`SKILL.md` acts as the control plane:

- when to use the skill;
- scope and boundaries;
- workflow;
- output policy.

`references/**` contains deeper methodology, templates, criteria, or patterns that are loaded only for relevant steps.

## 5. Stable artifacts between workflows

When reasoning must survive the current conversation or be consumed by another fresh context, a skill may produce a structured handoff artifact.

Artifacts are not automatically permanent repository documentation.

Examples:

```text
Architecture Review
Design Recommendation
Task Discussion artifacts
Tickets
```

The purpose of these artifacts is to reduce dependence on long chat history and allow downstream agents to operate from a compact, explicit contract.

---

# Skill Groups

# Delivery Workflow

Delivery Workflow skills are the default tools for normal development work.

They operate on concrete tasks and changes rather than on repository-wide engineering strategy.

Current skills:

```text
task-discussion
to-tickets
implement-ticket
```

These skills form the main delivery pipeline:

```text
requirement / work item
        ↓
task-discussion
        ↓
task artifact
        ↓
to-tickets
        ↓
implementation tickets
        ↓
implement-ticket
```

Not every task needs every step. Small tasks may use only part of the workflow.

---

## task-discussion

### Purpose

Turn an initial requirement, work item, bug, or change request into a sufficiently clear implementation discussion.

The skill is responsible for understanding:

- the intent of the task;
- repository context relevant to the task;
- constraints;
- behavioral expectations;
- risks;
- important implementation decisions;
- verification implications.

It should inspect applicable repository instructions and other relevant sources before making technical decisions.

### Important boundary

`task-discussion` may discuss implementation strategy, but it should not duplicate repository-wide rules inside its artifact.

The target repository remains the source of truth for:

```text
architecture rules
testing conventions
style
verification commands
local agent instructions
```

### Example

```text
User has a work item:
"Support comparison of results from a second source."

task-discussion:
- understands current comparison flow;
- finds relevant repository instructions;
- identifies affected modules;
- clarifies behavior and edge cases;
- records implementation decisions;
- defines what must be verified.
```

---

## to-tickets

### Purpose

Convert an approved discussion or sufficiently defined change into small, independently understandable implementation tickets.

Each ticket should carry task-specific information necessary for execution without copying the whole repository context.

Typical ticket information:

```text
goal
scope
acceptance criteria
important task decisions
dependencies
verification expectations
```

### Important boundary

Repository rules should normally be rediscovered by the implementation agent rather than copied into every ticket.

Tickets describe **what this change requires**.

The repository describes **how work in this repository must be performed**.

### Example

```text
Task Discussion:
refactor result comparison and introduce regression coverage.

to-tickets might produce:

Ticket 1:
add characterization/regression coverage

Ticket 2:
extract comparison behavior behind the selected design

Ticket 3:
migrate callers

Ticket 4:
remove obsolete path
```

---

## implement-ticket

### Purpose

Implement one defined ticket safely within the target repository.

A typical workflow is:

```text
read ticket
    ↓
discover applicable repository instructions
    ↓
inspect relevant code and existing patterns
    ↓
determine appropriate verification
    ↓
implement the smallest coherent change
    ↓
run relevant checks
    ↓
self-review
```

### Important boundary

`implement-ticket` must independently rediscover applicable repository instructions.

It must not assume that a previous discussion captured all current or scoped rules.

### Engineering expectations

The implementation skill should generally:

- avoid unrelated changes;
- preserve existing behavior unless the task changes it;
- inspect existing patterns before introducing abstractions;
- prefer the smallest coherent change;
- identify regression risks;
- verify changed behavior independently where practical;
- prefer regression coverage for bug fixes;
- never claim checks were run when they were not.

---

# Engineering Skills

Engineering skills are used less frequently.

They help shape the repository itself rather than deliver ordinary task changes.

Current skills:

```text
codebase-design
architecture-review
repository-docs
```

The three skills answer different questions:

```text
Architecture Review
    WHAT is structurally worth improving?

Codebase Design
    HOW should a selected area be designed?

Repository Docs
    HOW should the repository explain its actual
    architecture, rules, and AI context?
```

---

## ENG · Architecture Review

Internal name:

```text
architecture-review
```

### Purpose

Review an existing repository at system level and identify architecture problems, guardrail gaps, documentation gaps, and worthwhile improvement candidates.

Its main question is:

> What is structurally wrong or unnecessarily expensive in this repository, and what is actually worth improving?

### Scope

This is repository-level analysis.

It should build a high-level model of:

```text
major responsibilities
modules/packages
dependency direction
external boundaries
state ownership
important flows
testing boundaries
```

It should then evaluate evidence-backed hotspots.

Example signals:

```text
poor change locality
unclear responsibilities
excessive coupling
boundary leakage
circular dependencies
pass-through abstractions
hidden side effects
global mutable state
fragile testability
implementation-coupled tests
missing architectural enforcement
documentation drift
poor AI navigability
```

### Evidence-first rule

A finding should follow:

```text
concrete evidence
    ↓
architectural consequence
    ↓
classification
    ↓
expected payoff
    ↓
candidate or no candidate
```

The skill should not generate refactoring opportunities merely because something could look cleaner.

### Finding categories

The review distinguishes at least:

```text
Architecture problem
    structural issue that may require redesign/refactoring

Guardrail gap
    intended structure is reasonable but enforcement is weak

Documentation gap
    architecture may be correct but difficult to discover or documented incorrectly
```

### Output

Architecture Review normally produces a persistent handoff artifact because repository-wide analysis is expensive to reconstruct.

Typical structure:

```text
Scope
Repository Model
Executive Summary
Findings
Prioritized Improvement Candidates
Cross-Cutting Guardrail Gaps
Documentation Gaps
Areas Intentionally Left Alone
Open Questions
```

`Areas Intentionally Left Alone` is important: it explicitly records visible imperfections that are not worth changing now.

### Next step

For a selected architecture problem, the review may recommend:

```text
focused design before delivery planning
```

This means:

> The problem and expected payoff are understood, but the target design still needs to be defined.

That candidate can then be passed to `codebase-design`.

---

## ENG · Codebase Design

Internal name:

```text
codebase-design
```

### Purpose

Design or evaluate a focused architecture area, module, abstraction, interface, seam, or dependency boundary.

Its main question is:

> Given this concrete design problem, what should the target design look like?

This is not a repository-wide architecture audit.

### Design lens

The skill uses concepts such as:

```text
module
interface
seam
adapter
change locality
module depth
dependency visibility
behavioral contracts
testability
side-effect isolation
```

Important heuristics include:

- prefer deep modules where real complexity exists;
- keep important interfaces small and behavioral;
- favor locality of change;
- create seams where behavior genuinely varies;
- do not create interfaces/factories only for hypothetical future variation;
- thin adapters around external systems can be good design;
- keep external effects explicit and localized;
- prefer composition over chains of pass-through abstractions;
- optimize navigability without adding unnecessary ceremony;
- use behavioral tests as stable contract surfaces where appropriate.

### Advisory-only boundary

`codebase-design` does not implement production code.

It provides design reasoning and recommendations.

### Output modes

For small design questions:

```text
analysis
    ↓
recommendation in chat
```

For substantial decisions that need to survive the conversation:

```text
analysis
    ↓
Design Recommendation
```

A Design Recommendation is a stable handoff, not an implementation plan and not permanent repository documentation.

Typical stable sections:

```text
Problem
Design Drivers
Recommendation
Proposed Boundaries
Behavioral Contract
Trade-offs
Verification Implications
```

Optional sections may include:

```text
Current Shape
Alternatives Considered
Open Questions
```

### Relationship to Architecture Review

Example:

```text
Architecture Review

Problem:
comparison behavior is mixed with I/O and reporting.

Direction:
separate comparison behavior from external effects.

        ↓

Codebase Design

Target design:
- define comparison responsibility;
- establish stable behavioral interface;
- identify adapters/seams;
- define dependency direction;
- define behavioral contract;
- explain trade-offs and verification implications.
```

The Design Recommendation can then enter the normal delivery workflow.

---

## ENG · Repository Docs

Internal name:

```text
repository-docs
```

### Purpose

Create, audit, or synchronize the repository knowledge system.

Unlike the two previous engineering skills, this skill is write-capable for documentation files.

It does not modify production code, tests, build logic, or CI merely to resolve a documentation problem.

Its main question is:

> What documentation/context should exist for this repository, and how should it reflect the actual architecture and intended engineering rules?

---

# Repository Documentation Model

The repository may serve different audiences.

A useful model is:

```text
Repository knowledge
│
├── docs/**
│   human-oriented documentation
│
├── ai/**
│   AI-oriented context
│
└── AGENTS.md / scoped instructions
    agent operating instructions
```

These surfaces have different purposes.

## Human-facing documentation

`docs/**` is optimized for understanding.

It may contain:

```text
architecture explanations
testing strategy
development workflow
important data/control flows
design rationale
decision records
contributor guidance
```

Human documentation may contain narrative explanation, context, diagrams, rationale, and examples.

## AI-facing context

`ai/**` is optimized for:

```text
token efficiency
fast navigation
explicit constraints
stable terminology
dependency clarity
actionable facts
progressive context loading
```

AI documentation is not simply a shorter copy of human documentation.

It is an agent-optimized projection of repository knowledge.

Example:

```text
Human architecture doc:
explains why layers exist, trade-offs, diagrams, examples.

AI architecture context:
lists dependency direction, responsibilities, constraints,
relevant paths, and pointers to deeper sources.
```

## Agent operating instructions

`AGENTS.md` and scoped equivalents answer a different question:

```text
HOW SHOULD THE AGENT OPERATE HERE?
```

For example:

```text
which context to read
scope-specific conventions
verification expectations
operational constraints
```

A useful separation is:

```text
AGENTS.md
    HOW TO OPERATE

ai/**
    WHAT THE AGENT NEEDS TO KNOW

docs/**
    WHAT A HUMAN NEEDS TO UNDERSTAND
```

---

# Documentation Ownership

Human and AI documentation may present the same underlying truth differently, but they should not independently own conflicting versions of the same truth.

Conceptually:

```text
repository reality
+
canonical engineering intent
        ↓
human documentation
        ↓
AI-optimized projection
```

This is not a strict rule that `docs/**` always owns every fact.

Ownership depends on the fact.

Examples:

```text
current dependency graph
    → code

build/test commands
    → build config / scripts

architectural intent
    → architecture documentation

testing policy
    → testing documentation

agent navigation hints
    → ai/**

agent workflow rules
    → AGENTS.md

historical rationale
    → ADR / decision records
```

The documentation skill should determine authoritative ownership before duplicating information.

A strong principle is:

> One authoritative home per fact.

---

# Repository Docs Modes

Before starting substantial documentation work, `repository-docs` resolves two independent dimensions.

## Operation

```text
BOOTSTRAP
    create missing documentation/context

SYNC
    update existing documentation/context to current repository state

AUDIT
    analyze coverage, consistency, duplication, and drift without modifying files
```

## Audience

```text
HUMAN
    human-facing documentation

AI
    AI-oriented context and agent-facing knowledge surfaces

BOTH
    both documentation systems and their consistency
```

Examples:

```text
BOOTSTRAP + BOTH
    set up documentation for a new repository

SYNC + AI
    refresh AI context after a refactoring

AUDIT + BOTH
    inspect all documentation surfaces for drift
```

---

# Clarification Policy

The skill should not guess a materially ambiguous mode.

If operation or audience is unclear, it asks the user before beginning repository-wide work.

However, it must not ask for information already explicit in the user's request.

It may ask at most a small number of additional questions when the answer materially changes the work.

Useful clarification topics:

```text
whole repository vs specific scope

intended documented architecture vs conflicting implementation

which AI documentation surface is authoritative when several
incompatible conventions exist
```

It should not ask questions whose answers can reasonably be discovered from the repository, such as:

```text
where docs are located
whether AGENTS.md exists
technology stack
build commands
test commands
repository structure
```

---

# Minimum Sufficient Documentation

The documentation skill should not create documentation merely because a common template contains a file.

It should create the smallest documentation system that makes the repository understandable, modifiable, and verifiable.

Possible documentation roles include:

```text
repository overview
architecture documentation
testing strategy
development guide
decision records
AI architecture context
AI testing context
repository map
root agent instructions
scoped agent instructions
documentation indexes
```

None are universally mandatory.

A small repository may need only:

```text
README.md
docs/architecture.md
```

A larger one may justify:

```text
README.md

docs/
├── architecture/
├── testing/
├── development/
└── decisions/

ai/
├── repository-map.md
├── architecture.md
└── testing.md

AGENTS.md
```

Existing coherent conventions should normally be preserved rather than replaced with a preferred template.

---

# Documentation Drift

A key responsibility of `repository-docs` is distinguishing documentation drift from implementation drift.

Example:

```text
documented intent:
core must not depend on UI

actual code:
core imports UI
```

The skill must not automatically rewrite the documentation to match the code.

The discrepancy could mean:

```text
documentation is stale
implementation violates intended architecture
architecture decision changed but was not documented
```

If repository evidence cannot resolve the conflict, the discrepancy should be surfaced rather than silently normalized.

---

# Typical End-to-End Workflows

## Normal development task

```text
Work item
    ↓
task-discussion
    ↓
to-tickets
    ↓
implement-ticket
```

For a small task:

```text
Work item
    ↓
implement-ticket
```

if the task is already sufficiently defined.

---

## Significant architecture refactoring

```text
architecture-review
        ↓
Architecture Review
        ↓
select high-value candidate
        ↓
codebase-design
        ↓
Design Recommendation
        ↓
task-discussion
        ↓
to-tickets
        ↓
implement-ticket × N
        ↓
repository-docs
        ↓
documentation/context synchronized with actual implementation
```

The key separation is:

```text
Architecture Review
    identifies WHAT is worth improving

Codebase Design
    defines WHAT THE TARGET DESIGN should be

Task Discussion / Tickets
    define HOW TO GET THERE safely

Implementation
    changes the repository

Repository Docs
    updates permanent knowledge to the resulting reality
```

---

## Guardrail gap discovered during architecture review

```text
architecture-review
        ↓
Finding:
dependency direction is documented but not enforced
        ↓
delivery workflow
        ↓
implement mechanical dependency verification
        ↓
repository-docs if documentation needs synchronization
```

No focused redesign is required if the architecture itself is already appropriate.

---

## Documentation gap discovered during architecture review

```text
architecture-review
        ↓
Finding:
architecture is reasonable but difficult to discover
        ↓
repository-docs
        ↓
BOOTSTRAP/SYNC + HUMAN/AI/BOTH
```

---

## New repository setup

A possible sequence:

```text
initial repository
    ↓
codebase-design
    optional focused design for important boundaries
    ↓
implementation / setup
    ↓
repository-docs
    BOOTSTRAP + BOTH
    ↓
human docs + AI context + agent instructions
```

An architecture review is usually unnecessary for an empty/new repository unless reviewing an imported or already substantial codebase.

---

# Fresh Context and Handoff Artifacts

Not every skill requires a new conversation.

Small local work can continue in the same context.

Fresh context is useful when:

```text
reasoning was long
the next role should independently critique the result
a substantial artifact now captures the final decision
implementation should not inherit unnecessary exploration history
```

Example:

```text
Session A
architecture-review
    ↓
Architecture Review

Session B
codebase-design
reads selected candidate + evidence
    ↓
Design Recommendation

Session C
task-discussion
reads Design Recommendation + repository
    ↓
delivery decisions
```

This is a quality and context-efficiency technique, not a mandatory rule.

The artifact acts as the contract between contexts.

---

# Artifact Roles

## Architecture Review

Repository-level diagnostic handoff.

Answers:

```text
what problems exist?
why do they matter?
which are worth addressing?
what is the approximate improvement direction?
```

It should not fully design the replacement architecture.

## Design Recommendation

Focused design handoff.

Answers:

```text
what should the selected area look like?
what are the boundaries?
what behavior should callers rely on?
what are the trade-offs?
what should downstream implementation verify?
```

It is not an implementation plan.

## Task Discussion artifact

Delivery-oriented decision record.

Answers:

```text
what exactly are we changing?
what task-specific decisions were made?
what risks and constraints matter?
how should delivery be approached?
```

## Tickets

Executable units of delivery.

Answers:

```text
what should this implementation step accomplish?
what are its acceptance criteria?
how will it be verified?
```

## Repository documentation

Permanent repository knowledge.

Answers:

```text
how does the repository actually work now?
what architecture/rules are authoritative?
how should humans and agents understand and modify it?
```

Temporary planning artifacts should not automatically become permanent documentation.

---

# AI-Friendly Repository Expectations

These skills work best when the target repository itself provides good agent ergonomics.

Useful characteristics include:

```text
predictable topology
clear responsibilities
explicit dependency direction
stable module boundaries
small behavioral interfaces
localized side effects
limited hidden/global state
discoverable repository instructions
simple verification entry points
executable architecture constraints
high-signal documentation
AI-optimized context where useful
```

The goal is not to maximize abstraction.

The goal is to make changes local, understandable, and mechanically verifiable.

A particularly useful heuristic:

> The less implementation ownership a human has over generated code, the more important explicit behavioral contracts and independent verification become.

This does not imply unit testing every test-automation class or every adapter.

Testing and verification should remain risk-based and repository-specific.

---

# Maintaining This Skills Repository

This repository should itself favor controlled evolution.

Useful practices:

```text
keep each skill responsibility narrow
avoid repository-specific assumptions
prefer reusable principles over tool-specific commands
use reference files for deep methodology
keep stable artifact contracts explicit
review changes to skill boundaries carefully
avoid duplicated rules across skills
test skills on real repositories before adding more abstractions
```

When a rule is shared conceptually by several skills, prefer a clear common principle over copying large blocks of identical instructions.

However, avoid creating hard runtime dependencies between skills unless the execution environment guarantees them.

Each skill should remain usable independently where practical.

---

# Current Skill Map

```text
Delivery Workflow
├── task-discussion
├── to-tickets
└── implement-ticket

Engineering
├── codebase-design
├── architecture-review
└── repository-docs
```

Suggested UI grouping:

```text
01 ...                    delivery workflow skill
02 ...                    delivery workflow skill
...

ENG · Codebase Design
ENG · Architecture Review
ENG · Repository Docs
```

The `ENG ·` prefix groups engineering skills visually without implying that they form a mandatory numbered sequence.

---

# Core Philosophy

The overall system is designed around a separation of concerns:

```text
Skills
    reusable methodology

Repository
    local engineering contract

Artifacts
    explicit decisions and handoffs

Executable checks
    independent verification

Code
    implementation
```

The system should make AI-assisted development more reliable without turning repository maintenance or prompt engineering into a project of its own.

The objective is not to maximize AI involvement.

The objective is to create a development environment where AI can do useful work with:

```text
clear context
controlled scope
stable contracts
mechanical feedback
minimal unnecessary tokens
```

and where humans retain ownership of:

```text
intent
architecture
behavioral expectations
risk decisions
final verification
```
