# Documentation Patterns

Use these patterns conditionally. They describe roles that may be useful; they are not a required repository structure.

## Contents

1. Repository overview
2. Human architecture documentation
3. AI architecture context
4. Human testing guide
5. AI testing context
6. Development guide
7. Repository map
8. Decision record
9. Root agent instructions
10. Scoped agent instructions
11. Documentation indexes
12. When not to create a new document

## 1. Repository overview

Useful when a newcomer needs a stable entry point.

Typical content:

- what the repository is for;
- major capabilities;
- quick start or pointer to development setup;
- high-level navigation to architecture, testing, and contribution docs.

Avoid turning the overview into a complete architecture or operations manual.

## 2. Human architecture documentation

Useful when the system has important responsibilities, boundaries, dependency rules, flows, or architectural rationale that are not obvious from source layout.

Typical content:

- system purpose and context;
- major components and responsibilities;
- dependency direction;
- important seams and external boundaries;
- state ownership;
- important execution/data flows;
- architectural invariants;
- links to decision records where rationale matters.

Prefer explanation and diagrams over file inventories.

## 3. AI architecture context

Useful when coding agents repeatedly need a compact structural model to make safe changes.

Typical content:

- concise responsibility map;
- dependency direction;
- explicit forbidden or required boundaries;
- stable terminology;
- relevant paths;
- short pointers to deeper architecture docs;
- known exceptions that are expensive to rediscover.

Keep it much smaller than the human architecture explanation.

## 4. Human testing guide

Useful when verification strategy is non-trivial or multiple test levels serve different purposes.

Typical content:

- testing philosophy;
- verification layers and their responsibilities;
- when unit, behavioral, property, contract, integration, or end-to-end tests are appropriate;
- bug-fix regression expectations;
- expensive or environment-dependent test guidance;
- pointers to executable commands;
- exact commands, working directories, prerequisites, and their actual scope;
- automatic agent-run static checks and isolated local unit tests versus manual
  API, UI, Playwright E2E, and integration tests;
- explicit per-task authorization for manual tests, separately from availability.

Do not invent testing policy that the repository or user has not established.

## 5. AI testing context

Useful when agents need concise rules for deciding what verification to add or run.

Typical content:

- task-to-verification mapping;
- important test placement conventions;
- regression expectations;
- constraints around external dependencies;
- fast versus full verification pointers;
- explicit cases where adding tests would be inappropriate overhead;
- pointers to documented automatic-verification policy and unit-only commands;
- scope checks for aggregate scripts, discovery/imports, fixtures, and hooks;
- static-only fallback when automatic policy is missing, with the missing
  documented unit-only command reported;
- execution authorization kept separate from coverage creation and TDD;
- task-induced versus unrelated failures, blockers, and pending manual verification.

Prefer actionable rules over testing theory.

## 6. Development guide

Useful when setting up, running, validating, or contributing to the repository requires more than an obvious single command.

Typical content:

- environment prerequisites;
- setup flow;
- common run/build commands;
- fast and full verification paths;
- exact verification commands, working directories, prerequisites, and categories,
  linked to the authoritative agent execution policy;
- contribution workflow when repository-specific.

Commands should be grounded in actual scripts/configuration, not manually invented alternatives.

Validate command scope statically; documenting an available command does not authorize
its execution. A fast or unit label does not prove isolation from manual suites.

## 7. Repository map

Useful primarily for AI context or very large repositories where navigating responsibilities is expensive.

Typical content:

- major directories or packages;
- one-line responsibility of each;
- important dependency direction;
- where to look for common task categories.

Do not list every file. A repository map should reduce search, not mirror the tree.

## 8. Decision record

Useful for a durable, non-obvious, hard-to-reverse decision whose rationale would otherwise be lost.

Typical content:

- decision context;
- selected option;
- key alternatives;
- consequences and constraints;
- status/date if the repository's convention uses them.

Do not create decision records for routine refactoring details or temporary proposals.

## 9. Root agent instructions

Useful when coding agents need repository-wide operating rules.

Typical content:

- scope and instruction discovery rules;
- required context pointers;
- repository-wide constraints;
- verification expectations;
- automatic-verification policy: required static checks and isolated local unit
  tests, with command pointers, working directories, and prerequisites;
- manual API/UI/Playwright E2E/integration execution requiring explicit per-task
  user authorization, even when changing those tests or their framework;
- no-policy static-only fallback and reporting of missing unit-only authorization;
- escalation or ambiguity rules;
- links to compact AI context.

Keep root instructions small enough to load on routine tasks.

## 10. Scoped agent instructions

Useful when a subsystem has materially different conventions, verification, risks, or architectural rules.

Typical content:

- only the local differences from root behavior;
- local context pointers;
- subsystem-specific constraints;
- local verification requirements;
- scoped automatic/manual categories, command pointers, working directories,
  prerequisites, and authorization where they differ from root policy.

Do not create scoped instruction files for every directory when inherited rules are sufficient.

## 11. Documentation indexes

Useful when the documentation set is large enough that navigation itself becomes a problem.

Typical content:

- short categorized links;
- clear ownership or purpose labels;
- entry points by task or audience.

Avoid index layers that merely repeat the directory tree.

## 12. When not to create a new document

Prefer updating or linking existing documentation when:

- the information already has an authoritative home;
- the proposed file would mostly duplicate another document;
- the content is implementation trivia better expressed by code;
- the information is temporary and belongs in task artifacts;
- the repository is small enough that a new layer adds more navigation cost than value;
- the rule can and should be enforced mechanically rather than documented repeatedly.
