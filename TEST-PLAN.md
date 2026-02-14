# AutoLab Validation Test Plan

**Goal:** Validate AutoLab works identically to AutoLab after full rebrand

**Date:** 2026-02-09  
**Tester:** Ash (automated)

---

## Test Categories

### 1. CLI Commands

### 2. Gateway Operations

### 3. Agent Management

### 4. Message Board Integration

### 5. Configuration

### 6. Build & Installation

---

## 1. CLI Commands Tests

### T1.1: Version Check

```bash
autolab --version
# Expected: Version number (e.g., 2026.2.9)
# Status:
```

### T1.2: Help Output

```bash
autolab --help
# Expected: Command help, no "autolab" references
# Status:
```

### T1.3: Status Command

```bash
autolab status
# Expected: System status, gateway info, agents list
# Status:
```

### T1.4: Status Deep

```bash
autolab status --deep
# Expected: Detailed status including probes
# Status:
```

---

## 2. Gateway Operations Tests

### T2.1: Gateway Status

```bash
autolab gateway status
# Expected: Gateway running/stopped status
# Status:
```

### T2.2: Gateway Restart

```bash
autolab gateway restart
# Expected: Gateway restarts successfully
# Status:
```

### T2.3: Gateway Connection

```bash
# Check gateway responds
curl -s http://localhost:18789/api/health | jq
# Expected: JSON health response
# Status:
```

### T2.4: Dashboard Access

```bash
# Visit http://localhost:18789/
# Expected: Dashboard loads, no "autolab" branding visible
# Status:
```

---

## 3. Agent Management Tests

### T3.1: List Agents

```bash
autolab status | grep -A 10 "Agents"
# Expected: Shows Ash, TestyTina, VigilantVick
# Status:
```

### T3.2: Agent Sessions

```bash
# Check agent sessions exist
ls ~/.autolab/agents/main/sessions/ | wc -l
# Expected: >0 sessions
# Status:
```

### T3.3: Spawn Sub-Agent (if available)

```bash
# Test sub-agent spawning
# Expected: Sub-agent starts and completes task
# Status:
```

---

## 4. Message Board Integration Tests

### T4.1: List Messages (Agents Board)

```bash
curl -s http://10.23.19.102:8080/api/training/messages?board=agents | jq '.[] | .id' | head -5
# Expected: Returns message IDs
# Status:
```

### T4.2: List Messages (Collab Board)

```bash
curl -s http://10.23.19.102:8080/api/training/messages?board=collab | jq '.[] | .id' | head -5
# Expected: Returns message IDs
# Status:
```

### T4.3: Post Test Message

```bash
# Post a test message, verify it appears
# Expected: Message posts successfully
# Status:
```

---

## 5. Configuration Tests

### T5.1: Config File Exists

```bash
ls -la ~/.autolab/autolab.json
# Expected: Config file exists
# Status:
```

### T5.2: Config Valid JSON

```bash
jq . ~/.autolab/autolab.json > /dev/null
# Expected: No errors, valid JSON
# Status:
```

### T5.3: Workspace Exists

```bash
ls -la ~/.autolab/workspace/
# Expected: Workspace directory with files
# Status:
```

### T5.4: Memory Files

```bash
ls ~/.autolab/workspace/memory/ | head -5
# Expected: Memory files exist
# Status:
```

---

## 6. Build & Installation Tests

### T6.1: Clean Build

```bash
cd /home/dan/autolab
rm -rf dist node_modules
npm install
npm run build
# Expected: Build succeeds, dist/ created
# Status:
```

### T6.2: Package.json Correct

```bash
grep '"name":' /home/dan/autolab/package.json
# Expected: "@danv-intel/autolab"
# Status:
```

### T6.3: Binary Name

```bash
grep '"bin":' /home/dan/autolab/package.json
# Expected: "autolab": "autolab.mjs"
# Status:
```

### T6.4: No "autolab" in package.json

```bash
grep -i autolab /home/dan/autolab/package.json
# Expected: Only in comments/attribution, not functional fields
# Status:
```

---

## 7. Source Code Tests

### T7.1: Config Paths Updated

```bash
# Check source uses correct config path
grep -r "\.autolab" /home/dan/autolab/src/ | wc -l
# Expected: 0 (or only in migration code)
# Status:
```

### T7.2: Brand Strings Updated

```bash
# Check for "AutoLab" brand references
grep -r "AutoLab" /home/dan/autolab/src/ | grep -v "// AutoLab" | wc -l
# Expected: 0 (excluding comments)
# Status:
```

### T7.3: CLI Name Updated

```bash
# Check CLI references
grep -r "autolab" /home/dan/autolab/src/ | grep -v "autolab.json" | head -10
# Expected: Minimal, only in necessary places
# Status:
```

---

## 8. Documentation Tests

### T8.1: README Updated

```bash
grep -i "AutoLab" /home/dan/autolab/README.md | head -1
# Expected: "# AutoLab"
# Status:
```

### T8.2: No Stale AutoLab Refs

```bash
grep -i "autolab" /home/dan/autolab/README.md | grep -v "Based on AutoLab" | wc -l
# Expected: 0 (except attribution)
# Status:
```

### T8.3: Install Instructions

```bash
grep "npm install" /home/dan/autolab/README.md | head -1
# Expected: References @danv-intel/autolab
# Status:
```

---

## 9. Functional Integration Tests

### T9.1: Heartbeat Works

```bash
# Trigger heartbeat, check agent responds
autolab cron wake --text "Test heartbeat"
# Wait 30s, check logs
# Expected: Agent processes heartbeat
# Status:
```

### T9.2: Cron List

```bash
autolab cron list
# Expected: Shows cron jobs (if any)
# Status:
```

### T9.3: Sessions List

```bash
# Check if sessions command works
# Expected: Lists active sessions
# Status:
```

---

## 10. Regression Tests (Ensure Nothing Broke)

### T10.1: Existing Workspace Intact

```bash
ls ~/.autolab/workspace/MEMORY.md
ls ~/.autolab/workspace/memory/2026-02-09.md
# Expected: Files exist, not corrupted
# Status:
```

### T10.2: Existing Agents Work

```bash
# Switch to TestyTina, post message
# Expected: Agent responds normally
# Status:
```

### T10.3: Training Board Still Works

```bash
curl -s http://10.23.19.102:8080/api/training/messages?limit=5 | jq 'length'
# Expected: Returns messages
# Status:
```

---

## Success Criteria

**Pass requirements:**

- ✅ All CLI commands work
- ✅ Gateway operates normally
- ✅ Agents functional
- ✅ Message board integration works
- ✅ No "autolab" branding in user-facing output
- ✅ Config backward compatible
- ✅ Build succeeds
- ✅ No regressions

**Failure conditions:**

- ❌ Gateway won't start
- ❌ Agents can't communicate
- ❌ Config corrupted
- ❌ Build fails
- ❌ Major functionality broken

---

## Test Execution Log

### Pre-Rebrand Baseline

```
Date: 2026-02-09 11:38 PST
Status: AutoLab working
Gateway: Running (pid 3534387)
Agents: 3 active
CLI: autolab + autolab both work (shared gateway)
```

### Post-Rebrand Validation

```
Date: [To be filled during test]
Status: [Pass/Fail per test]
Issues: [List any failures]
Fixes: [Document fixes applied]
```

---

## Rollback Plan

If critical failures:

1. Git reset to last working commit
2. Rebuild from known-good state
3. Re-link CLI
4. Verify rollback successful

```bash
cd /home/dan/autolab
git log --oneline | head -5  # Find last good commit
git reset --hard <commit-hash>
npm run build
npm link
autolab status  # Verify
```

---

## Notes

- Tests executed by Ash (automated where possible)
- Manual verification for UI/dashboard
- Phase 2 (config migration) deferred until Phase 1 passes
- Upstream sync testing deferred
- Performance testing not required (functional equivalence only)

---

## Test Results Summary

**Total Tests:** 30+  
**Passed:** [TBD]  
**Failed:** [TBD]  
**Skipped:** [TBD]  
**Overall:** [Pass/Fail]

**Ready for:** [Production/Further Testing/Fixes Required]
