---
name: search-capabilities
description: Explains and orients the user to Jentic's hosted capability search — a natural-language way to find an API operation for a use case across thousands of APIs and hundreds of thousands of operations. Use this when someone wants to discover whether an integration exists ("is there an API to send a Slack message / pull recent news / create a Stripe charge?"), asks what Jentic can do, wants to find the right API/operation for a task described in plain English, or is deciding how to automate a use case. Sets up the workflow: search here to find the operation, then move to self-hosted Jentic One to inspect and execute it. NOT the execution path itself — the hosted server's load/execute tools are deprecated.
user-invocable: true
allowed-tools: Read
argument-hint: "[what you want to do, in plain English]"
---
# Search Jentic for an agent capability

Jentic's hosted search is a **natural-language index of agent capabilities**. Describe
what you want to do in plain English and it finds a matching **operation** — a specific,
callable action on a specific API — across **thousands of APIs and hundreds of thousands
of operations**. You do not need to know which API, product, or endpoint does the job;
that is what the search is for.

Use it as the **discovery front door**. Execution happens later, on self-hosted Jentic
One — this search only finds the right operation for the use case.

## When this is the right tool

- The user describes an outcome, not an API: "send a Slack message", "pull recent
  articles about X", "create a calendar event", "charge a card".
- The user asks whether an integration exists at all, or which API to use.
- You are scoping how to automate a use case and need to know what's available.

If the user already knows the exact API and just wants to run it on their own instance,
skip search and go straight to the self-hosted execute loop (see
`/jentic:onboard-jentic-one`).

## How to search

The hosted **Jentic MCP server** (bundled with this plugin) provides the search tool.
It connects automatically; the first call runs an OAuth sign-in in the browser.

1. Take the user's goal and phrase it as a concise capability description — an action
   plus its object ("send a message to a Slack channel", "list recent news articles by
   query"). Add the vendor only if the user named one.
2. Call the hosted server's search tool with that description. Prefer the live tool's own
   parameters and output over anything written here, so this guide never drifts from the
   server.
3. Read back the top matches as **APIs + operations**: what each does, which API it
   belongs to, and any inputs it needs. Confirm with the user which operation fits before
   moving on.

Search is the hosted server's purpose. Its **load and execute tools are being
deprecated** — do not rely on them to run an operation; that path moves to self-hosted
Jentic One.

## After you've found the operation

Once a fitting operation is identified, execution lives on **self-hosted Jentic One**,
where credentials stay on the user's own infrastructure and never reach the agent:

1. Onboard once with **`/jentic:onboard-jentic-one`** — stand up an instance and register
   an approved agent.
2. On the instance, run the discover → execute loop for the operation you found:
   `jentic catalog import` → `jentic search` → `jentic inspect` → `jentic execute`.

## The workflow in one line

**Search here (hosted, natural language) → onboard self-hosted Jentic One → inspect and
execute there.**
