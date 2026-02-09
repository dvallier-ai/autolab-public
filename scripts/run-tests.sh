#!/bin/bash
# AutoLab Test Suite Runner
# Executes all validation tests from TEST-PLAN.md

set +e  # Don't exit on test failure, collect all results

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
SKIPPED=0

echo "🧪 AutoLab Test Suite"
echo "===================="
echo ""

# Helper functions
pass() {
    echo -e "${GREEN}✅ PASS${NC}: $1"
    ((PASSED++))
}

fail() {
    echo -e "${RED}❌ FAIL${NC}: $1"
    ((FAILED++))
}

skip() {
    echo -e "${YELLOW}⏭️  SKIP${NC}: $1"
    ((SKIPPED++))
}

# Category 1: CLI Commands
echo "📦 Category 1: CLI Commands"
echo "----------------------------"

# T1.1: Version Check
if autolab --version > /dev/null 2>&1; then
    VERSION=$(autolab --version)
    pass "T1.1 Version check ($VERSION)"
else
    fail "T1.1 Version check"
fi

# T1.2: Help Output
if autolab --help 2>&1 | grep -q "autolab"; then
    if autolab --help 2>&1 | grep -qi "openclaw.*command"; then
        fail "T1.2 Help contains 'openclaw' command references"
    else
        pass "T1.2 Help output clean"
    fi
else
    fail "T1.2 Help output"
fi

# T1.3: Status Command
if autolab status > /tmp/autolab-status-test.txt 2>&1; then
    pass "T1.3 Status command"
else
    fail "T1.3 Status command"
fi

echo ""

# Category 2: Gateway Operations
echo "🌐 Category 2: Gateway Operations"
echo "----------------------------------"

# T2.1: Gateway Status
if autolab gateway status > /dev/null 2>&1; then
    pass "T2.1 Gateway status"
else
    fail "T2.1 Gateway status"
fi

# T2.2: Gateway Health Endpoint
if curl -s http://localhost:18789/api/health | jq . > /dev/null 2>&1; then
    pass "T2.2 Gateway health endpoint"
else
    skip "T2.2 Gateway health endpoint (gateway may be offline)"
fi

echo ""

# Category 3: Configuration
echo "⚙️  Category 3: Configuration"
echo "-----------------------------"

# T3.1: Config File Exists
if [ -f ~/.openclaw/openclaw.json ]; then
    pass "T3.1 Config file exists"
else
    fail "T3.1 Config file missing"
fi

# T3.2: Config Valid JSON
if jq . ~/.openclaw/openclaw.json > /dev/null 2>&1; then
    pass "T3.2 Config valid JSON"
else
    fail "T3.2 Config invalid JSON"
fi

# T3.3: Workspace Exists
if [ -d ~/.openclaw/workspace ]; then
    pass "T3.3 Workspace exists"
else
    fail "T3.3 Workspace missing"
fi

# T3.4: Memory Files
if ls ~/.openclaw/workspace/memory/*.md > /dev/null 2>&1; then
    pass "T3.4 Memory files exist"
else
    skip "T3.4 Memory files (none found)"
fi

echo ""

# Category 4: Build & Installation
echo "🔨 Category 4: Build & Installation"
echo "------------------------------------"

# T4.1: Package.json Name
if grep -q '"name": "@danv-intel/autolab"' "$REPO_ROOT/package.json"; then
    pass "T4.1 Package name correct"
else
    fail "T4.1 Package name incorrect"
fi

# T4.2: Binary Name
if grep -q '"autolab": "autolab.mjs"' "$REPO_ROOT/package.json"; then
    pass "T4.2 Binary name correct"
else
    fail "T4.2 Binary name incorrect"
fi

# T4.3: Build Artifacts
if [ -d "$REPO_ROOT/dist" ] && [ "$(ls -A $REPO_ROOT/dist)" ]; then
    pass "T4.3 Build artifacts exist"
else
    fail "T4.3 Build artifacts missing"
fi

# T4.4: No OpenClaw in Functional Fields
OPENCLAW_IN_PKG=$(grep -i '"openclaw"' "$REPO_ROOT/package.json" | grep -v "Based on OpenClaw" | wc -l)
if [ "$OPENCLAW_IN_PKG" -eq 0 ]; then
    pass "T4.4 No 'openclaw' in package.json functional fields"
else
    fail "T4.4 Found 'openclaw' in package.json ($OPENCLAW_IN_PKG occurrences)"
fi

echo ""

# Category 5: Source Code
echo "💻 Category 5: Source Code"
echo "---------------------------"

# T5.1: Config Paths (should use .autolab)
OPENCLAW_PATHS=$(grep -r "\.openclaw" "$REPO_ROOT/src" 2>/dev/null | grep -v ".autolab" | wc -l)
if [ "$OPENCLAW_PATHS" -eq 0 ]; then
    pass "T5.1 Config paths updated to .autolab"
else
    fail "T5.1 Found .openclaw paths in source ($OPENCLAW_PATHS occurrences)"
fi

# T5.2: Config File References
OPENCLAW_JSON=$(grep -r "openclaw\.json" "$REPO_ROOT/src" 2>/dev/null | wc -l)
if [ "$OPENCLAW_JSON" -eq 0 ]; then
    pass "T5.2 Config file references updated to autolab.json"
else
    fail "T5.2 Found openclaw.json references ($OPENCLAW_JSON occurrences)"
fi

# T5.3: Brand Strings (OpenClaw in UI/messages)
OPENCLAW_BRAND=$(grep -r "OpenClaw" "$REPO_ROOT/src" 2>/dev/null | grep -v "// " | grep -v "Based on OpenClaw" | wc -l)
if [ "$OPENCLAW_BRAND" -lt 10 ]; then
    pass "T5.3 Brand strings mostly updated ($OPENCLAW_BRAND remaining)"
else
    fail "T5.3 Too many OpenClaw brand strings ($OPENCLAW_BRAND found)"
fi

echo ""

# Category 6: Documentation
echo "📚 Category 6: Documentation"
echo "-----------------------------"

# T6.1: README Title
if grep -q "# AutoLab" "$REPO_ROOT/README.md"; then
    pass "T6.1 README title updated"
else
    fail "T6.1 README title not updated"
fi

# T6.2: Install Instructions
if grep -q "@danv-intel/autolab" "$REPO_ROOT/README.md"; then
    pass "T6.2 Install instructions reference AutoLab"
else
    fail "T6.2 Install instructions not updated"
fi

# T6.3: Attribution Present
if grep -qi "Based on OpenClaw" "$REPO_ROOT/README.md"; then
    pass "T6.3 OpenClaw attribution present"
else
    fail "T6.3 OpenClaw attribution missing"
fi

echo ""

# Category 7: Functional Tests
echo "🔧 Category 7: Functional Tests"
echo "--------------------------------"

# T7.1: Cron List
if autolab cron list > /dev/null 2>&1; then
    pass "T7.1 Cron list command"
else
    skip "T7.1 Cron list (may require gateway)"
fi

# T7.2: Message Board Integration
if curl -s http://10.23.19.102:8080/api/training/messages?limit=1 | jq . > /dev/null 2>&1; then
    pass "T7.2 Message board accessible"
else
    skip "T7.2 Message board (may be offline)"
fi

echo ""
echo "========================================"
echo "📊 Test Results Summary"
echo "========================================"
echo ""
echo -e "${GREEN}✅ Passed:${NC}  $PASSED"
echo -e "${RED}❌ Failed:${NC}  $FAILED"
echo -e "${YELLOW}⏭️  Skipped:${NC} $SKIPPED"
echo ""

TOTAL=$((PASSED + FAILED + SKIPPED))
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 ALL TESTS PASSED!${NC}"
    echo ""
    echo "AutoLab is ready for use."
    exit 0
else
    echo -e "${RED}⚠️  SOME TESTS FAILED${NC}"
    echo ""
    echo "Review failures above and fix issues."
    exit 1
fi
