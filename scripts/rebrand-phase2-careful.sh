#!/bin/bash
# AutoLab Phase 2.1: Careful Config Path Migration
# Only changes user-facing config paths, not internal module names

set -e

REPO_ROOT="/home/dan/autolab"

echo "🔧 AutoLab Phase 2.1: Smart Config Path Migration"
echo "=================================================="
echo ""

# Backup
BACKUP_DIR="$REPO_ROOT/.rebrand-backup-careful-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r "$REPO_ROOT/src" "$BACKUP_DIR/"
echo "💾 Backup: $BACKUP_DIR"
echo ""

# Strategy: Only update user-facing config paths
# Keep internal module names as-is to avoid breaking imports

echo "🔧 Updating user-facing config paths..."
echo ""

# 1. Update home directory paths (~/.openclaw → ~/.autolab)
echo "Step 1: Home directory references..."
find "$REPO_ROOT/src" -type f \( -name "*.ts" -o -name "*.js" \) -print0 | while IFS= read -r -d '' file; do
    # Only replace home directory paths, not module paths
    sed -i 's|~/\.openclaw|~/.autolab|g' "$file"
    sed -i 's|process\.env\.HOME.*\.openclaw|process.env.HOME + "/.autolab"|g' "$file"
    sed -i 's|homedir().*\.openclaw|homedir() + "/.autolab"|g' "$file"
done
echo "   ✓ Home directory paths updated"
echo ""

# 2. Update config file name in user messages/output
echo "Step 2: User-facing config file references..."
find "$REPO_ROOT/src" -type f \( -name "*.ts" -o -name "*.js" \) -print0 | while IFS= read -r -d '' file; do
    # Only in user-facing strings (in quotes)
    sed -i 's|"openclaw\.json"|"autolab.json"|g' "$file"
    sed -i "s|'openclaw\.json'|'autolab.json'|g" "$file"
    sed -i 's|`openclaw\.json`|`autolab.json`|g' "$file"
done
echo "   ✓ Config file name updated in strings"
echo ""

# 3. Update brand strings in output
echo "Step 3: Brand strings in user output..."
find "$REPO_ROOT/src" -type f \( -name "*.ts" -o -name "*.js" \) -print0 | while IFS= read -r -d '' file; do
    # Replace "OpenClaw" in user-facing strings (but not code/imports)
    sed -i 's|"OpenClaw|"AutoLab|g' "$file"
    sed -i "s|'OpenClaw|'AutoLab|g" "$file"
done
echo "   ✓ Brand strings updated"
echo ""

# 4. Build and test
echo "🔨 Testing build..."
cd "$REPO_ROOT"
if npm run build > /tmp/autolab-careful-build.log 2>&1; then
    echo "   ✅ Build succeeded"
else
    echo "   ❌ Build failed"
    cat /tmp/autolab-careful-build.log | tail -20
    echo ""
    echo "Restoring backup..."
    rm -rf "$REPO_ROOT/src"
    cp -r "$BACKUP_DIR/src" "$REPO_ROOT/"
    exit 1
fi

echo ""
echo "✅ Careful migration complete!"
echo ""
echo "Changes made:"
echo "  • ~/.openclaw → ~/.autolab (user paths)"
echo "  • Config strings updated (user-facing)"
echo "  • Brand strings updated (OpenClaw → AutoLab)"
echo "  • Module imports PRESERVED (no breakage)"
echo ""
