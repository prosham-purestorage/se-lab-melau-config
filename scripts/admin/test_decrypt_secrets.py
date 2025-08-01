import sys
from pathlib import Path
import importlib.util

def find_export_config():
    """Find export-config.py in either subscriber/ or config/shared/scripts/subscriber/"""
    current_dir = Path(__file__).resolve().parent
    
    # Check for subscriber repo structure (config/shared/scripts/subscriber/)
    config_path = current_dir.parent.parent / 'config' / 'shared' / 'scripts' / 'subscriber' / 'export-config.py'
    if config_path.exists():
        return config_path
    
    # Check for source repo structure (scripts/subscriber/)
    source_path = current_dir.parent / 'subscriber' / 'export-config.py'
    if source_path.exists():
        return source_path
    
    raise FileNotFoundError("Could not find export-config.py in expected locations")

def load_export_config():
    """Dynamically load export-config.py module"""
    config_path = find_export_config()
    spec = importlib.util.spec_from_file_location("export_config", config_path)
    export_config = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(export_config)
    return export_config

if __name__ == "__main__":
    export_config = load_export_config()
    
    # Find secrets file relative to repo root
    current_dir = Path(__file__).resolve().parent
    repo_root = current_dir.parent.parent  # Go up from scripts/admin/ to repo root
    
    # Check for subscriber repo structure first
    config_secrets = repo_root / 'config' / 'shared' / 'secrets.yml.encrypted'
    if config_secrets.exists():
        secrets_file = str(config_secrets)
    else:
        # Source repo structure
        secrets_file = str(repo_root / 'secrets.yml.encrypted')
    
    key_file = str(Path.home() / ".purestorage/se-lab-melau.key")
    secrets = export_config.decrypt_secrets(secrets_file, key_file)
    print("Decrypted secrets:\n", secrets)
