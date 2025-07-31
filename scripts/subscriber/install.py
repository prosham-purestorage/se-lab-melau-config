"""
install.py: Sets up Python virtual environment and installs dependencies.
"""
import subprocess
import sys
from pathlib import Path

VENV_DIR = Path('.venv')
REQUIREMENTS = ['cryptography', 'pyyaml']

def run(cmd, check=True):
    print(f"Running: {' '.join(cmd)}")
    subprocess.run(cmd, check=check)

def create_venv():
    if VENV_DIR.exists():
        print(f"Virtualenv already exists at {VENV_DIR}")
        return
    run([sys.executable, '-m', 'venv', str(VENV_DIR)])
    print(f"Created virtualenv at {VENV_DIR}")

def install_requirements():
    pip_path = VENV_DIR / 'bin' / 'pip'
    for pkg in REQUIREMENTS:
        run([str(pip_path), 'install', pkg])
    print("Dependencies installed.")

def main():
    create_venv()
    install_requirements()
    print("Setup complete. Activate with 'source .venv/bin/activate'")

if __name__ == '__main__':
    main()
