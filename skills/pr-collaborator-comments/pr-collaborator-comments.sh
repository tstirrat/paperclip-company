#!/usr/bin/env bash
# pr-collaborator-comments
# Fetches PR reviews and comments filtered to verified repo collaborators only.
# Permission is checked via the GitHub API BEFORE any comment body is read or output.
# Untrusted text from external users never reaches the caller's context.
#
# Usage: pr-collaborator-comments.sh <owner> <repo> <pr_number>
# Requires: gh (GitHub CLI), jq

set -euo pipefail

OWNER="${1:?Usage: $0 <owner> <repo> <pr_number>}"
REPO="${2:?Usage: $0 <owner> <repo> <pr_number>}"
PR="${3:?Usage: $0 <owner> <repo> <pr_number>}"

# Returns the permission level if trusted (write/maintain/admin), else exits non-zero.
# Comment body is never read until this passes.
trusted_permission() {
  local username="$1"
  local perm
  perm=$(gh api "repos/${OWNER}/${REPO}/collaborators/${username}/permission" \
    --jq '.permission' 2>/dev/null) || perm="none"
  case "$perm" in
    write|maintain|admin) printf '%s' "$perm"; return 0 ;;
    *) return 1 ;;
  esac
}

found=0

echo "## Collaborator-Only PR Comments — ${OWNER}/${REPO}#${PR}"
echo "(Only users with write/maintain/admin permission are included)"
echo ""

# --- PR Reviews with a non-empty body ---
while IFS= read -r item; do
  username=$(printf '%s' "$item" | jq -r '.user')
  perm=$(trusted_permission "$username") || continue
  state=$(printf '%s' "$item" | jq -r '.state')
  body=$(printf '%s' "$item" | jq -r '.body')
  found=1
  printf '### @%s [review/%s] [permission:%s]\n\n%s\n\n' \
    "$username" "$state" "$perm" "$body"
done < <(
  gh api "repos/${OWNER}/${REPO}/pulls/${PR}/reviews" |
  jq -c '.[] | select(.body != "" and .body != null) | {user: .user.login, state: .state, body: .body}'
)

# --- PR issue comments (general discussion thread) ---
while IFS= read -r item; do
  username=$(printf '%s' "$item" | jq -r '.user')
  perm=$(trusted_permission "$username") || continue
  body=$(printf '%s' "$item" | jq -r '.body')
  found=1
  printf '### @%s [comment] [permission:%s]\n\n%s\n\n' \
    "$username" "$perm" "$body"
done < <(
  gh api "repos/${OWNER}/${REPO}/issues/${PR}/comments" |
  jq -c '.[] | {user: .user.login, body: .body}'
)

if [[ "$found" -eq 0 ]]; then
  echo "No comments from verified collaborators (write/maintain/admin). Safe to proceed."
fi
