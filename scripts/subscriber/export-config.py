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
        # For relative paths, resolve from the working directory where make was called
        # This handles both standalone and submodule scenarios correctly
        enc_path = Path.cwd() / enc_path
    with open(enc_path, 'rb') as f:
        iv = f.read(16)
        ciphertext = f.read()
    key = load_key(key_path)
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())
    decryptor = cipher.decryptor()
    padded_plaintext = decryptor.update(ciphertext) + decryptor.finalize()
    # Remove PKCS7 padding
    padding_length = padded_plaintext[-1]
    plaintext = padded_plaintext[:-padding_length]
    return yaml.safe_load(plaintext.decode('utf-8'))

def load_config(config_path):
    config_path = Path(config_path)
    if not config_path.is_absolute():
        # For relative paths, resolve from the working directory where make was called
        # This handles both standalone and submodule scenarios correctly
        config_path = Path.cwd() / config_path
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

def export_env(data, output):
    output = Path(output)
    if not output.is_absolute():
        # For relative output paths, resolve from the working directory where make was called
        output = Path.cwd() / output
    output.parent.mkdir(parents=True, exist_ok=True)
    
    # If file exists with restrictive permissions, temporarily make it writable
    if output.exists():
        os.chmod(output, 0o600)
    
    with open(output, 'w') as f:
        for key, value in data.items():
            f.write(f"{key.upper()}={value}\n")
    # Set secure permissions (read-only for owner)
    os.chmod(output, 0o400)
    print(f"✓ Config exported to {output}")

def export_json(data, output):
    import json
    output = Path(output)
    if not output.is_absolute():
        # For relative output paths, resolve from the working directory where make was called
        output = Path.cwd() / output
    output.parent.mkdir(parents=True, exist_ok=True)
    
    # If file exists with restrictive permissions, temporarily make it writable
    if output.exists():
        os.chmod(output, 0o600)
    
    with open(output, 'w') as f:
        json.dump(data, f, indent=2)
    # Set secure permissions (read-only for owner)
    os.chmod(output, 0o400)
    print(f"✓ Config exported to {output}")

def export_ps1(data, output):
    output = Path(output)
    if not output.is_absolute():
        # For relative output paths, resolve from the working directory where make was called
        output = Path.cwd() / output
    output.parent.mkdir(parents=True, exist_ok=True)
    
    # If file exists with restrictive permissions, temporarily make it writable
    if output.exists():
        os.chmod(output, 0o600)
    
    with open(output, 'w') as f:
        for key, value in data.items():
            f.write(f"${key.upper()} = \"{value}\"\n")
    # Set secure permissions (read-only for owner)
    os.chmod(output, 0o400)
    print(f"✓ Config exported to {output}")

def main():
    parser = argparse.ArgumentParser(description="Export config and secrets to specified format.")
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
