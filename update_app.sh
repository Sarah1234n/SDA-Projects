#!/bin/bash
set -e

date
echo "Updating Python application on VM..."

APP_DIR="/home/azureuser/chatbot/SDA-Projects"
GIT_REPO="github.com/Sarah1234n/SDA-Projects.git"
BRANCH="master"  # غيّرها إذا الفرع غير

# تحديث الشيفرة
if [ -d "$APP_DIR/.git" ]; then
    echo "Pulling latest code..."
    sudo -u azureuser git -C "$APP_DIR" pull origin "$BRANCH"
else
    echo "Cloning repo..."
    sudo -u azureuser git clone -b "$BRANCH" "https://${GITHUB_TOKEN}@${GIT_REPO}" "$APP_DIR"
fi

# تنشيط البيئة الافتراضية وتثبيت المتطلبات
VENV_PATH="$APP_DIR/venv/bin/activate"
REQ_FILE="$APP_DIR/requirements.txt"

# تأكد من وجود البيئة الافتراضية
if [ -f "$VENV_PATH" ]; then
    echo "Activating virtual environment and installing requirements..."
    source "$VENV_PATH"
    
    # التأكد من أن pip محدث
    "$APP_DIR/venv/bin/pip" install --upgrade pip

    # تثبيت المتطلبات
    if [ -f "$REQ_FILE" ]; then
        "$APP_DIR/venv/bin/pip" install -r "$REQ_FILE"
    else
        echo "requirements.txt not found at $REQ_FILE"
        exit 1
    fi
else
    echo "Virtual environment not found at $VENV_PATH"
    exit 1
fi


# sudo systemctl restart yourapp.service

echo "✅ Python application update completed!"
