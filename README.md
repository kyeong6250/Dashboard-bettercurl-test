# Dashboard-bettercurl-test

A small GitHub API "dashboard": a folder of [bettercurl](https://github.com/kyeong6250/Better-curl) request files, no application code. It exists to actually exercise bettercurl against a real API instead of a synthetic test double — plain GETs, query params, authenticated headers, a JSON POST body, all against [GitHub's REST API](https://docs.github.com/en/rest).

Every read-only request file here was run for real while building this repo, not just written to look plausible.

## Setup

```sh
pip install git+https://github.com/kyeong6250/Better-curl.git
```

Or, if you've got a local clone of Better-curl, `pip install -e .` from inside it instead — see its README for details.

## The requests

| File | Method | Demonstrates |
|---|---|---|
| [`requests/user-profile.yml`](requests/user-profile.yml) | GET | the simplest possible request file |
| [`requests/list-repos.yml`](requests/list-repos.yml) | GET | `params:` (`?sort=updated&per_page=5`) |
| [`requests/repo-details.yml`](requests/repo-details.yml) | GET | a single resource, a bigger JSON object (good for `-c`) |
| [`requests/list-issues.yml`](requests/list-issues.yml) | GET | `params:` again, against a different repo |
| [`requests/create-issue.example.yml`](requests/create-issue.example.yml) | POST | `json:` body + an `Authorization` header (template only, see below) |

Run any one on its own:

```sh
bettercurl -f requests/user-profile.yml -c
```

Or run all four read-only ones in sequence:

```powershell
.\run-all.ps1
```

```sh
# bash equivalent
for f in requests/*.yml; do
    [[ "$f" == *.example.yml || "$f" == *create-issue.yml ]] && continue
    echo "=== $f ==="
    bettercurl -f "$f" -c
done
```

## Trying the authenticated POST

`requests/create-issue.example.yml` is deliberately a template, not something meant to run as-is — running it for real creates an actual issue on a real repo, and it needs a real token to do that. To try it:

1. Copy it: `cp requests/create-issue.example.yml requests/create-issue.yml` (`create-issue.yml` is gitignored, so a real token in it can't get committed by accident)
2. Generate a [fine-grained personal access token](https://github.com/settings/tokens) with `Issues: write` on the target repo
3. Edit `requests/create-issue.yml` — swap `YOUR_GITHUB_TOKEN_HERE` for that token, and point `url:` at a repo you actually own or can write to
4. `bettercurl -f requests/create-issue.yml`

This file also happens to be the one that shows why bettercurl's spec uses `json:` rather than `data:` for request bodies — see [Better-curl's README](https://github.com/kyeong6250/Better-curl#json-vs-data--read-this-before-sending-a-postput-body) for why that distinction matters. It's a real bug the original project this was based on has sitting in its own docs.

## A few things worth knowing

GitHub's REST API allows 60 unauthenticated requests an hour per IP, plenty for poking around here, but you'll hit it if you loop `run-all.ps1` in a tight script. `requests/list-issues.yml` points at `octocat/Hello-World`, GitHub's own public demo repo, rather than one of your own, specifically so it returns real, non-empty data right away — swap the URL for any repo you like. And there's no application code here on purpose: if you want to see bettercurl itself, the CLI these files actually run through, that's over in [Better-curl](https://github.com/kyeong6250/Better-curl).
