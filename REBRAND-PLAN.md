# ASS (Autonomous Support Structure) Rebrand Plan

**Date:** 2026-02-09  
**From:** OpenClaw  
**To:** ASS (Autonomous Support Structure)  
**Repository:** https://github.com/danv-intel/ass  
**Upstream:** https://github.com/openclaw/openclaw

---

## Rebrand Scope

### Package Identity
- **Name:** `@danv-intel/ass` (scoped npm package)
- **CLI Command:** `ass`
- **Config Path:** `~/.ass/` (from `~/.openclaw/`)
- **Binary:** `ass` (from `openclaw`)

### What Changes
1. **Package.json** - name, bin, description
2. **CLI Entry** - `openclaw.mjs` → `ass.mjs`
3. **Documentation** - README, docs/, all references
4. **Config Paths** - All `~/.openclaw` → `~/.ass`
5. **Source Code** - String references to "openclaw"
6. **Branding** - Logo, colors, tagline

### What Stays Same
1. **Core functionality** - All features preserved
2. **MIT License** - With attribution to OpenClaw
3. **Git history** - Full history maintained
4. **Architecture** - No structural changes

---

## Implementation Steps

### Phase 1: Core Rebrand (MVP)

**Goal:** Working `ass` CLI that installs and runs

**Files to change:**
```
package.json          → name, bin, description
openclaw.mjs          → rename to ass.mjs
README.md             → rebrand header, description
docs/                 → update all references
src/                  → config paths, branding strings
```

**Testing:**
```bash
pnpm install
pnpm build
npm link
ass --version
ass status
```

### Phase 2: Config Migration

**Goal:** Seamlessly migrate existing `~/.openclaw` configs

**Create migration script:**
```bash
# ~/.ass/migrate-from-openclaw.sh
# Copies config, preserves both for safety
```

**Config paths to update:**
- `~/.openclaw/openclaw.json` → `~/.ass/ass.json`
- `~/.openclaw/workspace` → `~/.ass/workspace`
- `~/.openclaw/agents` → `~/.ass/agents`
- `~/.openclaw/logs` → `~/.ass/logs`

### Phase 3: Documentation Update

**Goal:** Complete docs rebrand

**Files:**
- `README.md` - Full rebrand
- `docs/*.md` - All references
- `AGENTS.md` - Update examples
- `CHANGELOG.md` - Add rebrand note

**Branding:**
- Logo/icon (if we create one)
- Tagline: "Autonomous Support Structure for AI Agents"
- Description: Emphasize autonomy, structure, support

### Phase 4: Source Code Cleanup

**Goal:** Remove all "openclaw" string references

**Search and replace:**
```bash
grep -r "openclaw" --exclude-dir=node_modules --exclude-dir=.git
grep -r "OpenClaw" --exclude-dir=node_modules --exclude-dir=.git
grep -r "open-claw" --exclude-dir=node_modules --exclude-dir=.git
```

**Replace patterns:**
- `openclaw` → `ass`
- `OpenClaw` → `ASS`
- `.openclaw` → `.ass`

### Phase 5: Upstream Sync Testing

**Goal:** Verify we can pull updates from openclaw/openclaw

**Test merge:**
```bash
git fetch upstream
git merge upstream/main --no-commit --no-ff
# Check conflicts (should be minimal in branded files)
git merge --abort
```

**Strategy for conflicts:**
- Keep ASS branding in: package.json, README, docs
- Take upstream changes in: src/, core functionality
- Manual merge: config paths, tests

---

## Detailed File Changes

### 1. package.json

```diff
- "name": "openclaw",
+ "name": "@danv-intel/ass",
- "description": "Multi-channel AI gateway with extensible messaging integrations",
+ "description": "Autonomous Support Structure - AI agent framework for Intel validation",
  "bin": {
-   "openclaw": "openclaw.mjs"
+   "ass": "ass.mjs"
  },
```

### 2. openclaw.mjs → ass.mjs

```bash
mv openclaw.mjs ass.mjs
# Update internal references
```

### 3. README.md

```diff
- # OpenClaw 🦞
+ # ASS (Autonomous Support Structure) ⚙️
- Your own personal AI assistant. Any OS. Any Platform. The lobster way.
+ Autonomous Support Structure for multi-agent AI systems. Built for Intel validation.
- npm install -g openclaw
+ npm install -g @danv-intel/ass
- openclaw wizard
+ ass wizard
```

### 4. src/ Config Paths

**Search for:** `~/.openclaw`, `.openclaw`, `openclaw.json`

**Replace with:** `~/.ass`, `.ass`, `ass.json`

**Files likely affected:**
- `src/config/paths.ts`
- `src/config/defaults.ts`
- `src/cli/*.ts`
- `src/gateway/*.ts`

### 5. docs/

**Update all command examples:**
- `openclaw status` → `ass status`
- `openclaw wizard` → `ass wizard`
- `~/.openclaw/` → `~/.ass/`

---

## Rebrand Checklist

### Pre-Flight
- [ ] Fork exists: https://github.com/danv-intel/ass ✅
- [ ] Cloned locally: /home/dan/ass ✅
- [ ] Upstream configured: openclaw/openclaw ✅

### Phase 1: Core Rebrand
- [ ] Update package.json (name, bin, description)
- [ ] Rename openclaw.mjs → ass.mjs
- [ ] Update README.md header and install instructions
- [ ] Test build: `pnpm build`
- [ ] Test link: `npm link && ass --version`

### Phase 2: Config Migration
- [ ] Update config path constants in src/
- [ ] Create migration script for existing configs
- [ ] Test fresh install
- [ ] Test migration from openclaw

### Phase 3: Documentation
- [ ] Update all docs/ markdown files
- [ ] Update AGENTS.md examples
- [ ] Add REBRAND.md (this file)
- [ ] Update CHANGELOG.md

### Phase 4: Source Cleanup
- [ ] Grep all "openclaw" references
- [ ] Update strings in src/
- [ ] Update tests
- [ ] Update scripts/

### Phase 5: Testing
- [ ] Build succeeds
- [ ] CLI works: ass status, ass wizard
- [ ] Config loads correctly
- [ ] Agents start/stop
- [ ] Message board works
- [ ] GitHub push works

### Phase 6: Upstream Sync
- [ ] Test fetch upstream
- [ ] Test merge upstream (dry run)
- [ ] Document conflict resolution strategy

---

## Risk Mitigation

### Backup Original OpenClaw
```bash
# Keep original installation
which openclaw  # Note path
cp -r ~/.openclaw ~/.openclaw.backup
```

### Gradual Rollout
1. Install ASS alongside OpenClaw initially
2. Test both work independently
3. Migrate config after verification
4. Deprecate OpenClaw once stable

### Rollback Plan
```bash
# If ASS breaks, revert to OpenClaw
npm uninstall -g @danv-intel/ass
npm install -g openclaw
cp -r ~/.openclaw.backup ~/.openclaw
```

---

## Success Metrics

**MVP Complete When:**
- [ ] `ass --version` returns version
- [ ] `ass status` shows agent status
- [ ] `ass wizard` completes setup
- [ ] Agents can send messages
- [ ] Dashboard accessible

**Full Rebrand Complete When:**
- [ ] All docs updated
- [ ] No "openclaw" strings in source (except attributions)
- [ ] Can pull upstream updates
- [ ] Published to npm as @danv-intel/ass
- [ ] Team using ASS instead of OpenClaw

---

## Attribution

**Based on OpenClaw:**  
https://github.com/openclaw/openclaw  
Licensed under MIT License

**Changes:**
- Rebranded to ASS (Autonomous Support Structure)
- Customized for Intel validation workflows
- Maintained full upstream compatibility

---

## Next Steps

1. **Run rebrand script** (creates all changes)
2. **Test locally** (verify MVP works)
3. **Commit to danv-intel/ass** (push rebrand)
4. **Install and test** (real usage)
5. **Document findings** (update this plan)
6. **Pull upstream** (test merge strategy)

Ready to execute rebrand? Run:
```bash
cd /home/dan/ass
./scripts/rebrand-to-ass.sh
```
