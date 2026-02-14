#!/usr/bin/env bash
set -euo pipefail

cd /repo

export AUTOLAB_STATE_DIR="/tmp/autolab-test"
export AUTOLAB_CONFIG_PATH="${AUTOLAB_STATE_DIR}/autolab.json"

echo "==> Build"
pnpm build

echo "==> Seed state"
mkdir -p "${AUTOLAB_STATE_DIR}/credentials"
mkdir -p "${AUTOLAB_STATE_DIR}/agents/main/sessions"
echo '{}' >"${AUTOLAB_CONFIG_PATH}"
echo 'creds' >"${AUTOLAB_STATE_DIR}/credentials/marker.txt"
echo 'session' >"${AUTOLAB_STATE_DIR}/agents/main/sessions/sessions.json"

echo "==> Reset (config+creds+sessions)"
pnpm autolab reset --scope config+creds+sessions --yes --non-interactive

test ! -f "${AUTOLAB_CONFIG_PATH}"
test ! -d "${AUTOLAB_STATE_DIR}/credentials"
test ! -d "${AUTOLAB_STATE_DIR}/agents/main/sessions"

echo "==> Recreate minimal config"
mkdir -p "${AUTOLAB_STATE_DIR}/credentials"
echo '{}' >"${AUTOLAB_CONFIG_PATH}"

echo "==> Uninstall (state only)"
pnpm autolab uninstall --state --yes --non-interactive

test ! -d "${AUTOLAB_STATE_DIR}"

echo "OK"
