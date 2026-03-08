# AutoLab — Personal AI Assistant

<p align="center">
    <img src="https://raw.githubusercontent.com/dvallier-ai/autolab-public/main/docs/assets/autolab-banner.png" alt="AutoLab" width="800">
</p>

<p align="center">
  <a href="https://github.com/dvallier-ai/autolab-public/releases"><img src="https://img.shields.io/github/v/release/dvallier-ai/autolab-public?include_prereleases&style=for-the-badge" alt="GitHub release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge" alt="MIT License"></a>
</p>

<p align="center">
  <a href="https://github.com/dvallier-ai/autolab-public/actions/workflows/ci.yml?branch=main"><img src="https://img.shields.io/github/actions/workflow/status/dvallier-ai/autolab-public/ci.yml?branch=main&style=for-the-badge" alt="CI status"></a>
  <a href="https://github.com/dvallier-ai/autolab-public/releases"><img src="https://img.shields.io/github/v/release/dvallier-ai/autolab-public?include_prereleases&style=for-the-badge" alt="GitHub release"></a>
  <a href=""><img src="https://img.shields.io/discord/1456350064065904867?label=Discord&logo=discord&logoColor=white&color=5865F2&style=for-the-badge" alt="Discord"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge" alt="MIT License"></a>
</p>

**AutoLab** is a _personal AI assistant_ you run on your own devices.
It answers you on the channels you already use (WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, iMessage, Microsoft Teams, WebChat), plus extension channels like BlueBubbles, Matrix, Zalo, and Zalo Personal. It can speak and listen on macOS/iOS/Android, and can render a live Canvas you control. The Gateway is just the control plane — the product is the assistant.

If you want a personal, single-user assistant that feels local, fast, and always-on, this is it.

[Docs](docs/index.md) · [Getting Started](docs/start/getting-started) · [Updating](docs/install/updating) · [Showcase](docs/start/showcase) · [FAQ](docs/start/faq) · [Wizard](docs/start/wizard) · [Nix](https://github.com/autolab/nix-autolab) · [Docker](docs/install/docker)

Preferred setup: run the onboarding wizard (`autolab onboard`) in your terminal.
The wizard guides you step by step through setting up the gateway, workspace, channels, and skills. The CLI wizard is the recommended path and works on **macOS, Linux, and Windows (via WSL2; strongly recommended)**.
Works with npm, pnpm, or bun.
New install? Start here: [Getting started](docs/start/getting-started)

**Subscriptions (OAuth):**

- **[Anthropic](https://www.anthropic.com/)** (Claude Pro/Max)
- **[OpenAI](https://openai.com/)** (ChatGPT/Codex)

Model note: while any model is supported, I strongly recommend **Anthropic Pro/Max (100/200) + Opus 4.6** for long‑context strength and better prompt‑injection resistance. See [Onboarding](docs/start/onboarding).

## Models (selection + auth)

- Models config + CLI: [Models](docs/concepts/models)
- Auth profile rotation (OAuth vs API keys) + fallbacks: [Model failover](docs/concepts/model-failover)

## Install (recommended)

Runtime: **Node ≥22**.

```bash
npm install -g autolab@latest
# or: pnpm add -g autolab@latest

autolab onboard --install-daemon
```

The wizard installs the Gateway daemon (launchd/systemd user service) so it stays running.

## Quick start (TL;DR)

Runtime: **Node ≥22**.

Full beginner guide (auth, pairing, channels): [Getting started](docs/start/getting-started)

```bash
autolab onboard --install-daemon

autolab gateway --port 18789 --verbose

# Send a message
autolab message send --to +1234567890 --message "Hello from AutoLab"

# Talk to the assistant (optionally deliver back to any connected channel: WhatsApp/Telegram/Slack/Discord/Google Chat/Signal/iMessage/BlueBubbles/Microsoft Teams/Matrix/Zalo/Zalo Personal/WebChat)
autolab agent --message "Ship checklist" --thinking high
```

Upgrading? [Updating guide](docs/install/updating) (and run `autolab doctor`).

## Development channels

- **stable**: tagged releases (`vYYYY.M.D` or `vYYYY.M.D-<patch>`), npm dist-tag `latest`.
- **beta**: prerelease tags (`vYYYY.M.D-beta.N`), npm dist-tag `beta` (macOS app may be missing).
- **dev**: moving head of `main`, npm dist-tag `dev` (when published).

Switch channels (git + npm): `autolab update --channel stable|beta|dev`.
Details: [Development channels](docs/install/development-channels).

## From source (development)

Prefer `pnpm` for builds from source. Bun is optional for running TypeScript directly.

```bash
git clone https://github.com/dvallier-ai/autolab-public.git
cd autolab

pnpm install
pnpm ui:build # auto-installs UI deps on first run
pnpm build

pnpm autolab onboard --install-daemon

# Dev loop (auto-reload on TS changes)
pnpm gateway:watch
```

Note: `pnpm autolab ...` runs TypeScript directly (via `tsx`). `pnpm build` produces `dist/` for running via Node / the packaged `autolab` binary.

## Security defaults (DM access)

AutoLab connects to real messaging surfaces. Treat inbound DMs as **untrusted input**.

Full security guide: [Security](docs/gateway/security)

Default behavior on Telegram/WhatsApp/Signal/iMessage/Microsoft Teams/Discord/Google Chat/Slack:

- **DM pairing** (`dmPolicy="pairing"` / `channels.discord.dmPolicy="pairing"` / `channels.slack.dmPolicy="pairing"`; legacy: `channels.discord.dm.policy`, `channels.slack.dm.policy`): unknown senders receive a short pairing code and the bot does not process their message.
- Approve with: `autolab pairing approve <channel> <code>` (then the sender is added to a local allowlist store).
- Public inbound DMs require an explicit opt-in: set `dmPolicy="open"` and include `"*"` in the channel allowlist (`allowFrom` / `channels.discord.allowFrom` / `channels.slack.allowFrom`; legacy: `channels.discord.dm.allowFrom`, `channels.slack.dm.allowFrom`).

Run `autolab doctor` to surface risky/misconfigured DM policies.

## Highlights

- **[Local-first Gateway](docs/gateway)** — single control plane for sessions, channels, tools, and events.
- **[Multi-channel inbox](docs/channels)** — WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, BlueBubbles (iMessage), iMessage (legacy), Microsoft Teams, Matrix, Zalo, Zalo Personal, WebChat, macOS, iOS/Android.
- **[Multi-agent routing](docs/gateway/configuration)** — route inbound channels/accounts/peers to isolated agents (workspaces + per-agent sessions).
- **[Voice Wake](docs/nodes/voicewake) + [Talk Mode](docs/nodes/talk)** — always-on speech for macOS/iOS/Android with ElevenLabs.
- **[Live Canvas](docs/platforms/mac/canvas)** — agent-driven visual workspace with [A2UI](docs/platforms/mac/canvas#canvas-a2ui).
- **[First-class tools](docs/tools)** — browser, canvas, nodes, cron, sessions, and Discord/Slack actions.
- **[Companion apps](docs/platforms/macos)** — macOS menu bar app + iOS/Android [nodes](docs/nodes).
- **[Onboarding](docs/start/wizard) + [skills](docs/tools/skills)** — wizard-driven setup with bundled/managed/workspace skills.

## Everything we built so far

### Core platform

- [Gateway WS control plane](docs/gateway) with sessions, presence, config, cron, webhooks, [Control UI](docs/web), and [Canvas host](docs/platforms/mac/canvas#canvas-a2ui).
- [CLI surface](docs/tools/agent-send): gateway, agent, send, [wizard](docs/start/wizard), and [doctor](docs/gateway/doctor).
- [Pi agent runtime](docs/concepts/agent) in RPC mode with tool streaming and block streaming.
- [Session model](docs/concepts/session): `main` for direct chats, group isolation, activation modes, queue modes, reply-back. Group rules: [Groups](docs/concepts/groups).
- [Media pipeline](docs/nodes/images): images/audio/video, transcription hooks, size caps, temp file lifecycle. Audio details: [Audio](docs/nodes/audio).

### Channels

- [Channels](docs/channels): [WhatsApp](docs/channels/whatsapp) (Baileys), [Telegram](docs/channels/telegram) (grammY), [Slack](docs/channels/slack) (Bolt), [Discord](docs/channels/discord) (discord.js), [Google Chat](docs/channels/googlechat) (Chat API), [Signal](docs/channels/signal) (signal-cli), [BlueBubbles](docs/channels/bluebubbles) (iMessage, recommended), [iMessage](docs/channels/imessage) (legacy imsg), [Microsoft Teams](docs/channels/msteams) (extension), [Matrix](docs/channels/matrix) (extension), [Zalo](docs/channels/zalo) (extension), [Zalo Personal](docs/channels/zalouser) (extension), [WebChat](docs/web/webchat).
- [Group routing](docs/concepts/group-messages): mention gating, reply tags, per-channel chunking and routing. Channel rules: [Channels](docs/channels).

### Apps + nodes

- [macOS app](docs/platforms/macos): menu bar control plane, [Voice Wake](docs/nodes/voicewake)/PTT, [Talk Mode](docs/nodes/talk) overlay, [WebChat](docs/web/webchat), debug tools, [remote gateway](docs/gateway/remote) control.
- [iOS node](docs/platforms/ios): [Canvas](docs/platforms/mac/canvas), [Voice Wake](docs/nodes/voicewake), [Talk Mode](docs/nodes/talk), camera, screen recording, Bonjour pairing.
- [Android node](docs/platforms/android): [Canvas](docs/platforms/mac/canvas), [Talk Mode](docs/nodes/talk), camera, screen recording, optional SMS.
- [macOS node mode](docs/nodes): system.run/notify + canvas/camera exposure.

### Tools + automation

- [Browser control](docs/tools/browser): dedicated autolab Chrome/Chromium, snapshots, actions, uploads, profiles.
- [Canvas](docs/platforms/mac/canvas): [A2UI](docs/platforms/mac/canvas#canvas-a2ui) push/reset, eval, snapshot.
- [Nodes](docs/nodes): camera snap/clip, screen record, [location.get](docs/nodes/location-command), notifications.
- [Cron + wakeups](docs/automation/cron-jobs); [webhooks](docs/automation/webhook); [Gmail Pub/Sub](docs/automation/gmail-pubsub).
- [Skills platform](docs/tools/skills): bundled, managed, and workspace skills with install gating + UI.

### Runtime + safety

- [Channel routing](docs/concepts/channel-routing), [retry policy](docs/concepts/retry), and [streaming/chunking](docs/concepts/streaming).
- [Presence](docs/concepts/presence), [typing indicators](docs/concepts/typing-indicators), and [usage tracking](docs/concepts/usage-tracking).
- [Models](docs/concepts/models), [model failover](docs/concepts/model-failover), and [session pruning](docs/concepts/session-pruning).
- [Security](docs/gateway/security) and [troubleshooting](docs/channels/troubleshooting).

### Ops + packaging

- [Control UI](docs/web) + [WebChat](docs/web/webchat) served directly from the Gateway.
- [Tailscale Serve/Funnel](docs/gateway/tailscale) or [SSH tunnels](docs/gateway/remote) with token/password auth.
- [Nix mode](docs/install/nix) for declarative config; [Docker](docs/install/docker)-based installs.
- [Doctor](docs/gateway/doctor) migrations, [logging](docs/logging).

## How it works (short)

```
WhatsApp / Telegram / Slack / Discord / Google Chat / Signal / iMessage / BlueBubbles / Microsoft Teams / Matrix / Zalo / Zalo Personal / WebChat
               │
               ▼
┌───────────────────────────────┐
│            Gateway            │
│       (control plane)         │
│     ws://127.0.0.1:18789      │
└──────────────┬────────────────┘
               │
               ├─ Pi agent (RPC)
               ├─ CLI (autolab …)
               ├─ WebChat UI
               ├─ macOS app
               └─ iOS / Android nodes
```

## Key subsystems

- **[Gateway WebSocket network](docs/concepts/architecture)** — single WS control plane for clients, tools, and events (plus ops: [Gateway runbook](docs/gateway)).
- **[Tailscale exposure](docs/gateway/tailscale)** — Serve/Funnel for the Gateway dashboard + WS (remote access: [Remote](docs/gateway/remote)).
- **[Browser control](docs/tools/browser)** — autolab‑managed Chrome/Chromium with CDP control.
- **[Canvas + A2UI](docs/platforms/mac/canvas)** — agent‑driven visual workspace (A2UI host: [Canvas/A2UI](docs/platforms/mac/canvas#canvas-a2ui)).
- **[Voice Wake](docs/nodes/voicewake) + [Talk Mode](docs/nodes/talk)** — always‑on speech and continuous conversation.
- **[Nodes](docs/nodes)** — Canvas, camera snap/clip, screen record, `location.get`, notifications, plus macOS‑only `system.run`/`system.notify`.

## Tailscale access (Gateway dashboard)

AutoLab can auto-configure Tailscale **Serve** (tailnet-only) or **Funnel** (public) while the Gateway stays bound to loopback. Configure `gateway.tailscale.mode`:

- `off`: no Tailscale automation (default).
- `serve`: tailnet-only HTTPS via `tailscale serve` (uses Tailscale identity headers by default).
- `funnel`: public HTTPS via `tailscale funnel` (requires shared password auth).

Notes:

- `gateway.bind` must stay `loopback` when Serve/Funnel is enabled (AutoLab enforces this).
- Serve can be forced to require a password by setting `gateway.auth.mode: "password"` or `gateway.auth.allowTailscale: false`.
- Funnel refuses to start unless `gateway.auth.mode: "password"` is set.
- Optional: `gateway.tailscale.resetOnExit` to undo Serve/Funnel on shutdown.

Details: [Tailscale guide](docs/gateway/tailscale) · [Web surfaces](docs/web)

## Remote Gateway (Linux is great)

It’s perfectly fine to run the Gateway on a small Linux instance. Clients (macOS app, CLI, WebChat) can connect over **Tailscale Serve/Funnel** or **SSH tunnels**, and you can still pair device nodes (macOS/iOS/Android) to execute device‑local actions when needed.

- **Gateway host** runs the exec tool and channel connections by default.
- **Device nodes** run device‑local actions (`system.run`, camera, screen recording, notifications) via `node.invoke`.
  In short: exec runs where the Gateway lives; device actions run where the device lives.

Details: [Remote access](docs/gateway/remote) · [Nodes](docs/nodes) · [Security](docs/gateway/security)

## macOS permissions via the Gateway protocol

The macOS app can run in **node mode** and advertises its capabilities + permission map over the Gateway WebSocket (`node.list` / `node.describe`). Clients can then execute local actions via `node.invoke`:

- `system.run` runs a local command and returns stdout/stderr/exit code; set `needsScreenRecording: true` to require screen-recording permission (otherwise you’ll get `PERMISSION_MISSING`).
- `system.notify` posts a user notification and fails if notifications are denied.
- `canvas.*`, `camera.*`, `screen.record`, and `location.get` are also routed via `node.invoke` and follow TCC permission status.

Elevated bash (host permissions) is separate from macOS TCC:

- Use `/elevated on|off` to toggle per‑session elevated access when enabled + allowlisted.
- Gateway persists the per‑session toggle via `sessions.patch` (WS method) alongside `thinkingLevel`, `verboseLevel`, `model`, `sendPolicy`, and `groupActivation`.

Details: [Nodes](docs/nodes) · [macOS app](docs/platforms/macos) · [Gateway protocol](docs/concepts/architecture)

## Agent to Agent (sessions\_\* tools)

- Use these to coordinate work across sessions without jumping between chat surfaces.
- `sessions_list` — discover active sessions (agents) and their metadata.
- `sessions_history` — fetch transcript logs for a session.
- `sessions_send` — message another session; optional reply‑back ping‑pong + announce step (`REPLY_SKIP`, `ANNOUNCE_SKIP`).

Details: [Session tools](docs/concepts/session-tool)

## Skills registry (ClawHub)

ClawHub is a minimal skill registry. With ClawHub enabled, the agent can search for skills automatically and pull in new ones as needed.



## Chat commands

Send these in WhatsApp/Telegram/Slack/Google Chat/Microsoft Teams/WebChat (group commands are owner-only):

- `/status` — compact session status (model + tokens, cost when available)
- `/new` or `/reset` — reset the session
- `/compact` — compact session context (summary)
- `/think <level>` — off|minimal|low|medium|high|xhigh (GPT-5.2 + Codex models only)
- `/verbose on|off`
- `/usage off|tokens|full` — per-response usage footer
- `/restart` — restart the gateway (owner-only in groups)
- `/activation mention|always` — group activation toggle (groups only)

## Apps (optional)

The Gateway alone delivers a great experience. All apps are optional and add extra features.

If you plan to build/run companion apps, follow the platform runbooks below.

### macOS (AutoLab.app) (optional)

- Menu bar control for the Gateway and health.
- Voice Wake + push-to-talk overlay.
- WebChat + debug tools.
- Remote gateway control over SSH.

Note: signed builds required for macOS permissions to stick across rebuilds (see `docs/mac/permissions.md`).

### iOS node (optional)

- Pairs as a node via the Bridge.
- Voice trigger forwarding + Canvas surface.
- Controlled via `autolab nodes …`.

Runbook: [iOS connect](docs/platforms/ios).

### Android node (optional)

- Pairs via the same Bridge + pairing flow as iOS.
- Exposes Canvas, Camera, and Screen capture commands.
- Runbook: [Android connect](docs/platforms/android).

## Agent workspace + skills

- Workspace root: `~/.autolab/workspace` (configurable via `agents.defaults.workspace`).
- Injected prompt files: `AGENTS.md`, `SOUL.md`, `TOOLS.md`.
- Skills: `~/.autolab/workspace/skills/<skill>/SKILL.md`.

## Configuration

Minimal `~/.dvallier-ai/autolab-public.json` (model + defaults):

```json5
{
  agent: {
    model: "anthropic/claude-opus-4-6",
  },
}
```

[Full configuration reference (all keys + examples).](docs/gateway/configuration)

## Security model (important)

- **Default:** tools run on the host for the **main** session, so the agent has full access when it’s just you.
- **Group/channel safety:** set `agents.defaults.sandbox.mode: "non-main"` to run **non‑main sessions** (groups/channels) inside per‑session Docker sandboxes; bash then runs in Docker for those sessions.
- **Sandbox defaults:** allowlist `bash`, `process`, `read`, `write`, `edit`, `sessions_list`, `sessions_history`, `sessions_send`, `sessions_spawn`; denylist `browser`, `canvas`, `nodes`, `cron`, `discord`, `gateway`.

Details: [Security guide](docs/gateway/security) · [Docker + sandboxing](docs/install/docker) · [Sandbox config](docs/gateway/configuration)

### [WhatsApp](docs/channels/whatsapp)

- Link the device: `pnpm autolab channels login` (stores creds in `~/.autolab/credentials`).
- Allowlist who can talk to the assistant via `channels.whatsapp.allowFrom`.
- If `channels.whatsapp.groups` is set, it becomes a group allowlist; include `"*"` to allow all.

### [Telegram](docs/channels/telegram)

- Set `TELEGRAM_BOT_TOKEN` or `channels.telegram.botToken` (env wins).
- Optional: set `channels.telegram.groups` (with `channels.telegram.groups."*".requireMention`); when set, it is a group allowlist (include `"*"` to allow all). Also `channels.telegram.allowFrom` or `channels.telegram.webhookUrl` + `channels.telegram.webhookSecret` as needed.

```json5
{
  channels: {
    telegram: {
      botToken: "123456:ABCDEF",
    },
  },
}
```

### [Slack](docs/channels/slack)

- Set `SLACK_BOT_TOKEN` + `SLACK_APP_TOKEN` (or `channels.slack.botToken` + `channels.slack.appToken`).

### [Discord](docs/channels/discord)

- Set `DISCORD_BOT_TOKEN` or `channels.discord.token` (env wins).
- Optional: set `commands.native`, `commands.text`, or `commands.useAccessGroups`, plus `channels.discord.allowFrom`, `channels.discord.guilds`, or `channels.discord.mediaMaxMb` as needed.

```json5
{
  channels: {
    discord: {
      token: "1234abcd",
    },
  },
}
```

### [Signal](docs/channels/signal)

- Requires `signal-cli` and a `channels.signal` config section.

### [BlueBubbles (iMessage)](docs/channels/bluebubbles)

- **Recommended** iMessage integration.
- Configure `channels.bluebubbles.serverUrl` + `channels.bluebubbles.password` and a webhook (`channels.bluebubbles.webhookPath`).
- The BlueBubbles server runs on macOS; the Gateway can run on macOS or elsewhere.

### [iMessage (legacy)](docs/channels/imessage)

- Legacy macOS-only integration via `imsg` (Messages must be signed in).
- If `channels.imessage.groups` is set, it becomes a group allowlist; include `"*"` to allow all.

### [Microsoft Teams](docs/channels/msteams)

- Configure a Teams app + Bot Framework, then add a `msteams` config section.
- Allowlist who can talk via `msteams.allowFrom`; group access via `msteams.groupAllowFrom` or `msteams.groupPolicy: "open"`.

### [WebChat](docs/web/webchat)

- Uses the Gateway WebSocket; no separate WebChat port/config.

Browser control (optional):

```json5
{
  browser: {
    enabled: true,
    color: "#FF4500",
  },
}
```

## Docs

Use these when you’re past the onboarding flow and want the deeper reference.

- [Start with the docs index for navigation and “what’s where.”](docs/index.md)
- [Read the architecture overview for the gateway + protocol model.](docs/concepts/architecture)
- [Use the full configuration reference when you need every key and example.](docs/gateway/configuration)
- [Run the Gateway by the book with the operational runbook.](docs/gateway)
- [Learn how the Control UI/Web surfaces work and how to expose them safely.](docs/web)
- [Understand remote access over SSH tunnels or tailnets.](docs/gateway/remote)
- [Follow the onboarding wizard flow for a guided setup.](docs/start/wizard)
- [Wire external triggers via the webhook surface.](docs/automation/webhook)
- [Set up Gmail Pub/Sub triggers.](docs/automation/gmail-pubsub)
- [Learn the macOS menu bar companion details.](docs/platforms/mac/menu-bar)
- [Platform guides: Windows (WSL2)](docs/platforms/windows), [Linux](docs/platforms/linux), [macOS](docs/platforms/macos), [iOS](docs/platforms/ios), [Android](docs/platforms/android)
- [Debug common failures with the troubleshooting guide.](docs/channels/troubleshooting)
- [Review security guidance before exposing anything.](docs/gateway/security)

## Advanced docs (discovery + control)

- [Discovery + transports](docs/gateway/discovery)
- [Bonjour/mDNS](docs/gateway/bonjour)
- [Gateway pairing](docs/gateway/pairing)
- [Remote gateway README](docs/gateway/remote-gateway-readme)
- [Control UI](docs/web/control-ui)
- [Dashboard](docs/web/dashboard)

## Operations & troubleshooting

- [Health checks](docs/gateway/health)
- [Gateway lock](docs/gateway/gateway-lock)
- [Background process](docs/gateway/background-process)
- [Browser troubleshooting (Linux)](docs/tools/browser-linux-troubleshooting)
- [Logging](docs/logging)

## Deep dives

- [Agent loop](docs/concepts/agent-loop)
- [Presence](docs/concepts/presence)
- [TypeBox schemas](docs/concepts/typebox)
- [RPC adapters](docs/reference/rpc)
- [Queue](docs/concepts/queue)

## Workspace & skills

- [Skills config](docs/tools/skills-config)
- [Default AGENTS](docs/reference/AGENTS.default)
- [Templates: AGENTS](docs/reference/templates/AGENTS)
- [Templates: BOOTSTRAP](docs/reference/templates/BOOTSTRAP)
- [Templates: IDENTITY](docs/reference/templates/IDENTITY)
- [Templates: SOUL](docs/reference/templates/SOUL)
- [Templates: TOOLS](docs/reference/templates/TOOLS)
- [Templates: USER](docs/reference/templates/USER)

## Platform internals

- [macOS dev setup](docs/platforms/mac/dev-setup)
- [macOS menu bar](docs/platforms/mac/menu-bar)
- [macOS voice wake](docs/platforms/mac/voicewake)
- [iOS node](docs/platforms/ios)
- [Android node](docs/platforms/android)
- [Windows (WSL2)](docs/platforms/windows)
- [Linux app](docs/platforms/linux)

## Email hooks (Gmail)
