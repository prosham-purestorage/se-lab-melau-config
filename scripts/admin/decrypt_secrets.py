"""
decrypt_secrets.py: Decrypts secrets.yml.encrypted to secrets.yml for editing.
"""
import sys
from pathlib import Path
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
import base64
import yaml

ENCRYPTED_FILE = Path('secrets.yml.encrypted')
DECRYPTED_FILE = Path('secrets.yml')
KEY_FILE = Path.home() / '.purestorage/se-lab-melau.key'


def load_key():
    with open(KEY_FILE, 'r') as f:
        key_b64 = f.read().strip()
    return base64.b64decode(key_b64)


def decrypt_file():
    with open(ENCRYPTED_FILE, 'rb') as f:
        iv = f.read(16)
        ciphertext = f.read()
    key = load_key()
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())
    decryptor = cipher.decryptor()
    padded = decryptor.update(ciphertext) + decryptor.finalize()
    # Remove PKCS7 padding
    pad_len = padded[-1]
    plaintext = padded[:-pad_len]
    with open(DECRYPTED_FILE, 'wb') as f:
        f.write(plaintext)
    print(f"Decrypted secrets to {DECRYPTED_FILE}")


def main():
    decrypt_file()

if __name__ == '__main__':
    main()
