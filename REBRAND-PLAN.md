# ASS (Autonomous Support Structure) Rebrand Plan

**Date:** 2026-02-09  
**From:** AutoLab  
**To:** ASS (Autonomous Support Structure)  
**Repository:** https://github.com/danv-intel/ass  
**Upstream:** https://github.com/autolab/autolab

---

## Rebrand Scope

### Package Identity
- **Name:** `@danv-intel/ass` (scoped npm package)
- **CLI Command:** `ass`
- **Config Path:** `~/.ass/` (from `~/.autolab/`)
- **Binary:** `ass` (from `autolab`)

### What Changes
1. **Package.json** - name, bin, description
2. **CLI Entry** - `autolab.mjs` → `ass.mjs`
3. **Documentation** - README, docs/, all references
4. **Config Paths** - All `~/.autolab` → `~/.ass`
5. **Source Code** - String references to "autolab"
6. **Branding** - Logo, colors, tagline

### What Stays Same
1. **Core functionality** - All features preserved
2. **MIT License** - With attribution to AutoLab
3. **Git history** - Full history maintained
4. **Architecture** - No structural changes

---

## Implementation Steps

### Phase 1: Core Rebrand (MVP)

**Goal:** Working `ass` CLI that installs and runs

**Files to change:**
```
package.json          → name, bin, description
autolab.mjs          → rename to ass.mjs
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

**Goal:** Seamlessly migrate existing `~/.autolab` configs

**Create migration script:**
```bash
# ~/.ass/migrate-from-autolab.sh
# Copies config, preserves both for safety
```

**Config paths to update:**
- `~/.autolab/autolab.json` → `~/.ass/ass.json`
- `~/.autolab/workspace` → `~/.ass/workspace`
- `~/.autolab/agents` → `~/.ass/agents`
- `~/.autolab/logs` → `~/.ass/logs`

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

**Goal:** Remove all "autolab" string references

**Search and replace:**
```bash
grep -r "autolab" --exclude-dir=node_modules --exclude-dir=.git
grep -r "AutoLab" --exclude-dir=node_modules --exclude-dir=.git
grep -r "open-claw" --exclude-dir=node_modules --exclude-dir=.git
```

**Replace patterns:**
- `autolab` → `ass`
- `AutoLab` → `ASS`
- `.autolab` → `.ass`

### Phase 5: Upstream Sync Testing

**Goal:** Verify we can pull updates from autolab/autolab

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
- "name": "autolab",
+ "name": "@danv-intel/ass",
- "description": "Multi-channel AI gateway with extensible messaging integrations",
+ "description": "Autonomous Support Structure - AI agent framework for Intel validation",
  "bin": {
-   "autolab": "autolab.mjs"
+   "ass": "ass.mjs"
  },
```

### 2. autolab.mjs → ass.mjs

```bash
mv autolab.mjs ass.mjs
# Update internal references
```

### 3. README.md

```diff
- # AutoLab 🦞
+ # ASS (Autonomous Support Structure) ⚙️
- Your own personal AI assistant. Any OS. Any Platform. The lobster way.
+ Autonomous Support Structure for multi-agent AI systems. Built for Intel validation.
- npm install -g autolab
+ npm install -g @danv-intel/ass
- autolab wizard
+ ass wizard
```

### 4. src/ Config Paths

**Search for:** `~/.autolab`, `.autolab`, `autolab.json`

**Replace with:** `~/.ass`, `.ass`, `ass.json`

**Files likely affected:**
- `src/config/paths.ts`
- `src/config/defaults.ts`
- `src/cli/*.ts`
- `src/gateway/*.ts`

### 5. docs/

**Update all command examples:**
- `autolab status` → `ass status`
- `autolab wizard` → `ass wizard`
- `~/.autolab/` → `~/.ass/`

---

## Rebrand Checklist

### Pre-Flight
- [ ] Fork exists: https://github.com/danv-intel/ass ✅
- [ ] Cloned locally: /home/dan/ass ✅
- [ ] Upstream configured: autolab/autolab ✅

### Phase 1: Core Rebrand
- [ ] Update package.json (name, bin, description)
- [ ] Rename autolab.mjs → ass.mjs
- [ ] Update README.md header and install instructions
- [ ] Test build: `pnpm build`
- [ ] Test link: `npm link && ass --version`

### Phase 2: Config Migration
- [ ] Update config path constants in src/
- [ ] Create migration script for existing configs
- [ ] Test fresh install
- [ ] Test migration from autolab

### Phase 3: Documentation
- [ ] Update all docs/ markdown files
- [ ] Update AGENTS.md examples
- [ ] Add REBRAND.md (this file)
- [ ] Update CHANGELOG.md

### Phase 4: Source Cleanup
- [ ] Grep all "autolab" references
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

### Backup Original AutoLab
```bash
# Keep original installation
which autolab  # Note path
cp -r ~/.autolab ~/.autolab.backup
```

### Gradual Rollout
1. Install ASS alongside AutoLab initially
2. Test both work independently
3. Migrate config after verification
4. Deprecate AutoLab once stable

### Rollback Plan
```bash
# If ASS breaks, revert to AutoLab
npm uninstall -g @danv-intel/ass
npm install -g autolab
cp -r ~/.autolab.backup ~/.autolab
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
- [ ] No "autolab" strings in source (except attributions)
- [ ] Can pull upstream updates
- [ ] Published to npm as @danv-intel/ass
- [ ] Team using ASS instead of AutoLab

---

## Attribution

**Based on AutoLab:**  
https://github.com/autolab/autolab  
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
