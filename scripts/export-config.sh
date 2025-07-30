#!/bin/bash
# Export Lab Configuration for Consumer Repositories

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXPORT_DIR="$PROJECT_ROOT/export"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔄 Exporting SE Lab Configuration${NC}"
echo -e "${BLUE}===============================${NC}"

mkdir -p "$EXPORT_DIR"

# Export environment variables
echo -e "${YELLOW}📄 Generating lab-config.env...${NC}"
cat > "$EXPORT_DIR/lab-config.env" << 'ENVEOF'
# Pure Storage SE Lab Melbourne - Shared Configuration
# Generated for consumption by prosham-purestorage repositories

# Lab Information
LAB_NAME=Melbourne_SE_Lab
LAB_LOCATION=Melbourne_Australia
LAB_CONTACT=prosham@purestorage.com
LAB_VERSION=1.0.0
LAB_ORGANIZATION=prosham-purestorage

# VMware Infrastructure
VCENTER_SERVER=pstg-mgmt-vcsa1.mel.aulab.purestorage.com
VCENTER_DATACENTER=Melbourne-SE-Lab
VCENTER_CLUSTER=Pure-Mgmt-Cluster
VCENTER_DATASTORE=Pure-Mgmt-Local-SSD1
VCENTER_NETWORK=VM Network
VCENTER_TEMPLATE_FOLDER=Templates

# Active Directory
AD_DOMAIN=mel.aulab.purestorage.com
AD_LDAP_URL=ldaps://pstg-mgmt-ad1.mel.aulab.purestorage.com:389
AD_SEARCH_BASE=dc=mel,dc=aulab,dc=purestorage,dc=com
AD_BIND_DN=cn=purebind@mel.aulab.purestorage.com

# Network Configuration
LAB_SUBNET=10.112.0.0/24
LAB_GATEWAY=10.112.0.1
LAB_DNS_PRIMARY=10.112.0.11
LAB_DNS_SECONDARY=10.112.0.12

# VM Template Specifications
UBUNTU_TEMPLATE_NAME=pr-ubuntu-template
UBUNTU_TEMPLATE_CPU=2
UBUNTU_TEMPLATE_MEMORY=4
UBUNTU_TEMPLATE_DISK=20

WINDOWS_SERVER_TEMPLATE_NAME=pr-windows-server-template
WINDOWS_SERVER_TEMPLATE_CPU=4
WINDOWS_SERVER_TEMPLATE_MEMORY=8
WINDOWS_SERVER_TEMPLATE_DISK=60

WINDOWS_CLIENT_TEMPLATE_NAME=pr-windows-client-template
WINDOWS_CLIENT_TEMPLATE_CPU=2
WINDOWS_CLIENT_TEMPLATE_MEMORY=8
WINDOWS_CLIENT_TEMPLATE_DISK=60

# Service Configuration
WEB_CONSOLE_PORT=3000
WEB_CONSOLE_VM_IP=10.112.0.11
WEB_CONSOLE_VM_HOSTNAME=pstg-mgmt-admin

# RDS Configuration
RDS_SERVER_IP=10.112.0.11
RDS_GATEWAY_HOST=pstg-mgmt-rds.mel.aulab.purestorage.com
RDS_WEB_ACCESS_URL=https://pstg-mgmt-rds.mel.aulab.purestorage.com/rdweb
RDS_FARM_NAME=Pure-SE-Lab-RDS

# Repository URLs
CONFIG_REPO=https://github.com/prosham-purestorage/se-lab-melau-config
WEBCONSOLE_REPO=https://github.com/prosham-purestorage/se-lab-melau-webconsole
VMTEMPLATES_REPO=https://github.com/prosham-purestorage/se-lab-melau-vmtemplates

# Security
SECRETS_KEYFILE_PATH=$HOME/.purestorage/se-lab-melau.key
SECRETS_ENCRYPTION_METHOD=aes-256-cbc
ENVEOF

# Export PowerShell configuration
echo -e "${YELLOW}📄 Generating vmware-config.ps1...${NC}"
cat > "$EXPORT_DIR/vmware-config.ps1" << 'PSEOF'
# Pure Storage SE Lab Melbourne - PowerShell Configuration
# Variables for VMware automation and template creation

# VMware Infrastructure
$Global:LabVCenterServer = "pstg-mgmt-vcsa1.mel.aulab.purestorage.com"
$Global:LabDatacenter = "Melbourne-SE-Lab"
$Global:LabCluster = "Pure-Mgmt-Cluster"
$Global:LabDatastore = "Pure-Mgmt-Local-SSD1"
$Global:LabNetwork = "VM Network"
$Global:LabTemplateFolder = "Templates"

# Domain Configuration
$Global:LabDomain = "mel.aulab.purestorage.com"
$Global:LabDomainController = "pstg-mgmt-ad1.mel.aulab.purestorage.com"

# Network Settings
$Global:LabSubnet = "10.112.0.0"
$Global:LabSubnetMask = "255.255.255.0"
$Global:LabGateway = "10.112.0.1"
$Global:LabDNSPrimary = "10.112.0.11"
$Global:LabDNSSecondary = "10.112.0.12"

# VM Template Configurations
$Global:UbuntuTemplate = @{
    Name = "pr-ubuntu-template"
    CPU = 2
    MemoryGB = 4
    DiskGB = 20
    GuestOS = "ubuntu64Guest"
    Network = $Global:LabNetwork
}

$Global:WindowsServerTemplate = @{
    Name = "pr-windows-server-template"
    CPU = 4
    MemoryGB = 8
    DiskGB = 60
    GuestOS = "windows2019srvNext_64Guest"
    Network = $Global:LabNetwork
}

$Global:WindowsClientTemplate = @{
    Name = "pr-windows-client-template"
    CPU = 2
    MemoryGB = 8
    DiskGB = 60
    GuestOS = "windows11_64Guest"
    Network = $Global:LabNetwork
}

# Repository Information
$Global:ConfigRepo = "https://github.com/prosham-purestorage/se-lab-melau-config"
$Global:WebConsoleRepo = "https://github.com/prosham-purestorage/se-lab-melau-webconsole"
$Global:VMTemplatesRepo = "https://github.com/prosham-purestorage/se-lab-melau-vmtemplates"

Write-Host "✅ Pure Storage SE Lab Melbourne configuration loaded" -ForegroundColor Green
Write-Host "🏗  Ready for VMware automation with prosham-purestorage repositories" -ForegroundColor Cyan
PSEOF

# Export JSON configuration
echo -e "${YELLOW}📄 Generating lab-config.json...${NC}"
if command -v python3 &> /dev/null; then
    python3 << 'PYEOF' > "$EXPORT_DIR/lab-config.json"
import yaml
import json

with open('lab-config.yml', 'r') as f:
    config = yaml.safe_load(f)

print(json.dumps(config, indent=2))
PYEOF
else
    echo '{"error": "Python3 not available - install PyYAML for JSON export"}' > "$EXPORT_DIR/lab-config.json"
fi

echo -e "${GREEN}✅ Configuration export completed${NC}"
echo -e "${BLUE}📦 Generated files in export/ directory:${NC}"
echo -e "  📄 lab-config.env - Environment variables"
echo -e "  📄 lab-config.json - JSON configuration"
echo -e "  📄 vmware-config.ps1 - PowerShell variables"
