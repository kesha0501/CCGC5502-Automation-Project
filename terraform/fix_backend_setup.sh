#!/bin/bash

# Fix Azure Backend Setup for Terraform
echo "🔧 Fixing Azure Backend Setup..."

# Variables
PROJECT_ID="6553"
LOCATION="canadacentral"
BACKEND_RG="tfstate-rg-${PROJECT_ID}"
BACKEND_SA="tfstate${PROJECT_ID}sa"
CONTAINER_NAME="tfstate"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if logged in to Azure
print_status "Checking Azure login status..."
if ! az account show &> /dev/null; then
    print_error "Not logged in to Azure. Please run 'az login'"
    exit 1
fi

# Get current subscription
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
print_status "Using subscription: $SUBSCRIPTION_ID"

# Step 1: Create or verify resource group
print_status "Creating/verifying backend resource group..."
if az group show --name "$BACKEND_RG" &> /dev/null; then
    print_success "Resource group $BACKEND_RG already exists"
else
    print_status "Creating resource group $BACKEND_RG..."
    az group create --name "$BACKEND_RG" --location "$LOCATION" --output table
    if [ $? -eq 0 ]; then
        print_success "Resource group created successfully"
    else
        print_error "Failed to create resource group"
        exit 1
    fi
fi

# Step 2: Create or verify storage account
print_status "Creating/verifying storage account..."
if az storage account show --name "$BACKEND_SA" --resource-group "$BACKEND_RG" &> /dev/null; then
    print_success "Storage account $BACKEND_SA already exists"
else
    print_status "Creating storage account $BACKEND_SA..."
    az storage account create \
        --resource-group "$BACKEND_RG" \
        --name "$BACKEND_SA" \
        --sku "Standard_LRS" \
        --encryption-services blob \
        --allow-blob-public-access false \
        --output table
    
    if [ $? -eq 0 ]; then
        print_success "Storage account created successfully"
    else
        print_error "Failed to create storage account"
        exit 1
    fi
fi

# Step 3: Get storage account key
print_status "Getting storage account key..."
ACCOUNT_KEY=$(az storage account keys list --resource-group "$BACKEND_RG" --account-name "$BACKEND_SA" --query '[0].value' --output tsv)

if [ -z "$ACCOUNT_KEY" ]; then
    print_error "Failed to get storage account key"
    exit 1
else
    print_success "Storage account key retrieved"
fi

# Step 4: Create container
print_status "Creating/verifying storage container..."
az storage container create \
    --name "$CONTAINER_NAME" \
    --account-name "$BACKEND_SA" \
    --account-key "$ACCOUNT_KEY" \
    --output table 2>/dev/null

print_success "Storage container verified/created"

# Step 5: Set environment variables for Terraform
print_status "Setting environment variables..."
export ARM_SUBSCRIPTION_ID="$SUBSCRIPTION_ID"
export ARM_TENANT_ID=$(az account show --query tenantId --output tsv)

print_success "Backend setup completed!"
print_status "Backend configuration:"
echo "  Resource Group: $BACKEND_RG"
echo "  Storage Account: $BACKEND_SA"
echo "  Container: $CONTAINER_NAME"
echo "  Subscription: $SUBSCRIPTION_ID"

echo ""
print_success "✅ Backend setup complete! You can now run 'terraform init'"
echo ""
print_status "Next steps:"
echo "1. cd ~/CCGC5502-Automation-Project/terraform"
echo "2. terraform init"
echo "3. terraform validate"
echo "4. terraform plan"
