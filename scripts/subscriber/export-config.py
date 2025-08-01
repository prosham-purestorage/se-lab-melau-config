"""
export-config.py: Decrypts secrets, merges with config, and exports to env/json/ps1 formats.
"""
import argparse
import base64
import os
import sys
import yaml
from pathlib import Path
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend

def load_key(key_path):
    key_path = Path(key_path)
    if not key_path.is_absolute():
        key_path = Path(__file__).parent / key_path
    with open(key_path, 'r') as f:
        key_b64 = f.read().strip()
    return base64.b64decode(key_b64)

def decrypt_secrets(enc_path, key_path):
    enc_path = Path(enc_path)
    if not enc_path.is_absolute():
        enc_path = Path(__file__).parent / enc_path
    with open(enc_path, 'rb') as f:
        iv = f.read(16)
        ciphertext = f.read()
    key = load_key(key_path)
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())
    decryptor = cipher.decryptor()
    padded = decryptor.update(ciphertext) + decryptor.finalize()
    pad_len = padded[-1]
    plaintext = padded[:-pad_len]
    return yaml.safe_load(plaintext)

def load_config(config_path):
    config_path = Path(config_path)
    if not config_path.is_absolute():
        config_path = Path(__file__).parent / config_path
    with open(config_path, 'r') as f:
        return yaml.safe_load(f)

def flatten_dict(d, parent_key='', sep='_'):
    items = []
    for k, v in d.items():
        new_key = f"{parent_key}{sep}{k}" if parent_key else k
        if isinstance(v, dict):
            items.extend(flatten_dict(v, new_key, sep=sep).items())
        else:
            items.append((new_key, v))
    return dict(items)

def export_env(flat, output):
    with open(output, 'w') as f:
        for k, v in flat.items():
            f.write(f'{k}="{v}"\n')

def export_json(flat, output):
    import json
    with open(output, 'w') as f:
        json.dump(flat, f, indent=2)

def export_ps1(flat, output):
    with open(output, 'w') as f:
        for k, v in flat.items():
            f.write(f'$env:{k} = "{v}"\n')

def main():
    parser = argparse.ArgumentParser(description="Export config/secrets to env/json/ps1.")
    parser.add_argument('--type', choices=['env', 'json', 'ps1'], required=True)
    parser.add_argument('--output', required=True)
    parser.add_argument('--config', required=True)
    parser.add_argument('--secrets', required=True)
    parser.add_argument('--key', required=True)
    args = parser.parse_args()

    config = load_config(args.config)
    secrets = decrypt_secrets(args.secrets, args.key)
    merged = {**config, **secrets}
    flat = flatten_dict(merged)

    if args.type == 'env':
        export_env(flat, args.output)
    elif args.type == 'json':
        export_json(flat, args.output)
    elif args.type == 'ps1':
        export_ps1(flat, args.output)
    else:
        print('Unknown export type')
        sys.exit(1)

if __name__ == '__main__':
    main()
