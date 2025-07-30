#!/bin/bash
# Setup encryption for SE Lab secrets

KEYFILE_DIR="$HOME/.purestorage"
KEYFILE_PATH="$KEYFILE_DIR/se-lab-melau.key"

echo "🔐 Setting up encryption for SE Lab secrets"

# Create keyfile directory
mkdir -p "$KEYFILE_DIR"
chmod 700 "$KEYFILE_DIR"

if [ ! -f "$KEYFILE_PATH" ]; then
    echo "🔑 Generating new encryption key..."
    openssl rand -base64 32 > "$KEYFILE_PATH"
    chmod 600 "$KEYFILE_PATH"
    echo "✅ Encryption key created: $KEYFILE_PATH"
else
    echo "✅ Using existing encryption key: $KEYFILE_PATH"
fi

echo "💡 Share this keyfile securely with authorized team members"
echo "💡 Keep a secure backup of this keyfile"
