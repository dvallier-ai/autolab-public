#!/bin/bash
# ASS Rebrand Script - Phase 1: Core MVP
# Converts OpenClaw → ASS (Autonomous Support Structure)

set -e  # Exit on error

echo "🔧 ASS Rebrand Script - Phase 1: Core MVP"
echo "=========================================="

# Check we're in the right directory
if [ ! -f "package.json" ] || ! grep -q "openclaw" package.json; then
    echo "❌ Error: Must run from ASS repo root (cloned from openclaw/openclaw)"
    exit 1
fi

echo ""
echo "📋 Backup original files..."
cp package.json package.json.openclaw.bak
cp openclaw.mjs openclaw.mjs.bak
cp README.md README.md.openclaw.bak

echo ""
echo "📦 Step 1: Update package.json..."
# Update package.json with ASS branding
cat package.json | \
  sed 's/"name": "openclaw"/"name": "@danv-intel\/ass"/' | \
  sed 's/"openclaw": "openclaw.mjs"/"ass": "ass.mjs"/' | \
  sed 's/Multi-channel AI gateway with extensible messaging integrations/Autonomous Support Structure - AI agent framework for Intel validation/' \
  > package.json.tmp && mv package.json.tmp package.json

echo "   ✅ package.json updated"

echo ""
echo "📝 Step 2: Rename CLI entry point..."
mv openclaw.mjs ass.mjs
echo "   ✅ openclaw.mjs → ass.mjs"

echo ""
echo "📄 Step 3: Update README.md..."
# Create new README with ASS branding
cat > README.md << 'EOF'
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
EOF

echo "   ✅ README.md updated with ASS branding"

echo ""
echo "🔍 Step 4: Find references to update..."
echo "   Searching for 'openclaw' references in source..."

# Count references (for info only)
TOTAL_REFS=$(grep -r "openclaw" --exclude-dir=node_modules --exclude-dir=.git --exclude="*.bak" --exclude="REBRAND-PLAN.md" . 2>/dev/null | wc -l)
echo "   Found $TOTAL_REFS references to 'openclaw' in source"
echo "   (These will be updated in Phase 2)"

echo ""
echo "✅ Phase 1 Complete!"
echo ""
echo "📋 What Changed:"
echo "   • package.json: name → @danv-intel/ass"
echo "   • package.json: bin → ass"
echo "   • openclaw.mjs → ass.mjs"
echo "   • README.md → ASS branding"
echo ""
echo "📋 Next Steps:"
echo "   1. Review changes: git diff"
echo "   2. Test build: pnpm install && pnpm build"
echo "   3. Test CLI: npm link && ass --version"
echo "   4. If working: git add . && git commit -m 'Rebrand: OpenClaw → ASS (Phase 1 MVP)'"
echo "   5. Push: git push origin main"
echo ""
echo "   Backups saved as *.openclaw.bak"
echo ""
echo "🔧 To continue rebrand, run Phase 2 script (config paths + source cleanup)"
