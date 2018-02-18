/*This upload mechanism uses the Storage Key directly for the upload, Signature version- 2015-12-11*/
public with sharing class AzureService {
    
    public static AzureService.azureWrapper signedsignature(AzureService.azureWrapper wrapRec, Datetime timestamp, String fileName, String fileType, Integer fileLength){
    	wrapRec.timestamp = timestamp.formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
    	wrapRec.fileName = EncodingUtil.urlEncode(fileName, 'UTF-8');
    	wrapRec.fileLength = String.valueof(fileLength);
    	wrapRec.fileType = fileType;
    	string canonHeaders = 'x-ms-blob-type:BlockBlob\nx-ms-date:'+wrapRec.timestamp+'\nx-ms-version:2015-12-11\n';
    	string canonRes = '/'+wrapRec.storageName+'/'+wrapRec.container+'/'+wrapRec.fileName;
    	string stringToSign = 'PUT\n\n\n'+wrapRec.fileLength+'\n\n'+wrapRec.fileType+'\n\n\n\n\n\n\n'+canonHeaders+canonRes;
    	
    	// Sign the request
        Blob temp = EncodingUtil.base64Decode(wrapRec.storageKey);
        Blob hmac = Crypto.generateMac('hmacSHA256', Blob.valueOf(stringToSign), temp);
        wrapRec.signature = EncodingUtil.base64Encode(hmac);
        
        return wrapRec;
    }
    
    public static boolean uploadToAzure(AzureService.azureWrapper wrapRec, Blob fileBody){
    	boolean response = false;
    	HttpRequest req = new HttpRequest();
        	req.setTimeout(120000);
            req.setMethod('PUT');
        	req.setHeader('x-ms-blob-type', 'BlockBlob');
            req.setHeader('x-ms-date', wrapRec.timestamp);
            string authHeader = 'SharedKey '+wrapRec.storageName+':' + wrapRec.signature;
            req.setHeader('Authorization', authHeader);
            req.setHeader('x-ms-version', '2015-12-11');
        	req.setHeader('Content-Length', wrapRec.fileLength);
        	req.setHeader('Content-Type', wrapRec.fileType);
       
            req.setEndpoint('https://'+wrapRec.storageName+'.blob.core.windows.net/'+wrapRec.container+'/'+wrapRec.fileName);
			req.setBodyAsBlob(fileBody);
        	
        
            Http http = new Http();
        
            try
            {
                HTTPResponse res = http.send(req);
        
                system.debug(res.toString());
                system.debug(res.getStatus());
                system.debug(res.getStatusCode());
                system.debug(res.getBody());
                
                if(res.getStatusCode() == 201){
                	response = true;
                }
        		
            }
            catch (system.CalloutException ce)
            {
                system.debug(ce);
            }
            
            return response;
    	
    }
    //returns storage key, storage name and container
    @RemoteAction
    public static AzureService.azureWrapper storageDetails(){
    	Azure_Details__c detail = Azure_Details__c.getInstance();
    	return new AzureService.azureWrapper(detail.StorageKey__c, detail.StorageName__c, detail.Container__c);
    }
    
    public class azureWrapper{
    
    	String storageKey;
    	String storageName;
    	String container;
    	String timestamp;
    	String fileName;
    	String fileType;
    	String fileLength;
    	String signature;
    	
    	public azureWrapper(String sk, String sn, String cn){
    		this.storageKey = sk;
    		this.storageName = sn;
    		this.container = cn;
    	}
    }
    
}