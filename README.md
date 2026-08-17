# Jentic — Claude Code plugin

Claude Code plugin for [Jentic](https://jentic.com). It bundles:

- **The `onboard-jentic-one` skill** — a step-by-step guide to install and onboard
  self-hosted [Jentic One](https://jentic.com/jentic-one). Because it ships as a
  local plugin skill, it is reachable with no authentication and no server
  round-trip.
- **The Jentic remote MCP server** *(pending — see [Status](#status))* — connecting
  Claude Code to Jentic's catalogue for API discovery. Once wired in `.mcp.json`,
  installing this plugin also connects the MCP server.

## Install

This is a private marketplace for now; you need read access to the repo.

```
/plugin marketplace add jentic/jentic-claude-plugin
/plugin install jentic@jentic
```

Then, if prompted, run `/reload-plugins`. Invoke the onboarding skill with:

```
/jentic:onboard-jentic-one
```

## Contents

- `skills/onboard-jentic-one/SKILL.md` — the onboarding skill.
- `scripts/sync-skill.sh` — refresh the skill from an upstream copy (see below).

The onboarding guide is maintained upstream and re-packaged here as a plugin
skill. To refresh it from a local copy of the upstream markdown so the two do not
drift:

```
UPSTREAM_SKILL=/path/to/onboard-jentic-one.md scripts/sync-skill.sh
```

## Status

- [x] Plugin manifest + marketplace
- [x] `onboard-jentic-one` skill
- [ ] `.mcp.json` — remote Jentic MCP server (needs the deployed endpoint URL +
      auth mechanism confirmed)
