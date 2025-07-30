# Integration Guide for prosham-purestorage/se-lab-melau-config

## Quick Integration

### For se-lab-melau-webconsole
```bash
git submodule add https://github.com/prosham-purestorage/se-lab-melau-config.git config/shared
source config/shared/export/lab-config.env
```

### For se-lab-melau-vmtemplates  
```powershell
git submodule add https://github.com/prosham-purestorage/se-lab-melau-config.git config/shared
. ./config/shared/export/vmware-config.ps1
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
