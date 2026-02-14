#!/bin/bash
# ASS Rebrand Script - Phase 1: Core MVP
# Converts AutoLab → ASS (Autonomous Support Structure)

set -e  # Exit on error

echo "🔧 ASS Rebrand Script - Phase 1: Core MVP"
echo "=========================================="

# Check we're in the right directory
if [ ! -f "package.json" ] || ! grep -q "autolab" package.json; then
    echo "❌ Error: Must run from ASS repo root (cloned from autolab/autolab)"
    exit 1
fi

echo ""
echo "📋 Backup original files..."
cp package.json package.json.autolab.bak
cp autolab.mjs autolab.mjs.bak
cp README.md README.md.autolab.bak

echo ""
echo "📦 Step 1: Update package.json..."
# Update package.json with ASS branding
cat package.json | \
  sed 's/"name": "autolab"/"name": "@danv-intel\/ass"/' | \
  sed 's/"autolab": "autolab.mjs"/"ass": "ass.mjs"/' | \
  sed 's/Multi-channel AI gateway with extensible messaging integrations/Autonomous Support Structure - AI agent framework for Intel validation/' \
  > package.json.tmp && mv package.json.tmp package.json

echo "   ✅ package.json updated"

echo ""
echo "📝 Step 2: Rename CLI entry point..."
mv autolab.mjs ass.mjs
echo "   ✅ autolab.mjs → ass.mjs"

echo ""
echo "📄 Step 3: Update README.md..."
# Create new README with ASS branding
cat > README.md << 'EOF'
# ASS (Autonomous Support Structure) ⚙️

**Autonomous Support Structure** - Multi-agent AI framework for Intel validation and infrastructure automation.

Forked from [AutoLab](https://github.com/autolab/autolab) with customizations for Intel workflows.

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

Built on the AutoLab foundation, customized for Intel's validation lab environment.

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
- `docs/` - Original AutoLab documentation (being updated)
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

## Migration from AutoLab

If you have existing AutoLab configs:

```bash
# Backup original
cp -r ~/.autolab ~/.autolab.backup

# ASS will use ~/.ass/
# You can manually copy configs if needed
cp ~/.autolab/autolab.json ~/.ass/ass.json
```

Both can coexist during transition.

---

## Attribution

**Based on AutoLab**  
https://github.com/autolab/autolab  
Licensed under MIT License

ASS maintains full compatibility with AutoLab core while adding Intel-specific customizations.

---

## License

MIT License (same as AutoLab)

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
echo "   Searching for 'autolab' references in source..."

# Count references (for info only)
TOTAL_REFS=$(grep -r "autolab" --exclude-dir=node_modules --exclude-dir=.git --exclude="*.bak" --exclude="REBRAND-PLAN.md" . 2>/dev/null | wc -l)
echo "   Found $TOTAL_REFS references to 'autolab' in source"
echo "   (These will be updated in Phase 2)"

echo ""
echo "✅ Phase 1 Complete!"
echo ""
echo "📋 What Changed:"
echo "   • package.json: name → @danv-intel/ass"
echo "   • package.json: bin → ass"
echo "   • autolab.mjs → ass.mjs"
echo "   • README.md → ASS branding"
echo ""
echo "📋 Next Steps:"
echo "   1. Review changes: git diff"
echo "   2. Test build: pnpm install && pnpm build"
echo "   3. Test CLI: npm link && ass --version"
echo "   4. If working: git add . && git commit -m 'Rebrand: AutoLab → ASS (Phase 1 MVP)'"
echo "   5. Push: git push origin main"
echo ""
echo "   Backups saved as *.autolab.bak"
echo ""
echo "🔧 To continue rebrand, run Phase 2 script (config paths + source cleanup)"
