"""
update.py: Runs config/secrets export with flexible output options.
"""
import argparse
import subprocess
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[3] if len(Path(__file__).resolve().parents) > 2 else Path.cwd()
VENV_DIR = REPO_ROOT / '.venv'
EXPORT_SCRIPT = Path(__file__).parent / 'export-config.py'

def run_in_venv(args):
    python_path = VENV_DIR / 'bin' / 'python'
    cmd = [str(python_path), str(EXPORT_SCRIPT)] + args
    print(f"Running: {' '.join(cmd)}")
    subprocess.run(cmd, check=True)

def main():
    parser = argparse.ArgumentParser(description="Update and export config/secrets files.")
    parser.add_argument('--type', choices=['env', 'json', 'ps1'], required=True, help='Output file type')
    parser.add_argument('--output', required=True, help='Output file path')
    parser.add_argument('--config', default='lab-config.yml', help='Config YAML path')
    parser.add_argument('--secrets', default='secrets.yml.encrypted', help='Encrypted secrets file path')
    parser.add_argument('--key', default=str(Path.home() / '.purestorage/se-lab-melau.key'), help='Key file path')
    args = parser.parse_args()

    export_args = [
        '--type', args.type,
        '--output', args.output,
        '--config', args.config,
        '--secrets', args.secrets,
        '--key', args.key
    ]
    run_in_venv(export_args)

if __name__ == '__main__':
    main()
