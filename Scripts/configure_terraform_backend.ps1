 param (
    # [Parameter(Mandatory=$true)]
    [string] $RESOURCE_GROUP_NAME = "terraform-backend-rg",
    [string] $LOCATION = "southeastasia",
    [string] $STORAGE_ACCOUNT_NAME = "terraformbackendsa59108",
    [string] $CONTAINER_NAME = "terraformstate"
 )

# Adding random suffix to strorageaccount name to make it globally unique.
# $random = -join ((0..9) | Get-Random -Count 5 | % {$_})
# $STORAGE_ACCOUNT_NAME = $STORAGE_ACCOUNT_NAME + $random

 # Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION
# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
# Get storage account key
$ACCOUNT_KEY=az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv
# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

# Assign storage account name to pipeline variable.
echo "##vso[task.setvariable variable=TF_Backend_RG]$RESOURCE_GROUP_NAME"
echo "##vso[task.setvariable variable=TF_Backend_StorageAcc_Name]$STORAGE_ACCOUNT_NAME"
echo "##vso[task.setvariable variable=TF_Backend_Container_Name]$CONTAINER_NAME"

echo "Storage_Account_Name: $STORAGE_ACCOUNT_NAME"
echo "Container_Name: $CONTAINER_NAME"
# echo "access_key: $ACCOUNT_KEY"