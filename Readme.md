
### APEX Usage Sample:


`AzureService.azureWrapper uow = AzureService.storageDetails();`

`system.debug(uow);`

`Datetime dt = Datetime.now();`

`Attachment att = [select name, contentType, bodylength, body from attachment where id ='some id here'];`

`uow = AzureService.signedSignature(uow, dt, att.name, att.contentType, att.bodyLength);`

`system.debug(uow);`

`Boolean result = AzureService.uploadToAzure(uow,att.body);`

`system.debug(result);`

### VF uses the Azure js library generated as per instructions [here](https://github.com/Azure/azure-storage-node/blob/master/browser/README.md)

Check out the the script tag in the VF page to check out.
