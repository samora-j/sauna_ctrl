#!/bin/bash
# deploy.sh — Auto-deploy script for sauna_ctrl
# Called by systemd timer every 30 seconds.
# Pulls from GitHub, installs deps if changed, restarts service if code changed.

set -e

REPO_DIR="/home/marcushj/sauna_ctrl"
cd "$REPO_DIR"

# Fetch latest from origin
git fetch origin main --quiet

# Check if there are new commits
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" = "$REMOTE" ]; then
    exit 0  # Nothing new
fi

echo "New commits detected: $LOCAL → $REMOTE"
git reset --hard origin/main
git clean -fd

# Always sync dependencies — pip is a no-op when nothing has changed
echo "Syncing dependencies"
/home/marcushj/sauna_ctrl/pi/venv/bin/pip install -r pi/requirements.txt --quiet

# Check if any Pi code changed
if git diff "$LOCAL" "$REMOTE" --name-only | grep -q "^pi/"; then
    echo "Python code changed — restarting sauna-ctrl service"
    sudo systemctl restart sauna-ctrl
    echo "Service restarted"
fi

# Check if systemd service files changed
if git diff "$LOCAL" "$REMOTE" --name-only | grep -q "^config/systemd/"; then
    echo "Service files changed — reinstalling"
    sudo cp config/systemd/*.service /etc/systemd/system/ 2>/dev/null || true
    sudo cp config/systemd/*.timer /etc/systemd/system/ 2>/dev/null || true
    sudo systemctl daemon-reload
    sudo systemctl restart sauna-ctrl
    echo "Systemd units reloaded and service restarted"
fi
