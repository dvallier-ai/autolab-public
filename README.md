# ASS (Autonomous Support Structure) ⚙️

**Autonomous Support Structure** - Multi-agent AI framework for Intel validation and infrastructure automation.

Forked from [OpenClaw](https://github.com/openclaw/openclaw) with customizations for Intel workflows.

---

## Quick Start

```bash
# Install
npm install -g @danv-intel/ass

# Setup
ass wizard

# Check status
ass status

# Start gateway
ass gateway start
```

## What is ASS?

ASS (Autonomous Support Structure) is a multi-agent AI framework designed for:

- **Infrastructure automation** - Build and manage systems
- **Validation workflows** - Automated testing and QA
- **Agent collaboration** - Multiple specialized agents working together
- **Message board systems** - Training and knowledge sharing

Built on the OpenClaw foundation, customized for Intel's validation lab environment.

---

## Key Features

- 🤖 **Multi-agent system** - Ash, TestyTina, VigilantVick, Cipher
- 📋 **Training board** - Documentation and knowledge sharing
- 🔧 **Infrastructure tools** - Network mapping, dashboard integration
- 🧪 **QA automation** - Systematic testing and validation
- 🛡️ **Security management** - Policy enforcement and reviews

---

## Documentation

Full documentation coming soon. For now, see:

- `REBRAND-PLAN.md` - Rebrand strategy and plan
- `docs/` - Original OpenClaw documentation (being updated)
- `AGENTS.md` - Agent system overview

---

## Configuration

Config location: `~/.ass/`

Key files:
- `ass.json` - Main configuration
- `workspace/` - Agent workspaces
- `agents/` - Agent-specific configs
- `logs/` - Gateway logs

---

## Commands

```bash
ass wizard              # Interactive setup
ass status              # Show system status
ass gateway start       # Start gateway daemon
ass gateway stop        # Stop gateway
ass gateway restart     # Restart gateway
ass cron list           # List scheduled jobs
```

---

## Migration from OpenClaw

If you have existing OpenClaw configs:

```bash
# Backup original
cp -r ~/.openclaw ~/.openclaw.backup

# ASS will use ~/.ass/
# You can manually copy configs if needed
cp ~/.openclaw/openclaw.json ~/.ass/ass.json
```

Both can coexist during transition.

---

## Attribution

**Based on OpenClaw**  
https://github.com/openclaw/openclaw  
Licensed under MIT License

ASS maintains full compatibility with OpenClaw core while adding Intel-specific customizations.

---

## License

MIT License (same as OpenClaw)

See `LICENSE` file for details.

---

## Support

For issues or questions:
- GitHub: https://github.com/danv-intel/ass
- Internal: Contact Dan Vallier (Intel)

Built for Intel validation workflows. 🔧
