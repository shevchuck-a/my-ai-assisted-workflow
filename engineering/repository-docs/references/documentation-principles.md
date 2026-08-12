# Documentation Principles

Use these principles when deciding what repository knowledge should exist, where it should live, and how human-facing and AI-facing surfaces should relate.

## Contents

1. Documentation is a knowledge system
2. Assign ownership before duplicating facts
3. Separate actual state from intended policy
4. Optimize human and AI surfaces differently
5. Treat AI context as a derived projection
6. Keep agent instructions operational
7. Prefer progressive disclosure
8. Minimize sufficient documentation
9. Document invariants, not obvious inventories
10. Preserve decision history selectively
11. Detect drift across the whole knowledge chain
12. Prefer executable truth when appropriate
13. Optimize for navigability without ceremony

## 1. Documentation is a knowledge system

Do not think only in terms of files. A repository communicates durable knowledge through code, configuration, tests, CI, human docs, AI context, operating instructions, and decision records.

The goal is a coherent system in which important facts have clear ownership and consumers can find the right level of detail quickly.

## 2. Assign ownership before duplicating facts

When the same fact is useful on several surfaces, first decide where it is authoritative.

Other surfaces should usually summarize, derive, or point to that source rather than independently restating it in full.

Examples:

- build commands may be authoritative in scripts/config and summarized in development docs;
- architectural intent may be authoritative in architecture docs and compressed into AI context;
- agent behavior requirements may be authoritative in repository instructions and referenced by AI context.

Duplication is justified only when the cost of indirection is greater than the maintenance risk and ownership remains explicit.

## 3. Separate actual state from intended policy

Code and configuration describe current implementation. Documentation may also describe intended constraints that current code accidentally violates.

When they conflict, do not automatically rewrite either side.

Classify the discrepancy as one of:

- stale documentation;
- implementation drift from intended architecture;
- unresolved policy change;
- temporary migration state.

Ask only when repository evidence cannot resolve the intended truth.

## 4. Optimize human and AI surfaces differently

Human-facing documentation should optimize for explanation, learning, rationale, and long-term understanding.

AI-facing context should optimize for token efficiency, fast repository navigation, explicit constraints, relevant pointers, and actionable facts.

The two surfaces may describe the same system differently without becoming competing sources of truth.

## 5. Treat AI context as a derived projection

AI-facing documentation should usually be a compact projection of repository reality plus durable intended policy.

It should not invent a separate architecture or testing strategy.

Good AI context often includes:

- compact repository maps;
- dependency and ownership rules;
- task-relevant testing expectations;
- stable terminology;
- pointers to code and deeper docs;
- exceptions that would be expensive for an agent to rediscover.

Avoid both extremes:

- copying long human docs into AI context;
- creating pointer-only AI files that save no context because every task still requires loading the full human document.

## 6. Keep agent instructions operational

Repository instructions such as root or scoped agent files should primarily answer how an agent should operate:

- what instructions apply in this scope;
- what context to inspect;
- what rules are mandatory;
- how changes must be verified;
- where deeper knowledge lives.

Do not use operating instructions as a dumping ground for architecture essays or large domain explanations.

## 7. Prefer progressive disclosure

Make common, high-value context cheap to load and deeper explanations available on demand.

A typical progression might be:

```text
root instructions
      ↓
compact AI context
      ↓
detailed human docs
      ↓
code / tests / decisions
```

Do not require every task to load the entire documentation system.

## 8. Minimum sufficient documentation

Create the smallest durable documentation system that lets contributors and agents:

- understand the repository purpose;
- locate important responsibilities;
- respect architectural boundaries;
- modify code safely;
- run the correct verification;
- understand non-obvious durable decisions.

More documentation is not automatically better. Every durable document creates synchronization cost.

## 9. Document invariants, not obvious inventories

Prefer information that is difficult to reconstruct locally:

- responsibility boundaries;
- dependency direction;
- state ownership;
- important data/control flows;
- architectural invariants;
- testing strategy;
- meaningful exceptions.

Avoid manually maintained lists of every file, class, endpoint, or helper when the repository itself is a better source.

## 10. Preserve decision history selectively

Decision records are useful when future contributors need to know why a durable, non-obvious choice exists or why an attractive alternative was rejected.

Do not create a permanent decision record for routine or easily reversible choices.

Do not confuse temporary design recommendations with historical records of what was actually adopted.

## 11. Detect drift across the whole knowledge chain

A change can leave several surfaces inconsistent:

```text
implementation updated
human docs updated
AI context stale
agent instruction pointer stale
```

Documentation maintenance must consider propagation across relevant surfaces, not just one file.

## 12. Prefer executable truth when appropriate

Some knowledge is better enforced mechanically than repeated in prose.

Examples include:

- formatting and lint rules;
- dependency constraints;
- type contracts;
- build commands;
- test execution;
- architecture checks.

Documentation should explain intent and navigation, while executable tooling proves what can be proven mechanically.

If an important invariant exists only in prose, surface the guardrail gap rather than pretending documentation alone enforces it.

## 13. Optimize for navigability without ceremony

Good documentation helps a reader or agent answer three questions quickly:

1. Where should I look?
2. What must remain true?
3. How do I verify my change?

Do not add layers, indexes, summaries, or taxonomies unless they materially improve those answers.
