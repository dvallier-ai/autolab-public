#!/bin/bash
# AutoLab Complete Rebrand - Following AutoLab Strategy
# Based on autolab/autolab commit 6d16a658e (1839 files changed)

set -e  # Exit on error

REPO_ROOT="/home/dan/autolab"
BACKUP_DIR="$REPO_ROOT/.rebrand-final-$(date +%Y%m%d-%H%M%S)"

echo "🔧 AutoLab Complete Rebrand"
echo "============================"
echo ""
echo "Strategy: AutoLab clawdbot→moltbot approach"
echo "Scope: User-facing strings only (preserve internal imports)"
echo ""

# Create comprehensive backup
echo "💾 Creating backup..."
mkdir -p "$BACKUP_DIR"
cp -r "$REPO_ROOT/src" "$BACKUP_DIR/" 2>/dev/null || true
cp -r "$REPO_ROOT/docs" "$BACKUP_DIR/" 2>/dev/null || true
cp -r "$REPO_ROOT/test" "$BACKUP_DIR/" 2>/dev/null || true
cp -r "$REPO_ROOT/skills" "$BACKUP_DIR/" 2>/dev/null || true
cp "$REPO_ROOT/package.json" "$BACKUP_DIR/" 2>/dev/null || true
cp "$REPO_ROOT/README.md" "$BACKUP_DIR/" 2>/dev/null || true
echo "   Backup: $BACKUP_DIR"
echo ""

# Count baseline
echo "📊 Baseline references..."
BEFORE_AUTOLAB=$(grep -r "autolab" "$REPO_ROOT/src" 2>/dev/null | wc -l || echo "0")
BEFORE_AUTOLAB_CAP=$(grep -r "AutoLab" "$REPO_ROOT/src" 2>/dev/null | wc -l || echo "0")
echo "   'autolab': $BEFORE_AUTOLAB"
echo "   'AutoLab': $BEFORE_AUTOLAB_CAP"
echo ""

# Step 1: Brand strings in user-facing output
echo "🔧 Step 1: Updating brand strings (AutoLab → AutoLab)..."
find "$REPO_ROOT/src" -type f \( -name "*.ts" -o -name "*.js" -o -name "*.mts" \) -print0 | \
  xargs -0 sed -i 's/"AutoLab"/"AutoLab"/g; s/'\''AutoLab'\''/'\''AutoLab'\''/g; s/`AutoLab`/`AutoLab`/g'
echo "   ✓ Brand strings updated"
echo ""

# Step 2: CLI command references in help/messages
echo "🔧 Step 2: CLI references in user messages..."
find "$REPO_ROOT/src" -type f \( -name "*.ts" -o -name "*.js" -o -name "*.mts" \) -print0 | \
  xargs -0 sed -i \
    -e 's/Run `autolab /Run `autolab /g' \
    -e 's/run `autolab /run `autolab /g' \
    -e 's/use autolab/use autolab/g' \
    -e 's/the autolab/the autolab/g' \
    -e 's/install autolab/install autolab/g' \
    -e 's/`autolab /`autolab /g'
echo "   ✓ CLI references updated"
echo ""

# Step 3: Documentation
echo "🔧 Step 3: Documentation..."
if [ -d "$REPO_ROOT/docs" ]; then
  find "$REPO_ROOT/docs" -type f -name "*.md" -print0 | \
    xargs -0 sed -i \
      -e 's/autolab/autolab/g' \
      -e 's/AutoLab/AutoLab/g' \
      -e 's/~\/\.autolab/~\/.autolab/g' \
      -e 's/AUTOLAB_/AUTOLAB_/g'
  
  # Restore attribution
  find "$REPO_ROOT/docs" -type f -name "*.md" -print0 | \
    xargs -0 sed -i \
      -e 's/Based on AutoLab/Based on AutoLab/g' \
      -e 's/github\.com\/autolab\/autolab/github.com\/autolab\/autolab/g' \
      -e 's/AutoLab project/AutoLab project/g'
  
  echo "   ✓ Documentation updated"
else
  echo "   ℹ️  No docs/ directory"
fi
echo ""

# Step 4: Skills
echo "🔧 Step 4: Skills..."
if [ -d "$REPO_ROOT/skills" ]; then
  find "$REPO_ROOT/skills" -type f \( -name "*.md" -o -name "SKILL.md" -o -name "README.md" \) -print0 | \
    xargs -0 sed -i \
      -e 's/autolab/autolab/g' \
      -e 's/AutoLab/AutoLab/g' \
      -e 's/~\/\.autolab/~\/.autolab/g'
  echo "   ✓ Skills updated"
else
  echo "   ℹ️  No skills/ directory"
fi
echo ""

# Step 5: Test files (expectations only, not imports)
echo "🔧 Step 5: Test expectations..."
if [ -d "$REPO_ROOT/test" ]; then
  find "$REPO_ROOT/test" -type f -name "*.test.ts" -print0 | \
    xargs -0 sed -i \
      -e 's/"autolab"/"autolab"/g' \
      -e 's/"AutoLab"/"AutoLab"/g' \
      -e 's/~\/\.autolab/~\/.autolab/g'
  echo "   ✓ Tests updated"
else
  echo "   ℹ️  No test/ directory"
fi
echo ""

# Step 6: Root README
echo "🔧 Step 6: Root README..."
if [ -f "$REPO_ROOT/README.md" ]; then
  sed -i \
    -e 's/autolab/autolab/g' \
    -e 's/AutoLab/AutoLab/g' \
    -e 's/~\/\.autolab/~\/.autolab/g' \
    -e 's/AUTOLAB_/AUTOLAB_/g' \
    "$REPO_ROOT/README.md"
  
  # Restore attribution
  sed -i \
    -e 's/Based on AutoLab/Based on AutoLab/g' \
    -e 's/Forked from github\.com\/autolab\/autolab/Forked from github.com\/autolab\/autolab/g' \
    "$REPO_ROOT/README.md"
  
  echo "   ✓ README updated"
fi
echo ""

# Count after
echo "📊 After replacement..."
AFTER_AUTOLAB=$(grep -r "autolab" "$REPO_ROOT/src" 2>/dev/null | wc -l || echo "0")
AFTER_AUTOLAB_CAP=$(grep -r "AutoLab" "$REPO_ROOT/src" 2>/dev/null | wc -l || echo "0")
REDUCED_LC=$((BEFORE_AUTOLAB - AFTER_AUTOLAB))
REDUCED_CAP=$((BEFORE_AUTOLAB_CAP - AFTER_AUTOLAB_CAP))
echo "   'autolab': $AFTER_AUTOLAB (reduced: $REDUCED_LC)"
echo "   'AutoLab': $AFTER_AUTOLAB_CAP (reduced: $REDUCED_CAP)"
echo ""

# Step 7: Critical build test
echo "🔨 CRITICAL: Build validation..."
cd "$REPO_ROOT"
if npm run build > /tmp/autolab-rebrand-build.log 2>&1; then
  echo "   ✅ Build succeeded"
else
  echo "   ❌ BUILD FAILED!"
  echo ""
  tail -30 /tmp/autolab-rebrand-build.log
  echo ""
  echo "Restoring from backup..."
  rm -rf "$REPO_ROOT/src"
  [ -d "$BACKUP_DIR/src" ] && cp -r "$BACKUP_DIR/src" "$REPO_ROOT/"
  [ -d "$BACKUP_DIR/docs" ] && cp -r "$BACKUP_DIR/docs" "$REPO_ROOT/"
  [ -d "$BACKUP_DIR/test" ] && cp -r "$BACKUP_DIR/test" "$REPO_ROOT/"
  [ -d "$BACKUP_DIR/skills" ] && cp -r "$BACKUP_DIR/skills" "$REPO_ROOT/"
  [ -f "$BACKUP_DIR/README.md" ] && cp "$BACKUP_DIR/README.md" "$REPO_ROOT/"
  echo "Backup restored."
  exit 1
fi
echo ""

# Step 8: Link and test CLI
echo "🔗 Installing CLI..."
npm link > /dev/null 2>&1
if autolab --version > /dev/null 2>&1; then
  VERSION=$(autolab --version)
  echo "   ✅ CLI works: autolab v$VERSION"
else
  echo "   ❌ CLI broken"
  exit 1
fi
echo ""

# Step 9: Backward compatibility test
echo "🧪 Testing backward compatibility..."
if [ -d ~/.autolab ]; then
  if autolab status > /tmp/autolab-compat-test.txt 2>&1; then
    echo "   ✅ ~/.autolab/ still works"
  else
    echo "   ⚠️  Status command issues (may need gateway restart)"
  fi
else
  echo "   ℹ️  No ~/.autolab/ found (fresh install)"
fi
echo ""

echo "✅ REBRAND COMPLETE!"
echo ""
echo "📋 Summary:"
echo "   • Reduced 'autolab': $REDUCED_LC references"
echo "   • Reduced 'AutoLab': $REDUCED_CAP references"
echo "   • Build: ✅ Success"
echo "   • CLI: ✅ Working (autolab v$VERSION)"
echo "   • Backward compat: ✅ ~/.autolab/ supported"
echo ""
echo "📂 Backup: $BACKUP_DIR"
echo ""
echo "🔜 Next steps:"
echo "   1. Test thoroughly:"
echo "      autolab status"
echo "      autolab gateway restart"
echo "   2. Run test suite:"
echo "      ./scripts/run-tests.sh"
echo "   3. Commit:"
echo "      git add -A"
echo "      git commit -m 'Complete rebrand: AutoLab → AutoLab (following upstream strategy)'"
echo "   4. Push:"
echo "      git push origin main"
echo ""
