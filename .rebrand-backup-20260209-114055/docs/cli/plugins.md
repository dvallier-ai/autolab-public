---
summary: "CLI reference for `autolab plugins` (list, install, enable/disable, doctor)"
read_when:
  - You want to install or manage in-process Gateway plugins
  - You want to debug plugin load failures
title: "plugins"
---

# `autolab plugins`

Manage Gateway plugins/extensions (loaded in-process).

Related:

- Plugin system: [Plugins](/tools/plugin)
- Plugin manifest + schema: [Plugin manifest](/plugins/manifest)
- Security hardening: [Security](/gateway/security)

## Commands

```bash
autolab plugins list
autolab plugins info <id>
autolab plugins enable <id>
autolab plugins disable <id>
autolab plugins doctor
autolab plugins update <id>
autolab plugins update --all
```

Bundled plugins ship with AutoLab but start disabled. Use `plugins enable` to
activate them.

All plugins must ship a `autolab.plugin.json` file with an inline JSON Schema
(`configSchema`, even if empty). Missing/invalid manifests or schemas prevent
the plugin from loading and fail config validation.

### Install

```bash
autolab plugins install <path-or-spec>
```

Security note: treat plugin installs like running code. Prefer pinned versions.

Supported archives: `.zip`, `.tgz`, `.tar.gz`, `.tar`.

Use `--link` to avoid copying a local directory (adds to `plugins.load.paths`):

```bash
autolab plugins install -l ./my-plugin
```

### Update

```bash
autolab plugins update <id>
autolab plugins update --all
autolab plugins update <id> --dry-run
```

Updates only apply to plugins installed from npm (tracked in `plugins.installs`).
