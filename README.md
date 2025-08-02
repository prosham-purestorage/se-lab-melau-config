# SE Lab Melbourne Configuration Management

Automated configuration and secrets management system for SE Lab Melbourne infrastructure. This repository provides secure, encrypted configuration distribution using Python automation with cross-repository support.

## 🚀 Features

- **Secure Configuration Management**: AES-256-CBC encrypted secrets with automatic cleanup
- **Multi-Format Export**: Generate configuration in env, json, and ps1 formats
- **Cross-Repository Support**: Works as standalone repo or git submodule
- **CA Certificate Management**: Integrated Pure Storage and Melbourne Lab CA certificates
- **Automated Testing**: Comprehensive test suite including subscriber workflow simulation
- **File Security**: All exports use mode 400 permissions (read-only for owner)

## 📁 Repository Structure

```
├── lab-config.yml              # Main configuration file
├── secrets.yml.encrypted       # Encrypted secrets (AES-256-CBC)
├── certificates/               # CA certificates for lab infrastructure
│   ├── ca_bundle.cer          # Combined CA certificate bundle
│   ├── keyfactor-purestorage.cer # Pure Storage PKI CA
│   ├── mel-au-ad-certsrv.cer  # Melbourne Lab AD Certificate Services CA
│   └── README.md              # Certificate documentation
├── scripts/
│   ├── admin/                  # Admin tools for repo maintainers
│   │   ├── encrypt_secrets.py  # Encrypt secrets with auto-cleanup
│   │   └── test_*.py          # Test suite
│   └── subscriber/             # Tools for config consumers
│       ├── install.py         # Setup virtual environment
│       ├── update.py          # Main export interface
│       └── export-config.py   # Multi-format export engine
├── templates/                  # Templates for subscriber repos
│   ├── Makefile.subscriber    # Ready-to-use Makefile template
│   └── README.md             # Subscriber setup guide
└── Makefile                   # Admin testing and development
```

## 🔧 For Subscribers (Configuration Consumers)

If you need to use the SE Lab Melbourne configuration in your project:

### Quick Start

1. **Add as git submodule:**
   ```bash
   cd your-project
   git submodule add <this-repo-url> config/shared
   ```

2. **Copy the Makefile template:**
   ```bash
   cp config/shared/templates/Makefile.subscriber ./Makefile
   ```

3. **Get the decryption key** (contact SE Lab Melbourne team)

4. **Generate configuration files:**
   ```bash
   make config
   ```

### Generated Files

Your `export/` directory will contain:
- `lab-config.env` - Shell environment variables
- `lab-config.json` - JSON format for applications  
- `lab-config.ps1` - PowerShell variables

**📖 See [templates/README.md](templates/README.md) for detailed subscriber documentation**

## 🛠️ For Administrators (Repo Maintainers)

### Setup Development Environment

```bash
# Clone the repository
git clone <repo-url>
cd se-lab-melau-config

# Set up virtual environment and dependencies
python3 scripts/subscriber/install.py
```

### Managing Secrets

```bash
# Edit secrets (creates temporary secrets.yml)
# Edit the file, then encrypt it:
python3 scripts/admin/encrypt_secrets.py
# This automatically removes the unencrypted file
```

### Testing

```bash
# Run all tests
make tests

# Individual test targets
make test-decrypt      # Test secrets decryption
make test-export       # Test config export functionality  
make test-subscriber   # Test full subscriber workflow simulation
```

### Development Workflow

1. **Edit Configuration**: Modify `lab-config.yml` for non-secret config
2. **Edit Secrets**: Create `secrets.yml`, edit it, then run `encrypt_secrets.py`
3. **Test Changes**: Run `make tests` to validate all functionality
4. **Commit**: All tests must pass before committing

## 🔐 Security Features

- **AES-256-CBC Encryption**: Industry-standard encryption for secrets
- **Automatic Cleanup**: Unencrypted secrets automatically removed after encryption
- **Secure Permissions**: All generated config files use mode 400 (owner read-only)
- **No Plain Text**: Secrets never stored unencrypted in the repository

## 🧪 Testing Framework

The repository includes comprehensive testing:

- **Decryption Tests**: Validate secret decryption functionality
- **Export Tests**: Test all output formats (env, json, ps1)
- **Subscriber Simulation**: Full end-to-end testing in simulated submodule environment
- **Cross-Platform**: Tested on macOS and Linux

## 📋 Prerequisites

- Python 3.6 or higher
- Git (for submodule functionality)
- Make (for automated workflows)
- Decryption key (provided by SE Lab Melbourne team)

## 🆘 Support

For questions, issues, or access to decryption keys, contact the SE Lab Melbourne team.

## 📄 License

This repository contains proprietary configuration for SE Lab Melbourne infrastructure. Access is restricted to authorized personnel only.
