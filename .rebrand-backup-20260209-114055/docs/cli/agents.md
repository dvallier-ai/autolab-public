---
summary: "CLI reference for `autolab agents` (list/add/delete/set identity)"
read_when:
  - You want multiple isolated agents (workspaces + routing + auth)
title: "agents"
---

# `autolab agents`

Manage isolated agents (workspaces + auth + routing).

Related:

- Multi-agent routing: [Multi-Agent Routing](/concepts/multi-agent)
- Agent workspace: [Agent workspace](/concepts/agent-workspace)

## Examples

```bash
autolab agents list
autolab agents add work --workspace ~/.autolab/workspace-work
autolab agents set-identity --workspace ~/.autolab/workspace --from-identity
autolab agents set-identity --agent main --avatar avatars/autolab.png
autolab agents delete work
```

## Identity files

Each agent workspace can include an `IDENTITY.md` at the workspace root:

- Example path: `~/.autolab/workspace/IDENTITY.md`
- `set-identity --from-identity` reads from the workspace root (or an explicit `--identity-file`)

Avatar paths resolve relative to the workspace root.

## Set identity

`set-identity` writes fields into `agents.list[].identity`:

- `name`
- `theme`
- `emoji`
- `avatar` (workspace-relative path, http(s) URL, or data URI)

Load from `IDENTITY.md`:

```bash
autolab agents set-identity --workspace ~/.autolab/workspace --from-identity
```

Override fields explicitly:

```bash
autolab agents set-identity --agent main --name "AutoLab" --emoji "🦞" --avatar avatars/autolab.png
```

Config sample:

```json5
{
  agents: {
    list: [
      {
        id: "main",
        identity: {
          name: "AutoLab",
          theme: "space lobster",
          emoji: "🦞",
          avatar: "avatars/autolab.png",
        },
      },
    ],
  },
}
```
