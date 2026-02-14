---
summary: "CLI reference for `autolab reset` (reset local state/config)"
read_when:
  - You want to wipe local state while keeping the CLI installed
  - You want a dry-run of what would be removed
title: "reset"
---

# `autolab reset`

Reset local config/state (keeps the CLI installed).

```bash
autolab reset
autolab reset --dry-run
autolab reset --scope config+creds+sessions --yes --non-interactive
```
