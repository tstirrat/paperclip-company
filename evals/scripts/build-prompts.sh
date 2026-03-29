#!/usr/bin/env bash
# Builds eval prompt files from agent instruction files.
# Run before evals to reflect the current state of the agent files.
#
# Generates:
#   evals/prompts/current/{agent}.txt       — concatenated agent instructions
#   evals/prompts/templates/{agent}-current.json   — JSON chat template for promptfoo
#   evals/prompts/templates/{agent}-baseline.json  — JSON chat template from baseline snapshot

set -e
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CURRENT="$REPO_ROOT/evals/prompts/current"
BASELINES="$REPO_ROOT/evals/prompts/baselines"
TEMPLATES="$REPO_ROOT/evals/prompts/templates"

mkdir -p "$CURRENT" "$TEMPLATES"

build_agent() {
  local slug="$1"
  local dir="$REPO_ROOT/agents/$slug"

  # Concatenate instruction files into a single system prompt
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
  } > "$CURRENT/$slug.txt"

  # Generate JSON chat templates for promptfoo (jq handles escaping)
  jq -n \
    --rawfile instructions "$CURRENT/$slug.txt" \
    '[{"role":"system","content":$instructions},{"role":"user","content":"{{scenario}}"}]' \
    > "$TEMPLATES/$slug-current.json"

  jq -n \
    --rawfile instructions "$BASELINES/$slug.txt" \
    '[{"role":"system","content":$instructions},{"role":"user","content":"{{scenario}}"}]' \
    > "$TEMPLATES/$slug-baseline.json"

  echo "Built $slug"
}

build_agent ceo
build_agent qa-release-lead
build_agent staff-engineer

echo "Done. Templates written to evals/prompts/templates/"
