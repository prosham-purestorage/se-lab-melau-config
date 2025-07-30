#!/bin/bash
# Encrypt secrets file

KEYFILE_PATH="$HOME/.purestorage/se-lab-melau.key"
SECRETS_FILE="secrets.yml"
ENCRYPTED_FILE="secrets.yml.encrypted"

if [ ! -f "$KEYFILE_PATH" ]; then
    echo "❌ Keyfile not found: $KEYFILE_PATH"
    echo "Run ./scripts/setup-encryption.sh first"
    exit 1
fi

if [ ! -f "$SECRETS_FILE" ]; then
    echo "❌ Secrets file not found: $SECRETS_FILE"
    exit 1
fi

echo "🔒 Encrypting secrets file..."
openssl enc -aes-256-cbc -in "$SECRETS_FILE" -out "$ENCRYPTED_FILE" -pass file:"$KEYFILE_PATH"

if [ $? -eq 0 ]; then
    rm "$SECRETS_FILE"
    echo "✅ Secrets encrypted: $ENCRYPTED_FILE"
    echo "✅ Unencrypted file removed"
else
    echo "❌ Encryption failed"
    exit 1
fi
