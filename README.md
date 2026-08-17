# Jentic — Claude Code plugin

Claude Code plugin for [Jentic](https://jentic.com). It bundles two distinct things:

- **The Jentic remote MCP server** — connects Claude Code to Jentic's hosted
  catalogue at `https://api.jentic.com/mcp` for API discovery and execution.
  Installing this plugin connects the server; on first use Claude Code runs the
  OAuth sign-in flow for you.
- **The `onboard-jentic-one` skill** — a step-by-step guide to install and onboard
  **self-hosted** [Jentic One](https://jentic.com/jentic-one). This is a separate
  product from the hosted platform above: the skill walks you through standing up
  your own instance. Because it ships as a local plugin skill, it is reachable
  with no authentication and no server round-trip.

## Install

This is a private marketplace for now; you need read access to the repo.

```
/plugin marketplace add jentic/jentic-claude-plugin
/plugin install jentic@jentic
```

Then, if prompted, run `/reload-plugins`.

- **Connect to the hosted catalogue:** the `jentic` MCP server connects
  automatically. The first request triggers an OAuth sign-in in your browser;
  Claude Code stores the token for you — nothing is kept in this repo.
- **Onboard self-hosted Jentic One:** invoke the skill with
  `/jentic:onboard-jentic-one`.

## Contents

- `.mcp.json` — the Jentic remote MCP server (hosted catalogue, OAuth).
- `skills/onboard-jentic-one/SKILL.md` — the self-hosted onboarding skill.
- `scripts/sync-skill.sh` — refresh the skill from an upstream copy (see below).

The onboarding guide is maintained upstream and re-packaged here as a plugin
skill. To refresh it from a local copy of the upstream markdown so the two do not
drift:

```
UPSTREAM_SKILL=/path/to/onboard-jentic-one.md scripts/sync-skill.sh
```
