
# gpu-benchmarking
Benchmarking GPUs on Azure


### Work in progress - this will eventually contain deployment and setup scripts to enable VMs to be deployed on the cloud and various deep learning benchmarks to be run on them.

### How to deploy a new Deep Learning VM

The deployment configuration uses two json files:
azure_parameters.json
azure_template.json

In this github repo, there is a template for the former called
azure_parameters.template.json - you should cp this file
to azure_parameters.json, and replace the text INSERT_SECURE_PASSWORD with a
secure admin password.

Then, run the following command:

./deploy.sh -i <subscription> -g <resource_group> -n <vm_name> -l <location> -s <vm_size>

Some possible values for some of these might be e.g. "westeurope" for location,
and "Standard_NC6" for vm_size (there is info about the different sizes at
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes-gpu
If the deployment fails with an error code "MarketplacePurchaseEligibilityFailed", go to the section below.

Once the VM is built, you can navigate to it through the azure portal:
login to
https://portal.azure.com
then click on "Virtual Machines" on the left.  You can filter by subscription
at the top of the page.
Once you have found and clicked on your new VM, you will go to its dashboard
page, and here you can edit its "DNS name" to make it something more memorable.

You can also start the VM running from here, or you can do this from the command line with
az vm start --resource-group <resource_group> --name <vm_name>


You can then login to it:
ssh -l vm-admin <DNS name>
using the admin password from azure_parameters.json





### Common problem for a new subscription:

The following error
```json
Deployment failed. Correlation ID: 9a8d161f-8e86-4dab-965e-787266341aec. {
  "error": {
    "code": "MarketplacePurchaseEligibilityFailed",
    "message": "Marketplace purchase eligibilty check returned errors. See inner errors for details. ",
    "details": [
      {
        "code": "BadRequest",
        "message": "Offer with PublisherId: microsoft-ads, OfferId: linux-data-science-vm-ubuntu cannot be purchased due to validation errors. See details for more information.[{\"Legal terms have not been accepted for this item on this subscription. To accept legal terms using PowerShell, please use Get-AzureRmMarketplaceTerms and Set-AzureRmMarketplaceTerms API(https://go.microsoft.com/fwlink/?linkid=862451) or deploy via the Azure portal to accept the terms\":\"StoreApi\"}]"
      }
    ]
  }
}
```
can be resolved by:
* Going to https://portal.azure.com
* Click "+ New"
* Search for "Data Science Virtual Machine for Linux (Ubuntu)" 
* At the bottom of the page, there should be a link with the text "Want to deploy programmatically? Get started ->" - click on this.
* You will get a list of subscriptions.  For the subscription you want to use, set the "Status" to "Enable".





