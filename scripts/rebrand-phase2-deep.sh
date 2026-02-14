#!/bin/bash
# AutoLab Complete Rebrand - Phase 2: Deep Source Cleanup
# Renames all "autolab" references to "autolab" with validation

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔧 AutoLab Phase 2: Deep Source Rebrand + Validation"
echo "======================================================"
echo ""
echo "📍 Repository: $REPO_ROOT"
echo ""

# Safety check
if [ ! -f "$REPO_ROOT/package.json" ]; then
    echo "❌ Error: Not in AutoLab repository root"
    exit 1
fi

# Check we're in autolab, not autolab
if ! grep -q "@danv-intel/autolab" "$REPO_ROOT/package.json"; then
    echo "❌ Error: package.json doesn't show AutoLab. Run Phase 1 first."
    exit 1
fi

echo "✅ Pre-flight checks passed"
echo ""

# Create backup
echo "💾 Creating backup..."
BACKUP_DIR="$REPO_ROOT/.rebrand-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r "$REPO_ROOT/src" "$BACKUP_DIR/"
cp -r "$REPO_ROOT/docs" "$BACKUP_DIR/" 2>/dev/null || true
echo "   Backup: $BACKUP_DIR"
echo ""

# Test 1: Record baseline
echo "📊 Test 1: Recording baseline state..."
BEFORE_COUNT=$(grep -r "autolab" "$REPO_ROOT/src" --exclude-dir=node_modules 2>/dev/null | wc -l || echo "0")
echo "   Found $BEFORE_COUNT 'autolab' references in src/"
echo ""

# Step 1: Update config paths in source
echo "🔧 Step 1: Update config paths (.autolab → .autolab)..."

# Find files with .autolab references
FILES_TO_UPDATE=$(grep -rl "\.autolab" "$REPO_ROOT/src" --exclude-dir=node_modules 2>/dev/null || true)

if [ -n "$FILES_TO_UPDATE" ]; then
    echo "$FILES_TO_UPDATE" | while read -r file; do
        if [ -f "$file" ]; then
            # Replace .autolab with .autolab
            sed -i 's/\.autolab/.autolab/g' "$file"
            echo "   ✓ Updated: $(basename $file)"
        fi
    done
else
    echo "   ℹ️  No .autolab paths found in src/"
fi

echo ""

# Step 2: Update autolab.json references
echo "🔧 Step 2: Update config file references (autolab.json → autolab.json)..."

FILES_WITH_CONFIG=$(grep -rl "autolab\.json" "$REPO_ROOT/src" --exclude-dir=node_modules 2>/dev/null || true)

if [ -n "$FILES_WITH_CONFIG" ]; then
    echo "$FILES_WITH_CONFIG" | while read -r file; do
        if [ -f "$file" ]; then
            sed -i 's/autolab\.json/autolab.json/g' "$file"
            echo "   ✓ Updated: $(basename $file)"
        fi
    done
else
    echo "   ℹ️  No autolab.json references found"
fi

echo ""

# Step 3: Update CLI command references
echo "🔧 Step 3: Update CLI command references..."

# Update 'autolab' command references (but keep careful not to break imports)
# Only update in help text, messages, documentation strings

FILES_WITH_CLI=$(grep -rl "autolab" "$REPO_ROOT/src" --exclude-dir=node_modules --include="*.ts" --include="*.js" 2>/dev/null || true)

if [ -n "$FILES_WITH_CLI" ]; then
    echo "   Found files with 'autolab' references"
    echo "   Manual review required for CLI references"
    echo "   (Automated replacement too risky for code logic)"
fi

echo ""

# Test 2: Check reduction
echo "📊 Test 2: Measuring reduction..."
AFTER_COUNT=$(grep -r "autolab" "$REPO_ROOT/src" --exclude-dir=node_modules 2>/dev/null | wc -l || echo "0")
REDUCED=$((BEFORE_COUNT - AFTER_COUNT))
echo "   Before: $BEFORE_COUNT references"
echo "   After:  $AFTER_COUNT references"
echo "   Reduced: $REDUCED references"
echo ""

# Test 3: Build validation
echo "🔨 Test 3: Build validation..."
cd "$REPO_ROOT"
if npm run build > /tmp/autolab-build.log 2>&1; then
    echo "   ✅ Build succeeded"
else
    echo "   ❌ Build failed! Check /tmp/autolab-build.log"
    echo "   Restoring from backup..."
    rm -rf "$REPO_ROOT/src"
    cp -r "$BACKUP_DIR/src" "$REPO_ROOT/"
    echo "   Backup restored. Exiting."
    exit 1
fi
echo ""

# Test 4: Package.json validation
echo "📦 Test 4: Package.json validation..."
if jq -e '.name == "@danv-intel/autolab"' "$REPO_ROOT/package.json" > /dev/null; then
    echo "   ✅ Package name correct"
else
    echo "   ❌ Package name incorrect"
    exit 1
fi

if jq -e '.bin.autolab' "$REPO_ROOT/package.json" > /dev/null; then
    echo "   ✅ Binary name correct"
else
    echo "   ❌ Binary name missing"
    exit 1
fi
echo ""

# Test 5: CLI installation
echo "🔗 Test 5: CLI installation..."
if npm link > /tmp/autolab-link.log 2>&1; then
    echo "   ✅ npm link succeeded"
else
    echo "   ❌ npm link failed"
    exit 1
fi
echo ""

# Test 6: CLI execution
echo "▶️  Test 6: CLI execution..."
if autolab --version > /dev/null 2>&1; then
    VERSION=$(autolab --version)
    echo "   ✅ CLI works: autolab v$VERSION"
else
    echo "   ❌ CLI doesn't execute"
    exit 1
fi
echo ""

# Test 7: Status command
echo "📊 Test 7: Status command..."
if autolab status --format json > /tmp/autolab-status.json 2>&1; then
    echo "   ✅ Status command works"
else
    echo "   ⚠️  Status command issues (may be normal if gateway offline)"
fi
echo ""

echo "✅ Phase 2 Complete!"
echo ""
echo "📋 Summary:"
echo "   • Config paths updated: .autolab → .autolab"
echo "   • Config files updated: autolab.json → autolab.json"
echo "   • Build validated: ✅"
echo "   • CLI installed: ✅"
echo "   • CLI execution: ✅"
echo "   • References reduced: $REDUCED"
echo ""
echo "⚠️  Note: Some 'autolab' references remain in:"
echo "   • Comments (intentional)"
echo "   • Backward compatibility code (intentional)"
echo "   • Import paths (safe to keep)"
echo ""
echo "📂 Backup location: $BACKUP_DIR"
echo ""
echo "🔜 Next: Run comprehensive test suite"
echo "   ./scripts/run-tests.sh"
