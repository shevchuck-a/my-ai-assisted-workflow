#!/usr/bin/env bash
# Link each delivery-workflow skill into this user's Codex skills directory.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills_root="$repo_root/delivery-workflow"
codex_skills_dir="${CODEX_HOME:-$HOME/.codex}/skills"

mkdir -p "$codex_skills_dir"

for skill_file in "$skills_root"/*/SKILL.md; do
  [[ -f "$skill_file" ]] || continue

  source_dir="$(dirname "$skill_file")"
  skill_name="$(basename "$source_dir")"
  target="$codex_skills_dir/$skill_name"

  if [[ -e "$target" || -L "$target" ]]; then
    if [[ -L "$target" && "$(readlink -f -- "$target")" == "$source_dir" ]]; then
      printf 'Already linked: %s\n' "$skill_name"
      continue
    fi

    printf 'Not linking %s: %s already exists and is not this project skill.\n' \
      "$skill_name" "$target" >&2
    continue
  fi

  ln -s "$source_dir" "$target"
  printf 'Linked: %s -> %s\n' "$target" "$source_dir"
done
