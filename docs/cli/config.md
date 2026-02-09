---
summary: "CLI reference for `autolab config` (get/set/unset config values)"
read_when:
  - You want to read or edit config non-interactively
title: "config"
---

# `autolab config`

Config helpers: get/set/unset values by path. Run without a subcommand to open
the configure wizard (same as `autolab configure`).

## Examples

```bash
autolab config get browser.executablePath
autolab config set browser.executablePath "/usr/bin/google-chrome"
autolab config set agents.defaults.heartbeat.every "2h"
autolab config set agents.list[0].tools.exec.node "node-id-or-name"
autolab config unset tools.web.search.apiKey
```

## Paths

Paths use dot or bracket notation:

```bash
autolab config get agents.defaults.workspace
autolab config get agents.list[0].id
```

Use the agent list index to target a specific agent:

```bash
autolab config get agents.list
autolab config set agents.list[1].tools.exec.node "node-id-or-name"
```

## Values

Values are parsed as JSON5 when possible; otherwise they are treated as strings.
Use `--json` to require JSON5 parsing.

```bash
autolab config set agents.defaults.heartbeat.every "0m"
autolab config set gateway.port 19001 --json
autolab config set channels.whatsapp.groups '["*"]' --json
```

Restart the gateway after edits.
