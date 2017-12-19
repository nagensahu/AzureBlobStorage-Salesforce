public class AzurePOC {

        public static void azurePOCMethod(){

            string storageKey = 'ShouldBeQueriedFromCustomSetting';


            Datetime dt = Datetime.now();

            string formattedDate = dt.formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
            string canonHeaders = 'x-ms-date:'+formattedDate+'\nx-ms-version:2015-12-11\n';
            string canonRes = '/sampleblobtrial/test1\ncomp:list\nrestype:container';
            string stringToSign = 'GET\n\n\n\n\n\n\n\n\n\n\n\n'+canonHeaders+canonRes;

        system.debug('stringToSign: '+stringtoSign);
            // Sign the request
            Blob temp = EncodingUtil.base64Decode(storageKey);
            Blob hmac = Crypto.generateMac('hmacSHA256', Blob.valueOf(stringToSign), temp);
            string signature = EncodingUtil.base64Encode(hmac);

            system.debug('SIGNATURE==>SharedKey :' + signature);
            system.debug('formattedDate:'+formattedDate);


            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setHeader('x-ms-date', formattedDate);
            string authHeader = 'SharedKey sampleblobtrial:' + signature;
            req.setHeader('Authorization', authHeader);
            req.setHeader('x-ms-version', '2015-12-11');

            req.setEndpoint('https://sampleblobtrial.blob.core.windows.net/test1?restype=container&comp=list');

            Http http = new Http();

            try
            {
                HTTPResponse res = http.send(req);

                system.debug(res.toString());
                system.debug(res.getStatus());
                system.debug(res.getStatusCode());
                system.debug(res.getBody());

            }
            catch (system.CalloutException ce)
            {
                system.debug(ce);
            }
    }
}
