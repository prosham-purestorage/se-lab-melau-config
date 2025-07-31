# Admin Scripts

This directory contains scripts for maintainers to manage secrets:

- `decrypt_secrets.py`: Decrypts `secrets.yml.encrypted` to `secrets.yml` for editing.
- `encrypt_secrets.py`: Encrypts `secrets.yml` back to `secrets.yml.encrypted` after updates.

**Usage:**

```sh
python scripts/admin/decrypt_secrets.py
# Edit secrets.yml as needed
python scripts/admin/encrypt_secrets.py
```

**Note:** These scripts require the key file at `$HOME/.purestorage/se-lab-melau.key` and the `cryptography` package installed in your Python environment.
