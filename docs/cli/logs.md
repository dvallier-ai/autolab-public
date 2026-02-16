---
summary: "CLI reference for `autolab logs` (tail gateway logs via RPC)"
read_when:
  - You need to tail Gateway logs remotely (without SSH)
  - You want JSON log lines for tooling
title: "logs"
---

# `autolab logs`

Tail Gateway file logs over RPC (works in remote mode).

Related:

- Logging overview: [Logging](/logging)

## Examples

```bash
autolab logs
autolab logs --follow
autolab logs --json
autolab logs --limit 500
autolab logs --local-time
autolab logs --follow --local-time
```

Use `--local-time` to render timestamps in your local timezone.
