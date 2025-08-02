#!/bin/bash
# template-pipeline-status.sh
# Shows the status of the VM template creation pipeline

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/.."

echo "🏭 VM Template Creation Pipeline Status"
echo "======================================="
echo ""

# Extract specific variables safely
ENV_FILE="$CONFIG_DIR/export/lab-config.env"
if [ -f "$ENV_FILE" ]; then
    # Extract infrastructure variables
    VCENTER_FOLDER=$(grep "^VM_TEMPLATE_PIPELINE_INFRASTRUCTURE_VCENTER_FOLDER=" "$ENV_FILE" | cut -d'=' -f2)
    CONTENT_LIBRARY=$(grep "^VM_TEMPLATE_PIPELINE_INFRASTRUCTURE_CONTENT_LIBRARY=" "$ENV_FILE" | cut -d'=' -f2)
    REPOSITORY=$(grep "^VM_TEMPLATE_PIPELINE_INFRASTRUCTURE_REPOSITORY=" "$ENV_FILE" | cut -d'=' -f2)
    
    # Extract candidate VM variables
    UBUNTU_2204_CANDIDATE_VM=$(grep "^VM_TEMPLATE_PIPELINE_CANDIDATE_VMS_UBUNTU_2204_CANDIDATE_VM_NAME=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2204_CANDIDATE_STATUS=$(grep "^VM_TEMPLATE_PIPELINE_CANDIDATE_VMS_UBUNTU_2204_CANDIDATE_STATUS=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2404_CANDIDATE_VM=$(grep "^VM_TEMPLATE_PIPELINE_CANDIDATE_VMS_UBUNTU_2404_CANDIDATE_VM_NAME=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2404_CANDIDATE_STATUS=$(grep "^VM_TEMPLATE_PIPELINE_CANDIDATE_VMS_UBUNTU_2404_CANDIDATE_STATUS=" "$ENV_FILE" | cut -d'=' -f2)
    WINDOWS_2022_CANDIDATE_VM=$(grep "^VM_TEMPLATE_PIPELINE_CANDIDATE_VMS_WINDOWS_2022_CANDIDATE_VM_NAME=" "$ENV_FILE" | cut -d'=' -f2)
    WINDOWS_2022_CANDIDATE_STATUS=$(grep "^VM_TEMPLATE_PIPELINE_CANDIDATE_VMS_WINDOWS_2022_CANDIDATE_STATUS=" "$ENV_FILE" | cut -d'=' -f2)
    
    # Extract source template variables  
    UBUNTU_2204_SINGLE_TEMPLATE=$(grep "^VM_TEMPLATE_PIPELINE_SOURCE_TEMPLATES_UBUNTU_2204_SINGLE_HOMED_TEMPLATE_NAME=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2204_SINGLE_STATUS=$(grep "^VM_TEMPLATE_PIPELINE_SOURCE_TEMPLATES_UBUNTU_2204_SINGLE_HOMED_STATUS=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2204_DUAL_TEMPLATE=$(grep "^VM_TEMPLATE_PIPELINE_SOURCE_TEMPLATES_UBUNTU_2204_DUAL_HOMED_TEMPLATE_NAME=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2204_DUAL_STATUS=$(grep "^VM_TEMPLATE_PIPELINE_SOURCE_TEMPLATES_UBUNTU_2204_DUAL_HOMED_STATUS=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2404_SINGLE_TEMPLATE=$(grep "^VM_TEMPLATE_PIPELINE_SOURCE_TEMPLATES_UBUNTU_2404_SINGLE_HOMED_TEMPLATE_NAME=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2404_SINGLE_STATUS=$(grep "^VM_TEMPLATE_PIPELINE_SOURCE_TEMPLATES_UBUNTU_2404_SINGLE_HOMED_STATUS=" "$ENV_FILE" | cut -d'=' -f2)
    WINDOWS_2022_SINGLE_TEMPLATE=$(grep "^VM_TEMPLATE_PIPELINE_SOURCE_TEMPLATES_WINDOWS_2022_SINGLE_HOMED_TEMPLATE_NAME=" "$ENV_FILE" | cut -d'=' -f2)
    WINDOWS_2022_SINGLE_STATUS=$(grep "^VM_TEMPLATE_PIPELINE_SOURCE_TEMPLATES_WINDOWS_2022_SINGLE_HOMED_STATUS=" "$ENV_FILE" | cut -d'=' -f2)
    
    # Extract content library OVA variables
    UBUNTU_2204_BASE_OVA=$(grep "^VM_TEMPLATE_PIPELINE_CONTENT_LIBRARY_OVAS_UBUNTU_2204_BASE_OVA_NAME=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2204_BASE_STATUS=$(grep "^VM_TEMPLATE_PIPELINE_CONTENT_LIBRARY_OVAS_UBUNTU_2204_BASE_STATUS=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2204_BASE_VERSION=$(grep "^VM_TEMPLATE_PIPELINE_CONTENT_LIBRARY_OVAS_UBUNTU_2204_BASE_VERSION=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2204_DUAL_OVA=$(grep "^VM_TEMPLATE_PIPELINE_CONTENT_LIBRARY_OVAS_UBUNTU_2204_DUAL_OVA_NAME=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2204_DUAL_OVA_STATUS=$(grep "^VM_TEMPLATE_PIPELINE_CONTENT_LIBRARY_OVAS_UBUNTU_2204_DUAL_STATUS=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2204_DUAL_VERSION=$(grep "^VM_TEMPLATE_PIPELINE_CONTENT_LIBRARY_OVAS_UBUNTU_2204_DUAL_VERSION=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2404_BASE_OVA=$(grep "^VM_TEMPLATE_PIPELINE_CONTENT_LIBRARY_OVAS_UBUNTU_2404_BASE_OVA_NAME=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2404_BASE_STATUS=$(grep "^VM_TEMPLATE_PIPELINE_CONTENT_LIBRARY_OVAS_UBUNTU_2404_BASE_STATUS=" "$ENV_FILE" | cut -d'=' -f2)
    UBUNTU_2404_BASE_VERSION=$(grep "^VM_TEMPLATE_PIPELINE_CONTENT_LIBRARY_OVAS_UBUNTU_2404_BASE_VERSION=" "$ENV_FILE" | cut -d'=' -f2)
    WINDOWS_2022_BASE_OVA=$(grep "^VM_TEMPLATE_PIPELINE_CONTENT_LIBRARY_OVAS_WINDOWS_2022_BASE_OVA_NAME=" "$ENV_FILE" | cut -d'=' -f2)
    WINDOWS_2022_BASE_STATUS=$(grep "^VM_TEMPLATE_PIPELINE_CONTENT_LIBRARY_OVAS_WINDOWS_2022_BASE_STATUS=" "$ENV_FILE" | cut -d'=' -f2)
    WINDOWS_2022_BASE_VERSION=$(grep "^VM_TEMPLATE_PIPELINE_CONTENT_LIBRARY_OVAS_WINDOWS_2022_BASE_VERSION=" "$ENV_FILE" | cut -d'=' -f2)
else
    echo "❌ Error: Configuration not exported. Run 'make export' first."
    exit 1
fi

echo "📍 Infrastructure:"
echo "   vCenter Folder: $VCENTER_FOLDER"
echo "   Content Library: $CONTENT_LIBRARY"
echo "   Repository: $REPOSITORY"
echo ""

echo "🖥️  Candidate VMs (for installation & customization):"
echo "   ┌─────────────────────────────────────────────────────────┬──────────┐"
echo "   │ VM Name                                                 │ Status   │"
echo "   ├─────────────────────────────────────────────────────────┼──────────┤"
printf "   │ %-55s │ %-8s │\n" "$UBUNTU_2204_CANDIDATE_VM" "$UBUNTU_2204_CANDIDATE_STATUS"
printf "   │ %-55s │ %-8s │\n" "$UBUNTU_2404_CANDIDATE_VM" "$UBUNTU_2404_CANDIDATE_STATUS"
printf "   │ %-55s │ %-8s │\n" "$WINDOWS_2022_CANDIDATE_VM" "$WINDOWS_2022_CANDIDATE_STATUS"
echo "   └─────────────────────────────────────────────────────────┴──────────┘"
echo ""

echo "📋 Source Templates (in vCenter folder):"
echo "   ┌─────────────────────────────────────────────────────────┬──────────┐"
echo "   │ Template Name                                           │ Status   │"
echo "   ├─────────────────────────────────────────────────────────┼──────────┤"
printf "   │ %-55s │ %-8s │\n" "$UBUNTU_2204_SINGLE_TEMPLATE" "$UBUNTU_2204_SINGLE_STATUS"
printf "   │ %-55s │ %-8s │\n" "$UBUNTU_2204_DUAL_TEMPLATE" "$UBUNTU_2204_DUAL_STATUS"
printf "   │ %-55s │ %-8s │\n" "$UBUNTU_2404_SINGLE_TEMPLATE" "$UBUNTU_2404_SINGLE_STATUS"
printf "   │ %-55s │ %-8s │\n" "$WINDOWS_2022_SINGLE_TEMPLATE" "$WINDOWS_2022_SINGLE_STATUS"
echo "   └─────────────────────────────────────────────────────────┴──────────┘"
echo ""

echo "📦 Content Library OVAs (ready for deployment):"
echo "   ┌─────────────────────────────────────────────────────────┬──────────┬─────────┐"
echo "   │ OVA Name                                                │ Status   │ Version │"
echo "   ├─────────────────────────────────────────────────────────┼──────────┼─────────┤"
printf "   │ %-55s │ %-8s │ %-7s │\n" "$UBUNTU_2204_BASE_OVA" "$UBUNTU_2204_BASE_STATUS" "$UBUNTU_2204_BASE_VERSION"
printf "   │ %-55s │ %-8s │ %-7s │\n" "$UBUNTU_2204_DUAL_OVA" "$UBUNTU_2204_DUAL_OVA_STATUS" "$UBUNTU_2204_DUAL_VERSION"
printf "   │ %-55s │ %-8s │ %-7s │\n" "$UBUNTU_2404_BASE_OVA" "$UBUNTU_2404_BASE_STATUS" "$UBUNTU_2404_BASE_VERSION"
printf "   │ %-55s │ %-8s │ %-7s │\n" "$WINDOWS_2022_BASE_OVA" "$WINDOWS_2022_BASE_STATUS" "$WINDOWS_2022_BASE_VERSION"
echo "   └─────────────────────────────────────────────────────────┴──────────┴─────────┘"
echo ""

echo "🔧 Pipeline Workflow:"
echo "   1. Build Candidate VMs from base ISOs"
echo "   2. Run installation scripts (OS setup, domain join, security)"
echo "   3. Run customization scripts (tools, configuration)"
echo "   4. Create Source Templates in vCenter folder"
echo "   5. Export to Content Library as OVAs"
echo "   6. Deploy from Content Library for production use"
echo ""

echo "📋 Status Legend:"
echo "   planned  - Scheduled for creation"
echo "   active   - Currently running/available"
echo "   building - In progress"
echo "   ready    - Completed and available"
echo "   exported - Available in content library"
echo ""

echo "💡 Use these scripts to manage the pipeline:"
echo "   scripts/build-candidate-vm.sh <vm_name>     - Build a candidate VM"
echo "   scripts/customize-candidate.sh <vm_name>    - Run customization scripts"
echo "   scripts/create-source-template.sh <vm_name> - Create source template"
echo "   scripts/export-to-ova.sh <template_name>    - Export to content library"
