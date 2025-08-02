# SE Lab Melbourne - CA Certificates

This directory contains the CA certificates required for SE Lab Melbourne infrastructure.

## Certificate Files

### `keyfactor-purestorage.cer`
- **Purpose**: Pure Storage Keyfactor PKI Infrastructure Certificate
- **Issuer**: PURE_STORAGE-RCA (Root CA)
- **Valid Until**: 2032-01-11
- **Usage**: Used for authenticating Pure Storage internal services and APIs

### `mel-au-ad-certsrv.cer`
- **Purpose**: Melbourne Lab Active Directory Certificate Services CA
- **Issuer**: mel-PSTG-MGMT-AD1-CA-1
- **Valid Until**: 2033-07-31
- **Usage**: Used for domain authentication and LDAPS connections

### `ca_bundle.cer`
- **Purpose**: Combined CA certificate bundle
- **Contents**: Contains both Pure Storage and Melbourne Lab CA certificates
- **Usage**: Complete certificate chain for all lab services

## Usage

These certificates should be installed on systems that need to:
- Connect to Pure Storage management APIs
- Authenticate against Melbourne Lab Active Directory
- Establish secure LDAPS connections
- Validate SSL certificates from lab services

## Installation

### Ubuntu/Debian Systems
```bash
# Copy certificates to system CA store
sudo cp certificates/*.cer /usr/local/share/ca-certificates/
sudo update-ca-certificates
```

### CentOS/RHEL Systems
```bash
# Copy certificates to system CA store
sudo cp certificates/*.cer /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust
```

### Windows Systems
```powershell
# Import certificates to Trusted Root CA store
certlm.msc  # Or use PowerShell
Import-Certificate -FilePath "certificates\*.cer" -CertStoreLocation Cert:\LocalMachine\Root
```

## Automation

These certificates are automatically included in:
- VM template creation
- Configuration exports
- Infrastructure automation scripts
