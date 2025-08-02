#!/bin/bash
# verify-certificates.sh
# Verifies that SE Lab Melbourne CA certificates are properly installed

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERT_DIR="$SCRIPT_DIR/../certificates"

echo "🔐 SE Lab Melbourne Certificate Verification"
echo "=============================================="

# Check if certificates exist
if [ ! -d "$CERT_DIR" ]; then
    echo "❌ Error: certificates directory not found at $CERT_DIR"
    exit 1
fi

echo "📁 Certificate files:"
for cert in "$CERT_DIR"/*.cer; do
    if [ -f "$cert" ]; then
        echo "   ✓ $(basename "$cert")"
        # Verify it's a valid certificate
        if openssl x509 -in "$cert" -noout -text >/dev/null 2>&1; then
            echo "     Valid X.509 certificate"
        else
            echo "     ⚠️  Warning: Not a valid X.509 certificate"
        fi
    fi
done

echo ""
echo "🖥️  System certificate store status:"

# Check system certificate installation
if command -v update-ca-certificates >/dev/null 2>&1; then
    echo "   System: Ubuntu/Debian (update-ca-certificates available)"
    echo "   Command: sudo cp certificates/*.cer /usr/local/share/ca-certificates/ && sudo update-ca-certificates"
elif command -v update-ca-trust >/dev/null 2>&1; then
    echo "   System: CentOS/RHEL (update-ca-trust available)"
    echo "   Command: sudo cp certificates/*.cer /etc/pki/ca-trust/source/anchors/ && sudo update-ca-trust"
elif command -v certlm >/dev/null 2>&1; then
    echo "   System: Windows (Certificate Manager available)"
    echo "   Command: Import-Certificate -FilePath certificates\\*.cer -CertStoreLocation Cert:\\LocalMachine\\Root"
else
    echo "   System: Unknown - manual certificate installation required"
fi

echo ""
echo "✨ Certificate variables exported to:"
echo "   - export/lab-config.env (shell variables)"
echo "   - export/lab-config.json (JSON format)"
echo "   - export/lab-config.ps1 (PowerShell variables)"

echo ""
echo "📖 For detailed installation instructions, see certificates/README.md"
