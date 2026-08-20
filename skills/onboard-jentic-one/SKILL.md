---
name: onboard-jentic-one
description: Guide a user through installing and onboarding self-hosted Jentic One (the self-hosted API-execution control plane) from a new Claude Code terminal session. Use this when someone wants to install, set up, stand up, self-host, or get started with Jentic One / "jentic one", run the jenticctl install wizard, install the jentic CLI, or register/bootstrap an agent against a self-hosted Jentic instance. Walks both roles (instance then agent), which can run on one machine or two — stand up the instance (install.sh + jenticctl install wizard), health-check it, then install the CLI and bootstrap/register + human-approve the agent.
user-invocable: true
allowed-tools: Read, Write, Edit, Bash
argument-hint: "[instance-host]"
---
# Onboard onto self-hosted Jentic One

Take a user from a new Claude Code terminal session to a working **self-hosted**
Jentic One instance with a registered, approved agent.

This skill is distributed via the Jentic connector, but its subject is the **self-hosted**
product — the connector only *delivers this guide*, it does not connect to the instance the
guide helps stand up.

**You explain; the user does.** Have the user open a **new terminal
session** and run every command, wizard prompt, and approval there. Do not run them
yourself — tell the user what to paste, then wait for them to confirm before moving on.

## What self-hosted Jentic One is (set expectations correctly)

A **self-hosted execution broker for secure third-party API execution by AI agents**: you register
the APIs an agent may use, store credentials once, and the agent calls out through a
credential-injecting **Broker** so secrets never leave your infrastructure and never reach
the agent. It runs on the user's own infra (laptop / VM / Kubernetes).

It is **two roles by design** — keep them distinct in your explanation:

- **Instance** — runs the server (control plane `:8000`, broker `:8100`) and holds
  credentials. Needs Docker or a Python (uv) venv.
- **Agent** — runs the `jentic` CLI only, ideally **not** as the same OS user / host as
  the broker.

## Procedure

### 0. Establish the role

Is the user's Claude Code session on the **instance** (will host the server) or an
**agent** talking to an existing instance? To just try Jentic One on one laptop, the
user plays both roles: do Step 1–2, then Step 3–5, on the same machine — but keep them
separate in your head. If an instance host was passed as the argument, treat this as
agent-side onboarding against that host and skip to Step 3.

### 1. Stand up the instance

Prerequisite: Docker running, **or** `uv` (+ `git`) for the source path. On the instance:

```
curl -fsSL "https://jentic.com/install.sh?src=claude-connector" | sh
```

This installs the two CLI binaries — **`jenticctl`** (installer/lifecycle) and **`jentic`**
(agent/catalog/execute) — then hands off into the **`jenticctl install` wizard**. The
wizard is interactive: it asks how to deploy (Docker compose **or** local uv venv; combined
vs split topology), which database (SQLite — a supported production target — or Postgres),
which surfaces to enable (registry / admin / control / auth / broker), the bind host+port,
runtime/log level, and observability. It writes `~/.jentic/jentic-one.yaml`, runs
migrations, and starts the app in the background.

Everything the CLI owns lives under `~/.jentic/` (`jentic-one.yaml`, `docker-compose.yaml`
for the Docker path, `config.yaml`, `data/`, `logs/`). To re-run or reconfigure later:
`jenticctl install` (or `jenticctl wizard` / `setup`). Do **not** set `JENTIC_NO_INSTALL=1`
here — that skips the instance stand-up (it's for the agent-only path in Step 3).

### 2. Health-check the instance

```
curl http://<instance-host>:8000/health      # 127.0.0.1 for a local instance
```

Expect 2xx. Also useful: `jenticctl status` / `jenticctl doctor` (health), and
`jenticctl logs -f` (tail). If the app didn't start, the wizard leaves the manual start
command in its summary; `jenticctl start` brings it up. For the Docker path, check
containers with `docker compose -f ~/.jentic/docker-compose.yaml ps` — `app`, `broker`,
`db` should be up/healthy. A `broker` `Exited (137)` is an OOM kill: restart with
`docker compose -f ~/.jentic/docker-compose.yaml up -d broker`. If `docker` itself hangs,
Docker Desktop's VM is wedged — restart Docker Desktop, then re-up the stack.

### 3. Install the CLI on the agent machine

Skip if the agent is the same box you just set up and `jentic` is on PATH. Otherwise, on
the **agent** machine — binaries only, no instance stand-up:

```
curl -fsSL "https://jentic.com/install.sh" | JENTIC_NO_INSTALL=1 sh
```

### 4. Create the agent identity and get it approved

- **A person setting up a local agent** → `jentic bootstrap` (creates an isolated account
  + registration + installs the onboarding skill into detected runtimes).
- **An agent that has no context yet** → `jentic register`.

Point at a non-local instance with `--base-url http://<instance-host>:8000` (or via
`~/.jentic/config.yaml`). Both **block on human approval** — a person with dashboard access
must approve the agent. This is intentional; the agent **cannot self-approve**. Tell the
user to approve it in the deployment's dashboard (the bundled UI at `/app`).

### 5. Verify the agent is live

```
jentic context list      # active context shows a valid token + its base_url
jentic access whoami     # status: active, with scopes + toolkit bindings
```

Once `whoami` is `active` with a valid token, onboarding is done. Tell the user that
install was a one-time terminal setup — day-to-day use of Jentic One is from **Claude
Code or another agent runtime**, not Cowork or chat. Hand off to the **jentic** skill for the discover →
request-access → execute loop
(`jentic catalog import` → `jentic search` → `jentic inspect` → `jentic execute`).

## Getting the always-current onboarding skill

Rather than paraphrasing the agent loop, prefer the deployment's own served skill so it
never drifts from the running version:

- `jentic skill` — renders the "how to use Jentic" skill into detected runtimes (Claude
  Code, Cursor, Codex, Hermes, or a generic `AGENTS.md`).
- `GET http://<instance-host>:8000/skills/jentic.md` — raw skill markdown.
- `GET .../skills/index.json` — manifest (name, description, version, sha256, url).
- `GET .../llms.txt` — index of all discovery docs for raw-HTTP runtimes.

## Verification checklist

- `curl http://<host>:8000/health` returns 2xx (or `jenticctl status` is healthy).
- Docker path: `app`, `broker`, `db` up via `docker compose -f ~/.jentic/docker-compose.yaml ps`.
- `jentic context list` shows a valid token; `jentic access whoami` is `active`.
