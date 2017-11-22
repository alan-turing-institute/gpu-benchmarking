
# gpu-benchmarking
Benchmarking GPUs on Azure


### Work in progress - this will eventually contain deployment and setup scripts to enable VMs to be deployed on the cloud and various deep learning benchmarks to be run on them.





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





