#!/bin/bash
# Decrypt secrets file for editing

KEYFILE_PATH="$HOME/.purestorage/se-lab-melau.key"
SECRETS_FILE="secrets.yml"
ENCRYPTED_FILE="secrets.yml.encrypted"

if [ ! -f "$KEYFILE_PATH" ]; then
    echo "❌ Keyfile not found: $KEYFILE_PATH"
    exit 1
fi

if [ ! -f "$ENCRYPTED_FILE" ]; then
    echo "❌ Encrypted secrets file not found: $ENCRYPTED_FILE"
    exit 1
fi

echo "🔓 Decrypting secrets file..."
openssl enc -aes-256-cbc -d -in "$ENCRYPTED_FILE" -out "$SECRETS_FILE" -pass file:"$KEYFILE_PATH"

if [ $? -eq 0 ]; then
    echo "✅ Secrets decrypted: $SECRETS_FILE"
    echo "⚠️  Remember to encrypt again after editing!"
else
    echo "❌ Decryption failed"
    exit 1
fi
