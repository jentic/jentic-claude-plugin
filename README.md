# Jentic — Claude Code plugin

Claude Code plugin for [Jentic](https://jentic.com). It bundles two things that
work together as one workflow — **discover a capability with the hosted MCP
server, then inspect and execute it on self-hosted Jentic One**:

- **The Jentic remote MCP server** — a **search tool for agent capabilities** at
  `https://api.jentic.com/mcp`. Describe what you want to do in natural language
  ("send a Slack message", "pull recent NewsAPI articles") and it finds matching
  capabilities across the catalogue. Installing this plugin connects the server;
  on first use Claude Code runs the OAuth sign-in flow for you. Search is its
  purpose — the hosted **load and execute** tools are being deprecated, so once
  you've found a use case, move to self-hosted Jentic One to run it.
- **The `onboard-jentic-one` skill** — a step-by-step guide to install and onboard
  **self-hosted** [Jentic One](https://jentic.com/jentic-one), where you actually
  **search → inspect → execute** the capability you found. This is a separate
  product from the hosted search above: the skill walks you through standing up
  your own instance so secrets stay on your infrastructure. Because it ships as a
  local plugin skill, it is reachable with no authentication and no server
  round-trip.

## Workflow

1. **Discover** — use the hosted `jentic` MCP server to search for an agent
   capability in natural language until you find the use case you want.
2. **Onboard** — run `/jentic:onboard-jentic-one` to stand up self-hosted Jentic
   One (once).
3. **Execute** — on your instance, run the capability with the
   `jentic catalog import → search → inspect → execute` loop. The hosted server's
   load/execute path is deprecated; self-hosted is where execution lives.

## Install

This is a private marketplace for now; you need read access to the repo.

```
/plugin marketplace add jentic/jentic-claude-plugin
/plugin install jentic@jentic
```

Then, if prompted, run `/reload-plugins`.

- **Search for a capability:** the `jentic` MCP server connects automatically.
  The first request triggers an OAuth sign-in in your browser; Claude Code stores
  the token for you — nothing is kept in this repo.
- **Onboard self-hosted Jentic One:** invoke the skill with
  `/jentic:onboard-jentic-one`.

## Contents

- `.mcp.json` — the Jentic remote MCP server (capability search, OAuth).
- `skills/onboard-jentic-one/SKILL.md` — the self-hosted onboarding skill.
