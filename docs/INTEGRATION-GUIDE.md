# Integration Guide for prosham-purestorage/se-lab-melau-config

## Admin Workflow: Key Setup & Secret Management

### 1. Set Up the Encryption Key

Place the key file at:

```sh
$HOME/.purestorage/se-lab-melau.key
```

(Distribute securely. Never commit this file to version control.)

### 2. Decrypt Secrets for Editing

```sh
python scripts/admin/decrypt_secrets.py
```

### 3. Edit Configuration

- Edit `lab-config.yml` for config changes
- Edit `secrets.yml` for secret changes

### 4. Re-encrypt Secrets

```sh
python scripts/admin/encrypt_secrets.py
```

Commit and push your changes to the repository.

---

## Consumer Workflow: Integration & Config Generation

### 1. Add Submodule

```sh
git submodule add https://github.com/prosham-purestorage/se-lab-melau-config.git config/shared
```

### 2. Install Python Environment

```sh
python config/shared/scripts/subscriber/install.py
```

### 3. Generate Config Files

Generate the required config files for your project:

#### For se-lab-melau-webconsole (shell/Ansible)

```sh
python config/shared/scripts/subscriber/update.py --type env --output config/shared/export/lab-config.env
source config/shared/export/lab-config.env
```

#### For se-lab-melau-vmtemplates (PowerShell)

```powershell
python config/shared/scripts/subscriber/update.py --type ps1 --output config/shared/export/vmware-config.ps1
. ./config/shared/export/vmware-config.ps1
```

#### For JSON-based consumers

```sh
python config/shared/scripts/subscriber/update.py --type json --output config/shared/export/lab-config.json
# Use config/shared/export/lab-config.json in your app
```

## Available Exports

- `export/lab-config.env` - Environment variables
- `export/lab-config.json` - JSON configuration
- `export/vmware-config.ps1` - PowerShell variables

## Benefits

- ✅ Single source of truth
- ✅ Consistent configuration across repos
- ✅ Centralized credential management
- ✅ Automatic updates via submodules
