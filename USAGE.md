# SE Lab Config Usage Instructions

## For Subscriber Repositories

### 1. Update Submodule
```
git submodule update --remote config/shared
```

### 2. Decrypt Secrets (if needed)
Secrets are stored encrypted for security. You must have the key file:
```
$HOME/.purestorage/se-lab-melau.key
```

No manual decryption is needed if you use the provided automation script below.

### 3. Setup Python Environment and Export Configs

### 2. Install Python Environment
Run the install script to create a virtual environment and install dependencies:
```
python config/shared/scripts/install.py
```
This will:
- Create a Python virtual environment (`.venv`)
- Install required Python packages (`cryptography`, `pyyaml`)

### 3. Export Configs
Run the update script to decrypt secrets, merge with config, and generate output files:
```
python config/shared/scripts/update.py --type env --output config/shared/export/lab-config.env
python config/shared/scripts/update.py --type json --output config/shared/export/lab-config.json
python config/shared/scripts/update.py --type ps1 --output config/shared/export/vmware-config.ps1
```
You can specify custom output paths and types as needed.

### 4. Use Generated Files
- **lab-config.env**: Source in shell scripts, Ansible, etc.
- **lab-config.json**: Use in Python, Node.js, or other tools
- **vmware-config.ps1**: Use in PowerShell automation

## Requirements
- Python 3.7+
- Access to the secrets key file

## Security
- Only encrypted secrets are stored in GitHub
- Key file is managed and distributed securely

## Troubleshooting
- If you see import errors, run:
  ```
  .venv/bin/pip install cryptography pyyaml
  ```
- If you need to reset the environment:
  ```
  rm -rf .venv
  python config/shared/scripts/install.py
  ```

## Updating Configs
Whenever the upstream config or secrets change, repeat steps 1–3 to pull the latest and regenerate your local files.

---
For more details, see the comments in `lab-config.yml` and `scripts/export-config.py`.
