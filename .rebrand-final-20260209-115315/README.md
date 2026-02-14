# AutoLab

**AutoLab** - Automation framework for Intel validation lab workflows.

Forked from [AutoLab](https://github.com/autolab/autolab) with customizations for Intel validation environments.

---

## Quick Start

```bash
# Install
npm install -g @danv-intel/autolab

# Setup
autolab wizard

# Check status
autolab status

# Start gateway
autolab gateway start
```

## What is AutoLab?

AutoLab is a multi-agent AI automation framework designed for Intel validation labs:

- **Infrastructure automation** - Build and manage lab systems
- **Validation workflows** - Automated testing and QA
- **Agent collaboration** - Multiple specialized agents working together
- **Knowledge management** - Training boards and documentation

Built on the AutoLab foundation, customized for Intel's interoperability validation lab.

---

## Key Features

- 🤖 **Multi-agent system** - Ash, TestyTina, VigilantVick, Cipher
- 📋 **Training board** - Documentation and knowledge sharing
- 🔧 **Infrastructure tools** - Network mapping, dashboard integration
- 🧪 **QA automation** - Systematic testing and validation
- 🛡️ **Security management** - Policy enforcement and reviews

---

## Use Cases

**Validation Lab Automation:**

- Automated test execution
- Bug tracking and triage
- Network configuration management
- Dashboard and reporting

**Agent Collaboration:**

- QA agents review and test
- Security agents audit and approve
- Infrastructure agents build and deploy
- Coordination agents manage workflows

**Knowledge Management:**

- Training documentation system
- Peer review process
- Best practices library
- Incident post-mortems

---

## Documentation

- `docs/` - Full documentation (being updated from AutoLab)
- `AGENTS.md` - Agent system overview
- `REBRAND-PLAN.md` - Fork and customization strategy

---

## Configuration

Config location: `~/.autolab/` (migrating from `~/.autolab/`)

Key files:

- `autolab.json` - Main configuration
- `workspace/` - Agent workspaces
- `agents/` - Agent-specific configs
- `logs/` - Gateway logs

---

## Commands

```bash
autolab wizard              # Interactive setup
autolab status              # Show system status
autolab gateway start       # Start gateway daemon
autolab gateway stop        # Stop gateway
autolab gateway restart     # Restart gateway
autolab cron list           # List scheduled jobs
```

---

## Migration from AutoLab

If you have existing AutoLab configs:

```bash
# Backup original
cp -r ~/.autolab ~/.autolab.backup

# AutoLab will create ~/.autolab/
# You can manually copy configs if needed
```

Both can coexist during transition.

---

## Attribution

**Based on AutoLab**  
https://github.com/autolab/autolab  
Licensed under MIT License

AutoLab maintains compatibility with AutoLab core while adding Intel validation-specific features.

---

## Architecture

**Multi-Agent System:**

- **Ash** - Infrastructure & system builder
- **TestyTina** - QA specialist & testing
- **VigilantVick** - Security manager
- **Cipher** - Network & coordination

**Training Board:**

- Peer-reviewed training documentation
- 3×100% approval process
- Version controlled knowledge base

**Message Integration:**

- WhatsApp, Telegram, Discord, Signal
- Cross-platform agent communication
- Unified dashboard

---

## Intel Lab Integration

AutoLab is designed for Intel's high-speed Ethernet validation lab:

- **Network testing** - 1G to 800G+ Ethernet
- **Bug reproduction** - Automated issue replication
- **Fix verification** - Post-patch validation
- **Interoperability** - Multi-vendor testing

Integrates with existing INOP Tool Suite (dashboard, network mapper).

---

## License

MIT License (same as AutoLab)

See `LICENSE` file for details.

---

## Support

For issues or questions:

- GitHub: https://github.com/danv-intel/autolab (private)
- Internal: Contact Dan Vallier (Intel Validation Engineer)

Built for Intel validation workflows. 🔬
