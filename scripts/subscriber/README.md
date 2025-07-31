# Subscriber Scripts

This directory contains scripts for consumers to generate config files from encrypted secrets and config:

- `install.py`: Sets up Python virtual environment and installs dependencies.
- `update.py`: Runs config/secrets export and generates output files (`.env`, `.json`, `.ps1`).

**Usage:**

```sh
python config/shared/scripts/subscriber/install.py
python config/shared/scripts/subscriber/update.py --type env --output config/shared/export/lab-config.env
python config/shared/scripts/subscriber/update.py --type json --output config/shared/export/lab-config.json
python config/shared/scripts/subscriber/update.py --type ps1 --output config/shared/export/vmware-config.ps1
```

**Note:** These scripts require the key file at `$HOME/.purestorage/se-lab-melau.key` and Python 3.7+.
