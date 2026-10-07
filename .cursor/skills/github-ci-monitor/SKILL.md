---
name: github-ci-monitor
description: >-
  Project-only GitHub auth + Actions helpers for varsha-pothuganti/portfolio.
  Use when cloning, pushing, PRs, or watching CI for this fork. Never override
  the user's default gh account (pranay10318).
---

# GitHub CI Monitor — Varsha Portfolio (local)

Orchestrate `gh` / git for **this repo only**, using the `varsha-pothuganti`
account without replacing personal GitHub creds used elsewhere.

## Hard rules

1. **Use `gh` CLI** — never GitHub MCP.
2. **Do not change the global active gh account** for day-to-day work.
   Prefer a **shell-local `GH_TOKEN`** for this project only.
3. Before every `gh`/`git push` in this project: clear Cursor’s injected token,
   then load Varsha’s token (see below).
4. **Do not commit or push** unless the user explicitly asks.
5. When the user is done with this project, leave default account as
   `pranay10318` (see Revert).

## Repo constants

| Key | Value |
|-----|--------|
| `REPO` | `varsha-pothuganti/portfolio` |
| Fork of | `pranay10318/portfolio-2` |
| Default branch | `main` |
| GitHub user for this project | `varsha-pothuganti` |
| Default machine account (keep) | `pranay10318` |

## Auth model (non-destructive)

Two supported setups. Both leave `pranay10318` as the normal default.

### Option A — Project PAT file (most temporary / least global impact)

1. On GitHub (logged in as **varsha-pothuganti**), create a classic PAT with
   at least: `repo`, `workflow`, `read:org`, `gist`.
2. Save it only on disk (never commit):

```bash
# from repo root
printf '%s' 'ghp_YOUR_TOKEN_HERE' > .cursor/.gh-token
chmod 600 .cursor/.gh-token
```

3. Use the helper for every command (see scripts).

### Option B — Extra `gh` account in keyring (still reversible)

Adds a **second** login; does **not** delete `pranay10318`.

```bash
unset GH_TOKEN GITHUB_TOKEN
# Login as varsha-pothuganti (browser). This may briefly become the active user.
gh auth login -h github.com -p https -w -s repo,read:org,gist,workflow
# Immediately restore default for other projects:
gh auth switch -u pranay10318
gh auth status   # active should be pranay10318; varsha listed but inactive
```

For this repo, still use the helper so you never need `gh auth switch` to Varsha.

## Activate for this project (shell-local only)

```bash
# Source from repo root — does NOT change global active account
source .cursor/skills/github-ci-monitor/scripts/activate-varsha-gh.sh
gh api user --jq .login   # must print: varsha-pothuganti
```

Or one-off:

```bash
.cursor/skills/github-ci-monitor/scripts/with-varsha-gh.sh gh repo view
.cursor/skills/github-ci-monitor/scripts/with-varsha-gh.sh git push -u origin HEAD
```

## Revert / leave this project

Nothing to uninstall if you used Option A — just stop sourcing the helper
(and optionally delete `.cursor/.gh-token`).

If you used Option B and want Varsha removed from the machine later:

```bash
unset GH_TOKEN GITHUB_TOKEN
gh auth switch -u pranay10318          # ensure default first
gh auth logout -u varsha-pothuganti    # optional cleanup
gh auth status
```

Cursor tip: if `gh auth status` shows `pranay-219 (GH_TOKEN)`, always
`unset GH_TOKEN GITHUB_TOKEN` first — that env var overrides keyring.

## Common commands

```bash
REPO=varsha-pothuganti/portfolio
HELPER=.cursor/skills/github-ci-monitor/scripts/with-varsha-gh.sh

$HELPER gh run list --repo "$REPO" --limit 10
$HELPER gh run view <run-id> --repo "$REPO" --log-failed
$HELPER gh pr list --repo "$REPO"
$HELPER gh pr create --repo "$REPO" --fill
```

## Agent checklist

1. `unset GH_TOKEN GITHUB_TOKEN` (clear Cursor override).
2. Load Varsha via helper / `activate-varsha-gh.sh`.
3. Verify: `gh api user --jq .login` → `varsha-pothuganti`.
4. Run git/`gh` for this fork.
5. Do **not** leave global active user on Varsha; prefer shell-local token.
6. No commit/push unless user asked.
