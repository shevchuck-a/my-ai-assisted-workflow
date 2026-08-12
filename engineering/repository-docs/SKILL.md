---
name: repository-docs
description: "Create, audit, or synchronize repository documentation for humans and coding agents. Use when documentation must be bootstrapped for a new repository, brought back in sync after code or architecture changes, reviewed for drift or duplication, or optimized into separate human-facing docs and AI-facing context/instructions. Adapts to the repository's existing documentation conventions instead of assuming specific paths such as docs/, ai/, or AGENTS.md."
---

# Repository Docs

Maintain the repository's durable knowledge system for both humans and coding agents.

This skill may create or edit documentation and agent-context files. It does not modify production code, tests, build logic, CI, or architecture merely to make documentation consistent.

## Operating boundaries

- Treat repository reality and documented intent as separate evidence sources; do not silently rewrite one to match the other when they conflict.
- Preserve coherent existing documentation conventions. Do not impose `docs/`, `ai/`, `AGENTS.md`, ADRs, or any other fixed structure when the repository uses a different pattern.
- Prefer the smallest sufficient documentation system. Do not create documents merely because a template or taxonomy exists.
- Keep one authoritative home for each durable fact or policy where practical. Other surfaces may summarize or point to it.
- Treat AI-facing context as an optimized projection of repository knowledge, not an independent competing source of truth.
- Treat agent operating instructions separately from explanatory repository knowledge.
- Do not promote temporary task discussions, design recommendations, or review artifacts into permanent truth without verifying the implemented repository state.
- Surface implementation, guardrail, or policy gaps that documentation cannot safely resolve instead of changing non-documentation files.

## Resolve the documentation mode

Before repository-wide documentation work, establish both the intended **operation** and **audience**.

### Operation

- **BOOTSTRAP** — establish missing durable repository documentation.
- **SYNC** — bring existing documentation into alignment with the current repository and intended policies.
- **AUDIT** — evaluate documentation coverage, consistency, ownership, and drift without modifying files.

### Audience

- **HUMAN** — documentation primarily for people learning, maintaining, or contributing to the repository.
- **AI** — context and instructions optimized for coding agents, context efficiency, and repository navigation.
- **BOTH** — maintain both surfaces and their consistency.

Do not infer a materially ambiguous operation or audience. If either is unclear from the user's request, ask the user to resolve it before continuing.

Do not ask the user to repeat information already explicit in the request.

Ask at most a small number of additional questions, and only when the answer materially changes the work. Typical ambiguities are:

- whole repository versus a specific subsystem or documentation surface;
- whether documented architectural intent or conflicting current implementation is authoritative;
- which AI-facing surface is intended when multiple incompatible conventions exist and repository evidence cannot resolve ownership.

Do not ask questions whose answers can reasonably be discovered from the repository, including existing documentation paths, technologies, build or verification commands, repository instructions, dependency files, or source layout.

## Reference material

Read `references/documentation-principles.md` when deciding ownership, source-of-truth relationships, human-versus-AI presentation, duplication, or drift.

Read `references/documentation-patterns.md` when deciding which documentation surfaces are justified and what belongs in each one.

## Workflow

### 1. Discover the repository contract

Inspect the repository before proposing documentation changes.

Look for relevant evidence such as:

- root and scoped repository instructions;
- README and contributor guidance;
- existing human-facing documentation;
- AI-facing context or instruction directories;
- architecture and decision records;
- source layout and dependency definitions;
- tests and verification configuration;
- build scripts and CI configuration;
- existing terminology and naming conventions;
- recent design or migration artifacts when relevant to the requested scope.

Do not assume specific filenames.

### 2. Build a factual repository model

Understand only what is needed for the requested documentation scope.

Identify relevant:

- repository purpose and primary entry points;
- major responsibilities and boundaries;
- dependency direction and important seams;
- external-system boundaries and side-effect ownership;
- important execution or data flows;
- testing and verification strategy;
- development and validation commands;
- durable engineering rules and intended constraints;
- historical decisions that explain non-obvious current structure.

Prefer direct repository evidence over inference. Mark uncertainty explicitly.

### 3. Map the documentation system

Classify existing durable knowledge by role rather than filename.

Distinguish at least:

- **human-facing explanatory documentation**;
- **AI-facing repository context**;
- **agent operating instructions**;
- **decision/history records**;
- **executable sources of truth** such as code, configuration, tests, scripts, and CI;
- **temporary work artifacts** that should not become permanent truth automatically.

Identify which surface owns each important fact or policy.

### 4. Detect gaps, drift, and duplication

Look for:

- missing information required to understand, modify, or verify the repository;
- stale paths, commands, module names, or dependency descriptions;
- human docs and AI context that disagree;
- agent instructions that point to obsolete files or rules;
- the same fact independently maintained in multiple places;
- implementation that appears to violate documented architectural intent;
- documentation that explains obvious implementation detail while omitting important boundaries or invariants;
- AI context that is too verbose, too vague, or forces loading large human docs for routine work;
- undocumented repository-specific testing or verification expectations.

Do not classify every imperfection as a documentation problem. Some discrepancies are architecture, implementation, or guardrail issues that must be surfaced instead.

### 5. Plan the minimum sufficient change

Before editing, decide which documentation roles actually need change.

Prefer, in order:

1. update an existing authoritative document;
2. remove or replace stale duplication;
3. add a pointer or compact derived projection;
4. create a new durable document only when no coherent existing home exists.

For **BOOTSTRAP**, establish the smallest structure that makes the repository understandable, modifiable, and verifiable.

For **SYNC**, preserve coherent existing organization and change only what is needed to restore alignment.

For **AUDIT**, do not modify files; report evidence-backed gaps, conflicts, and recommended ownership changes.

### 6. Maintain human-facing documentation

When HUMAN or BOTH is selected, optimize for explanation and understanding.

Human-facing documentation may include, when justified:

- repository overview and navigation;
- architecture responsibilities, boundaries, and important flows;
- testing strategy and verification expectations;
- development workflow;
- non-obvious decisions and rationale;
- contributor guidance.

Document intent, invariants, and relationships that are not obvious from reading one source file. Avoid large inventories of files or classes that the repository itself already expresses clearly.

### 7. Maintain AI-facing context and instructions

When AI or BOTH is selected, optimize for context efficiency and reliable navigation.

AI-facing context should favor:

- concise repository maps;
- explicit boundaries and dependency rules;
- actionable testing and verification expectations;
- stable terminology;
- pointers to relevant code or deeper human documentation;
- scoped loading rather than large all-purpose context dumps;
- high-value facts that reduce rediscovery on routine tasks.

Keep explanatory AI context distinct from operating instructions.

Agent operating instructions should focus on **how an agent should work in the relevant scope**: what to inspect, which rules apply, what to verify, and where deeper context lives.

Do not duplicate long human-oriented explanations into AI context. Do not reduce AI context to useless pointers that force loading large documents for every task.

### 8. Reconcile dual-audience knowledge

When BOTH is selected, ensure human and AI surfaces express compatible truth while serving different consumption patterns.

A healthy relationship is typically:

```text
repository reality + intended policy
              ↓
    authoritative durable knowledge
          ↙               ↘
human explanation     AI projection
                          ↓
                 agent instructions
```

The exact files may differ by repository.

If the same durable fact appears on multiple surfaces, make ownership clear. Prefer summaries and links over independently maintained copies.

### 9. Verify documentation against the repository

Before completion, cross-check changed or audited documentation against repository evidence.

Verify as applicable:

- referenced paths and modules exist;
- commands match actual scripts/configuration;
- links and pointers are valid;
- dependency direction matches code or is clearly labeled as intended policy;
- testing guidance matches the available verification mechanisms;
- AI instructions point to current context and do not reference obsolete files;
- terminology is consistent across relevant surfaces;
- duplicate rules have an identifiable authoritative owner;
- temporary design or task artifacts were not mistaken for implemented truth.

If a conflict cannot be resolved from repository evidence and user intent, ask a targeted question rather than guessing.

### 10. Report the result

For BOOTSTRAP or SYNC, summarize:

- documentation created;
- documentation updated or removed;
- important ownership decisions;
- unresolved discrepancies or non-documentation follow-up work.

For AUDIT, summarize:

- evidence-backed documentation gaps;
- drift or conflicts;
- duplication/ownership problems;
- recommended changes, ordered by value.

Do not create a separate persistent documentation report unless the repository already uses such an artifact or the user explicitly requests one.

## What not to do

- Do not create a fixed documentation tree merely because the repository lacks one.
- Do not create both human and AI versions of every document by default.
- Do not duplicate commands, rules, architecture descriptions, or policies across surfaces without a clear ownership reason.
- Do not treat current code as automatically correct when it conflicts with explicitly documented architectural intent.
- Do not treat documentation as automatically correct when repository evidence clearly shows it is stale.
- Do not convert an architecture review or design recommendation directly into permanent documentation without verifying the implemented state.
- Do not modify production code, tests, build configuration, CI, or architecture to resolve documentation inconsistencies.
- Do not add verbose AI context that increases token use without improving task navigation or decision quality.
- Do not ask the user questions that repository discovery can answer.
