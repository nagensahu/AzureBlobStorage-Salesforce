Creating a Class to Auth and Upload to Azure Blob Storage

Sample usage:

AzureService.azureWrapper uow = AzureService.storageDetails();
system.debug(uow);
Datetime dt = Datetime.now();
Attachment att = [select name, contentType, bodylength, body from attachment where id ='00P90000015mNR3EAM'];
uow = AzureService.signedSignature(uow, dt, att.name, att.contentType, att.bodyLength);
system.debug(uow);
Boolean result = AzureService.uploadToAzure(uow,att.body);
system.debug(result);
