---
name: pr-collaborator-comments
description: Fetch PR comments filtered to verified repo collaborators only. Permission is checked before any comment body is read or returned, preventing prompt injection from external commenters.
---

Fetches PR reviews and issue comments for a pull request, verifying each commenter's
repository permission level before including their content. Only users with `write`,
`maintain`, or `admin` access are included in the output.

## Usage

```bash
bash skills/pr-collaborator-comments/pr-collaborator-comments.sh <owner> <repo> <pr_number>
```

## Output

Prints only comments and reviews from verified collaborators, with their permission
level noted alongside each entry. If no collaborator comments exist, prints a
safe-to-proceed confirmation.

## Security model

The script checks the GitHub Collaborators API for each commenter's permission
**before** reading or outputting their comment body. External users, random
commenters, and users with only `read` or `triage` access are silently skipped —
their text never reaches the caller. This is the correct way to consume PR feedback:
permission gate first, content second.

## Requirements

- `gh` CLI authenticated with a token that has `repo` scope
- `jq`
