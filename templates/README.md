# Templates for Subscriber Repositories

This directory contains template files to help subscribers get started with the SE Lab Melbourne configuration system.

## Makefile.subscriber

A ready-to-use Makefile template for subscriber repositories that use this config repo as a git submodule.

### Quick Setup for Subscribers

1. **Add this repo as a submodule to your project:**
   ```bash
   cd your-project
   git submodule add <this-repo-url> config/shared
   git submodule update --init --recursive
   ```

2. **Copy the Makefile template to your repo root:**
   ```bash
   cp config/shared/templates/Makefile.subscriber ./Makefile
   ```

3. **Ensure you have the decryption key:**
   ```bash
   # The key should be at ~/.purestorage/se-lab-melau.key
   # Contact the SE Lab Melbourne team if you need the key
   ```

4. **Generate your configuration files:**
   ```bash
   make config
   ```

### Available Make Targets

- `make help` - Show available commands and setup instructions
- `make install` - Set up virtual environment and dependencies (run once)
- `make config` - Generate all configuration files (env, json, ps1)
- `make clean` - Remove generated configuration files
- `make update-submodule` - Update the config submodule to the latest version

### Generated Files

The `make config` command will create these files in the `export/` directory:

- **export/lab-config.env** - Shell environment variables format
- **export/lab-config.json** - JSON format for applications
- **export/lab-config.ps1** - PowerShell variables format

All files are created with secure permissions (mode 400 - read-only for owner).

### Integration Examples

#### Bash/Shell Scripts
```bash
# Source the environment variables
source export/lab-config.env

# Use the variables
echo "vCenter server: $VCENTER_HOST"
```

#### Python Applications
```python
import json

# Load JSON config
with open('export/lab-config.json', 'r') as f:
    config = json.load(f)

vcenter_host = config['VCENTER_HOST']
```

#### PowerShell Scripts
```powershell
# Load PowerShell variables
. .\export\lab-config.ps1

# Use the variables
Write-Host "vCenter server: $VCENTER_HOST"
```

### Security Notes

- Configuration files are automatically created with mode 400 (read-only for owner)
- Never commit the `export/` directory to version control
- Keep the decryption key secure and don't commit it to any repository
- The config files contain sensitive information - handle appropriately

### Troubleshooting

If you encounter issues:

1. **Make sure the submodule is properly initialized:**
   ```bash
   git submodule update --init --recursive
   ```

2. **Verify the decryption key exists:**
   ```bash
   ls -la ~/.purestorage/se-lab-melau.key
   ```

3. **Check Python version (requires Python 3.6+):**
   ```bash
   python3 --version
   ```

4. **Run the install step explicitly:**
   ```bash
   make install
   ```

For additional support, contact the SE Lab Melbourne team.
