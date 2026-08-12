#!/usr/bin/env bash
# Remove only Codex skill links that point at this project.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skill_groups=(
  "$repo_root/delivery-workflow"
  "$repo_root/engineering"
)
codex_skills_dir="${CODEX_HOME:-$HOME/.codex}/skills"

[[ -d "$codex_skills_dir" ]] || exit 0

for skills_root in "${skill_groups[@]}"; do
  [[ -d "$skills_root" ]] || continue

  for skill_file in "$skills_root"/*/SKILL.md; do
    [[ -f "$skill_file" ]] || continue

    source_dir="$(dirname "$skill_file")"
    skill_name="$(basename "$source_dir")"
    target="$codex_skills_dir/$skill_name"

    if [[ -L "$target" && "$(readlink -f -- "$target")" == "$source_dir" ]]; then
      rm -- "$target"
      printf 'Removed: %s\n' "$target"
    elif [[ -e "$target" || -L "$target" ]]; then
      printf 'Not removing %s: it does not link to this project skill.\n' "$target" >&2
    fi
  done
done
