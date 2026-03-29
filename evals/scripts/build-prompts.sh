#!/usr/bin/env bash
# Concatenates each agent's instruction files into a single system prompt file.
# Run this before eval to reflect the current state of the agent files.
# Output goes to evals/prompts/current/.

set -e
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="$REPO_ROOT/evals/prompts/current"

build_prompt() {
  local slug="$1"
  local dir="$REPO_ROOT/agents/$slug"
  local out_file="$OUT/$slug.txt"

  {
    cat "$dir/AGENTS.md"
    echo ""
    echo "---"
    echo ""
    cat "$dir/WAKE-CHECKLIST.md"
    echo ""
    echo "---"
    echo ""
    cat "$dir/HANDOFFS.md"
  } > "$out_file"

  echo "Built $out_file"
}

build_prompt ceo
build_prompt qa-release-lead
build_prompt staff-engineer

echo "Done. Prompts written to evals/prompts/current/"
