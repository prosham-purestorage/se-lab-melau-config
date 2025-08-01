"""
encrypt_secrets.py: Encrypts secrets.yml to secrets.yml.encrypted after editing.
"""
import sys
from pathlib import Path
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
import base64
import os

DECRYPTED_FILE = Path('secrets.yml')
ENCRYPTED_FILE = Path('secrets.yml.encrypted')
KEY_FILE = Path.home() / '.purestorage/se-lab-melau.key'


def load_key():
    with open(KEY_FILE, 'r') as f:
        key_b64 = f.read().strip()
    return base64.b64decode(key_b64)


def pad(data):
    pad_len = 16 - (len(data) % 16)
    return data + bytes([pad_len] * pad_len)


def encrypt_file():
    with open(DECRYPTED_FILE, 'rb') as f:
        plaintext = f.read()
    key = load_key()
    iv = os.urandom(16)
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())
    encryptor = cipher.encryptor()
    padded = pad(plaintext)
    ciphertext = encryptor.update(padded) + encryptor.finalize()
    with open(ENCRYPTED_FILE, 'wb') as f:
        f.write(iv)
        f.write(ciphertext)
    print(f"Encrypted secrets to {ENCRYPTED_FILE}")
    
    # Remove the unencrypted file for security
    os.remove(DECRYPTED_FILE)
    print(f"Removed unencrypted {DECRYPTED_FILE} for security")


def main():
    encrypt_file()

if __name__ == '__main__':
    main()
