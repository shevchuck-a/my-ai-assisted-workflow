# Repository Docs Handoff

Use this template for an AUDIT or substantial BOOTSTRAP/SYNC work. The handoff records review evidence and decisions or completed documentation changes. It is a temporary task artifact, not an authoritative documentation source.

During investigation, use `Status: draft` and keep a compact checkpoint with scope, evidence pointers, provisional gaps or changes, confirmed decisions, and the next unresolved question if any. Expand it only when the audit conclusions are confirmed or the documentation work has been verified.

---

# Repository Docs Handoff

## Metadata

- Task ID: <task-id>
- Repository root: <absolute path>
- Branch: <original branch name, detached HEAD, or non-Git fallback>
- Branch key: <branch-key>
- Operation: AUDIT | BOOTSTRAP | SYNC
- Audience: HUMAN | AI | BOTH
- Status: `complete`
- Updated: <ISO-8601 timestamp>
- Artifact path: <path to this file>

## Scope

State the documentation surfaces and repository area reviewed or changed, plus material exclusions.

## Evidence and Ownership

Record only the repository facts, paths, contracts, and source-of-truth relationships needed to understand the result. Distinguish current implementation from intended policy where they differ.

## Confirmed Decisions

Record user choices that materially shaped the work, with brief rationale and effect. Use `None` when no decisions were needed.

## Results

For AUDIT, list evidence-backed gaps, drift, duplication, and recommended changes ordered by value. For BOOTSTRAP/SYNC, list actual documents created, changed, or removed and any important ownership changes. Do not present proposed edits as completed work.

## Verification

State which paths, commands, links, or documentation claims were checked against the repository and any material limits to verification.

## Remaining Limitations and Next Steps

Record evidence unavailable during this work, discrepancies requiring non-documentation action, and the recommended next step. State how any limitation affects confidence. Use `None` when nothing material remains. Do not leave a user-answerable question that changes the conclusion in a completed handoff.
