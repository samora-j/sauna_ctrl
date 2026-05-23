#!/bin/bash
# setup-pi.sh — One-time setup for sauna_ctrl on a fresh Raspberry Pi
#
# Usage:
#   git clone https://github.com/samora-j/sauna_ctrl.git
#   cd sauna_ctrl
#   chmod +x setup-pi.sh deploy.sh
#   ./setup-pi.sh

set -e
echo "=== sauna_ctrl — Pi Setup ==="

# 1. Install system dependencies
echo "Installing system packages..."
sudo apt update --quiet
sudo apt install -y --quiet python3-venv python3-dev libopenblas0
echo "✓ System packages installed"

# 2. Create Python virtual environment
echo "Creating Python virtual environment..."
python3 -m venv venv
venv/bin/pip install --upgrade pip --quiet
venv/bin/pip install -r requirements.txt --quiet
echo "✓ Python dependencies installed"

# 3. Install systemd services
echo "Installing systemd services..."
sudo cp config/systemd/sauna-ctrl.service /etc/systemd/system/
sudo cp config/systemd/sauna-ctrl-deploy.service /etc/systemd/system/
sudo cp config/systemd/sauna-ctrl-deploy.timer /etc/systemd/system/
sudo systemctl daemon-reload
echo "✓ Systemd services installed"

# 4. Allow passwordless restart for deploy script
echo "Configuring sudoers for deploy..."
echo "marcushj ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart sauna-ctrl, /usr/bin/systemctl daemon-reload" | sudo tee /etc/sudoers.d/sauna-ctrl > /dev/null
sudo chmod 440 /etc/sudoers.d/sauna-ctrl
echo "✓ Sudoers configured"

# 5. Enable and start services
echo "Enabling services..."
sudo systemctl enable sauna-ctrl
sudo systemctl enable sauna-ctrl-deploy.timer
sudo systemctl start sauna-ctrl-deploy.timer
sudo systemctl start sauna-ctrl
echo "✓ Services started"

echo ""
echo "=== Setup complete ==="
echo ""
echo "  Logs:        journalctl -u sauna-ctrl -f"
echo "  Deploy logs: journalctl -u sauna-ctrl-deploy -f"
echo ""
echo "  Auto-deploy polls GitHub every 30 seconds."
echo "  Push to main and the Pi updates automatically."
echo ""
