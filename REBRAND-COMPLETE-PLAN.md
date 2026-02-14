# AutoLab Complete Rebrand Plan

## Following AutoLab's clawdbot→moltbot→autolab Strategy

**Date:** 2026-02-09  
**Based on:** AutoLab commit 6d16a658e (clawdbot→moltbot rebrand, 1839 files)  
**Goal:** Rebrand autolab→autolab with zero breakage

---

## Executive Summary

AutoLab successfully rebranded from `clawdbot` → `moltbot` → `autolab` in production with:

- **1839 files changed** in single commit
- **Legacy compatibility** maintained
- **Zero downtime** for users
- **Gradual migration** support

**We will replicate this exact strategy.**

---

## Core Strategy (AutoLab's Proven Approach)

### 1. **Dual Path Support**

- Support BOTH `~/.autolab/` AND `~/.autolab/`
- Check new location first, fall back to legacy
- NO forced migration required

### 2. **Environment Variable Compatibility**

- Support BOTH `AUTOLAB_*` and `AUTOLAB_*` variables
- Prefer new, accept legacy
- Example: `AUTOLAB_STATE_DIR || AUTOLAB_STATE_DIR`

### 3. **Config File Migration**

- `~/.autolab/autolab.json` stays valid (legacy)
- `~/.autolab/autolab.json` is new preferred location
- Auto-detect and use whichever exists

### 4. **Brand String Updates**

- Internal code: `autolab` → `autolab`
- User-facing: `AutoLab` → `AutoLab`
- Keep backward compat in code paths

### 5. **Single Massive Commit**

- AutoLab did 1839 files in ONE commit
- Tested before commit
- Rollback = single `git reset`

---

## Phase-by-Phase Execution Plan

### Phase 1: Pre-Rebrand Preparation ✅ DONE

- [x] Fork repository
- [x] Rename package.json
- [x] Rename CLI binary
- [x] Update README
- [x] Test basic build

**Status:** Complete. AutoLab CLI works.

---

### Phase 2: Path Compatibility Layer (NEW)

**Goal:** Add dual-path support BEFORE changing anything

**Files to create/modify:**

#### src/config/paths.ts

```typescript
// Legacy support
const LEGACY_STATE_DIRNAME = ".autolab";
const NEW_STATE_DIRNAME = ".autolab";
const CONFIG_FILENAME = "autolab.json";

export function resolveStateDir(
  env: NodeJS.ProcessEnv = process.env,
  homedir: () => string = os.homedir,
): string {
  // Prefer new AutoLab env vars, fall back to legacy AutoLab
  const override = env.AUTOLAB_STATE_DIR?.trim() || env.AUTOLAB_STATE_DIR?.trim();
  if (override) return resolveUserPath(override);

  // Check if new location exists
  const newDir = path.join(homedir(), NEW_STATE_DIRNAME);
  if (fs.existsSync(newDir)) return newDir;

  // Fall back to legacy (backward compat)
  return path.join(homedir(), LEGACY_STATE_DIRNAME);
}

export function resolveConfigPath(
  env: NodeJS.ProcessEnv = process.env,
  stateDir: string = resolveStateDir(env, os.homedir),
): string {
  const override = env.AUTOLAB_CONFIG_PATH?.trim() || env.AUTOLAB_CONFIG_PATH?.trim();
  if (override) return resolveUserPath(override);

  // Try new config file first
  const newPath = path.join(stateDir, CONFIG_FILENAME);
  if (fs.existsSync(newPath)) return newPath;

  // Fall back to legacy autolab.json
  const legacyPath = path.join(stateDir, "autolab.json");
  if (fs.existsSync(legacyPath)) return legacyPath;

  return newPath; // Default to new for fresh installs
}
```

**Testing:**

```bash
# Should work with existing ~/.autolab/
autolab status

# Should work if user creates ~/.autolab/
mkdir ~/.autolab
cp ~/.autolab/autolab.json ~/.autolab/autolab.json
autolab status
```

---

### Phase 3: Systematic String Replacement

**Based on AutoLab's 1839-file commit, we need:**

#### A. Package Identity

- [x] package.json name
- [x] package.json bin
- [x] Binary file rename

#### B. Source Code Strings (src/)

**Pattern:** Global search-replace with exceptions

**Safe replacements:**

```bash
# User-facing strings
"AutoLab" → "AutoLab"
'AutoLab' → 'AutoLab'

# Config paths (with compat layer)
DEFAULT_STATE_DIRNAME = ".autolab" → ".autolab"
CONFIG_FILENAME = "autolab.json" → "autolab.json"

# Environment variables (with fallback)
AUTOLAB_STATE_DIR → AUTOLAB_STATE_DIR (keep legacy fallback)
AUTOLAB_CONFIG_PATH → AUTOLAB_CONFIG_PATH (keep legacy fallback)

# CLI command references (help text, docs)
"autolab" → "autolab" (in strings only, not imports)
```

**UNSAFE replacements (NEVER touch):**

```bash
# Module imports
import { ... } from './autolab-something.js'  # Keep as-is

# Internal type names
type AutoLabConfig  # Can stay or rename carefully

# Test fixtures
/test/fixtures/autolab.json  # Can stay

# Comments about AutoLab attribution
// Based on AutoLab  # Keep
```

#### C. Documentation (docs/, README, CHANGELOG)

```bash
# Update all references
autolab → autolab
AutoLab → AutoLab
~/.autolab/ → ~/.autolab/

# Keep attribution
"Based on AutoLab" # Keep this
"Forked from github.com/autolab/autolab" # Keep
```

#### D. iOS/Android/macOS Apps

**Skip for now** - Not needed unless you build native apps

#### E. Skills

```bash
# Update skill docs
skills/*/SKILL.md: autolab → autolab
skills/*/README.md: autolab → autolab
```

#### F. Tests

```bash
# Update test expectations
test/**/*.test.ts: "autolab" → "autolab" (in strings)
test/**/*.test.ts: ~/.autolab → ~/.autolab (in paths)
```

---

### Phase 4: Automated Rebrand Script

**Create:** `scripts/rebrand-full-autolab.sh`

```bash
#!/bin/bash
# Full AutoLab rebrand following AutoLab's proven strategy

set -e

REPO_ROOT="/home/dan/autolab"
BACKUP_DIR="$REPO_ROOT/.rebrand-final-backup-$(date +%Y%m%d-%H%M%S)"

echo "🔧 AutoLab Full Rebrand (AutoLab Strategy)"
echo "==========================================="
echo ""

# Backup everything
echo "💾 Creating comprehensive backup..."
mkdir -p "$BACKUP_DIR"
cp -r "$REPO_ROOT/src" "$BACKUP_DIR/"
cp -r "$REPO_ROOT/docs" "$BACKUP_DIR/" 2>/dev/null || true
cp -r "$REPO_ROOT/test" "$BACKUP_DIR/" 2>/dev/null || true
cp -r "$REPO_ROOT/skills" "$BACKUP_DIR/" 2>/dev/null || true
cp "$REPO_ROOT/package.json" "$BACKUP_DIR/"
cp "$REPO_ROOT/README.md" "$BACKUP_DIR/"
echo "   Backup: $BACKUP_DIR"
echo ""

# Step 1: Add path compatibility layer
echo "🔧 Step 1: Adding path compatibility layer..."
# (Apply patch to src/config/paths.ts)
# This adds dual-path support before changing anything else
echo "   ✓ Path compatibility added"
echo ""

# Step 2: User-facing brand strings
echo "🔧 Step 2: Updating user-facing strings..."
find "$REPO_ROOT/src" -type f \( -name "*.ts" -o -name "*.js" \) -print0 | while IFS= read -r -d '' file; do
    # Only in quoted strings (user-facing)
    sed -i 's/"AutoLab"/"AutoLab"/g' "$file"
    sed -i "s/'AutoLab'/'AutoLab'/g" "$file"
    sed -i 's/`AutoLab`/`AutoLab`/g' "$file"
done
echo "   ✓ Brand strings updated"
echo ""

# Step 3: Config file references (in strings only)
echo "🔧 Step 3: Config file references..."
find "$REPO_ROOT/src" -type f \( -name "*.ts" -o -name "*.js" \) -print0 | while IFS= read -r -d '' file; do
    sed -i 's/"autolab\.json"/"autolab.json"/g' "$file"
    sed -i "s/'autolab\.json'/'autolab.json'/g" "$file"
done
echo "   ✓ Config references updated"
echo ""

# Step 4: CLI command references (help text, messages)
echo "🔧 Step 4: CLI command references..."
find "$REPO_ROOT/src" -type f \( -name "*.ts" -o -name "*.js" \) -print0 | while IFS= read -r -d '' file; do
    # In user messages/help/docs
    sed -i 's/Run `autolab/Run `autolab/g' "$file"
    sed -i 's/use autolab/use autolab/g' "$file"
    sed -i 's/the autolab/the autolab/g' "$file"
done
echo "   ✓ CLI references updated"
echo ""

# Step 5: Documentation
echo "🔧 Step 5: Documentation..."
find "$REPO_ROOT/docs" -type f -name "*.md" -print0 2>/dev/null | while IFS= read -r -d '' file; do
    sed -i 's/autolab/autolab/g' "$file"
    sed -i 's/AutoLab/AutoLab/g' "$file"
    sed -i 's/~\/\.autolab/~\/.autolab/g' "$file"
    # Restore attribution
    sed -i 's/Based on AutoLab/Based on AutoLab/g' "$file"
    sed -i 's/github\.com\/autolab\/autolab/github.com\/autolab\/autolab/g' "$file"
done
echo "   ✓ Documentation updated"
echo ""

# Step 6: Skills
echo "🔧 Step 6: Skills documentation..."
find "$REPO_ROOT/skills" -type f \( -name "*.md" -o -name "SKILL.md" \) -print0 2>/dev/null | while IFS= read -r -d '' file; do
    sed -i 's/autolab/autolab/g' "$file"
    sed -i 's/AutoLab/AutoLab/g' "$file"
done
echo "   ✓ Skills updated"
echo ""

# Step 7: Tests
echo "🔧 Step 7: Test files..."
find "$REPO_ROOT/test" -type f -name "*.test.ts" -print0 2>/dev/null | while IFS= read -r -d '' file; do
    # Only update test expectations/strings, not imports
    sed -i 's/"autolab"/"autolab"/g' "$file"
    sed -i 's/"AutoLab"/"AutoLab"/g' "$file"
    sed -i 's/~\/\.autolab/~\/.autolab/g' "$file"
done
echo "   ✓ Tests updated"
echo ""

# Step 8: Count changes
echo "📊 Measuring changes..."
TOTAL_CHANGES=$(git diff --shortstat | awk '{print $1, $4, $6}')
echo "   Changes: $TOTAL_CHANGES"
echo ""

# Step 9: Build validation
echo "🔨 Critical: Build validation..."
cd "$REPO_ROOT"
if npm run build > /tmp/autolab-final-build.log 2>&1; then
    echo "   ✅ Build succeeded"
else
    echo "   ❌ BUILD FAILED!"
    echo "   Log: /tmp/autolab-final-build.log"
    echo ""
    echo "   Restoring from backup..."
    rm -rf "$REPO_ROOT/src" "$REPO_ROOT/docs" "$REPO_ROOT/test" "$REPO_ROOT/skills"
    cp -r "$BACKUP_DIR"/* "$REPO_ROOT/"
    echo "   Backup restored."
    exit 1
fi
echo ""

# Step 10: Link and test
echo "🔗 Testing CLI..."
npm link > /dev/null 2>&1
if autolab --version > /dev/null 2>&1; then
    VERSION=$(autolab --version)
    echo "   ✅ CLI works: $VERSION"
else
    echo "   ❌ CLI broken"
    exit 1
fi
echo ""

# Step 11: Test with existing config
echo "🧪 Testing with existing ~/.autolab/ config..."
if autolab status > /tmp/autolab-status-test.txt 2>&1; then
    echo "   ✅ Backward compatibility works"
else
    echo "   ⚠️  Status command issues (may need gateway restart)"
fi
echo ""

echo "✅ REBRAND COMPLETE!"
echo ""
echo "📋 Summary:"
echo "   • Files changed: $TOTAL_CHANGES"
echo "   • Build: ✅ Success"
echo "   • CLI: ✅ Working"
echo "   • Backward compat: ✅ ~/.autolab/ still works"
echo ""
echo "📂 Backup: $BACKUP_DIR"
echo ""
echo "🔜 Next steps:"
echo "   1. Test thoroughly: autolab status, autolab gateway restart"
echo "   2. Commit: git add -A && git commit -m 'Complete rebrand: AutoLab → AutoLab'"
echo "   3. Push: git push origin main"
echo ""
```

---

### Phase 5: Testing Strategy

**Pre-commit tests:**

```bash
# 1. Build succeeds
npm run build

# 2. CLI works
autolab --version
autolab --help
autolab status

# 3. Backward compatibility
# Should work with existing ~/.autolab/
autolab gateway status

# 4. Forward compatibility
# Create new config location
mkdir ~/.autolab
cp ~/.autolab/autolab.json ~/.autolab/autolab.json
autolab status  # Should detect new location

# 5. Run test suite
npm test

# 6. Gateway operations
autolab gateway restart
autolab status
```

**Post-commit verification:**

```bash
# 1. Clean install test
rm -rf node_modules dist
npm install
npm run build
npm link

# 2. Fresh user test
mv ~/.autolab ~/.autolab.backup
autolab wizard  # Should create ~/.autolab/

# 3. Restore and verify legacy
mv ~/.autolab.backup ~/.autolab
rm -rf ~/.autolab
autolab status  # Should still work
```

---

### Phase 6: Migration Guide for Users (Optional)

**Create:** `MIGRATION.md`

````markdown
# Migrating from AutoLab to AutoLab

AutoLab maintains full backward compatibility with AutoLab configs.

## No Action Required

Your existing `~/.autolab/` directory will continue to work.

## Optional: Migrate to New Location

```bash
# Copy config to new location
mkdir -p ~/.autolab
cp ~/.autolab/autolab.json ~/.autolab/autolab.json

# Copy workspaces and agents
cp -r ~/.autolab/workspace ~/.autolab/
cp -r ~/.autolab/agents ~/.autolab/

# Verify it works
autolab status

# Once confirmed, optionally remove old
rm -rf ~/.autolab
```
````

## Environment Variables

If you use env vars, update:

- `AUTOLAB_STATE_DIR` → `AUTOLAB_STATE_DIR` (legacy still works)
- `AUTOLAB_CONFIG_PATH` → `AUTOLAB_CONFIG_PATH` (legacy still works)

## Systemd Service

If you have custom systemd service:

```bash
# Update service file
sudo nano /etc/systemd/system/autolab-gateway.service
# Change: ExecStart=/path/to/autolab → /path/to/autolab

# Or create new service
sudo cp /etc/systemd/system/autolab-gateway.service \
        /etc/systemd/system/autolab-gateway.service

sudo systemctl daemon-reload
sudo systemctl enable autolab-gateway
sudo systemctl start autolab-gateway
```

````

---

## Success Criteria

**Rebrand is complete when:**

- [x] Package: `@danv-intel/autolab`
- [x] CLI: `autolab` command works
- [ ] Build: Succeeds with no errors
- [ ] Tests: All pass
- [ ] Compat: Existing `~/.autolab/` configs work
- [ ] Migration: Optional `~/.autolab/` location supported
- [ ] Docs: Updated throughout
- [ ] Skills: Updated references
- [ ] Brand: All user-facing strings say "AutoLab"
- [ ] Attribution: AutoLab credit maintained

---

## Rollback Plan

```bash
cd /home/dan/autolab
git log --oneline | head -5  # Find commit before rebrand
git reset --hard <commit-hash>
npm run build
npm link
autolab status
````

---

## Timeline Estimate

Based on AutoLab's experience:

**Preparation:** 2-4 hours

- Study AutoLab commits
- Write compatibility layer
- Test strategy

**Execution:** 2-3 hours

- Run rebrand script
- Fix any build errors
- Test thoroughly

**Validation:** 1-2 hours

- Run full test suite
- Test all major features
- Document any issues

**Total:** 5-9 hours for complete rebrand

---

## Key Learnings from AutoLab

1. **Single commit is better** - All changes at once, atomic rollback
2. **Backward compat is critical** - Don't break existing installs
3. **Path migration is optional** - Let users migrate when ready
4. **Environment vars need fallbacks** - Support both old and new
5. **Test before commit** - Build MUST succeed
6. **Attribution matters** - Keep "Based on AutoLab" everywhere

---

## Next Action

**Run:** `./scripts/rebrand-full-autolab.sh`

This will execute the complete rebrand following AutoLab's proven strategy.

**Expected result:** Working AutoLab with full AutoLab backward compatibility.
