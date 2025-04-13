#!/bin/bash
set -e

date
echo "Updating Python application on VM..."

APP_DIR="/home/azureuser/chatbot/SDA-Projects"
GIT_REPO="github.com/Sarah1234n/SDA-Projects.git"
BRANCH="master"  # غيّرها إذا الفرع غير

# Update code
if [ -d "$APP_DIR/.git" ]; then
    echo "Pulling latest code..."
    sudo -u azureuser git -C "$APP_DIR" pull origin "$BRANCH"
else
    echo "Cloning repo..."
    sudo -u azureuser git clone -b "$BRANCH" "https://${GITHUB_TOKEN}@${GIT_REPO}" "$APP_DIR"
fi

# Activate virtual environment and install requirements
VENV_PATH="$APP_DIR/venv/bin/activate"
REQ_FILE="$APP_DIR/requirements.txt"

if [ -f "$VENV_PATH" ]; then
    echo "Activating virtual environment and installing requirements..."
    source "$VENV_PATH"
    "$APP_DIR/venv/bin/pip" install --upgrade pip
    "$APP_DIR/venv/bin/pip" install -r "$REQ_FILE"
else
    echo "Virtual environment not found at $VENV_PATH"
    exit 1
fi

# Restart the service (optional - if you have a systemd service)
# sudo systemctl restart yourapp.service

echo "✅ Python application update completed!"
