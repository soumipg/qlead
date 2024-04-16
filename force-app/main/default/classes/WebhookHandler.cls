public class WebhookHandler {
    public string email;
    public string tShirtSize;
    public string shoeSize;
    
    public static string callCommutatusWebhook(Account a) {        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://integrations.commutatus.com/webhook/719ce78d-c2c5-47a8-986a-39d7e7a5652d');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Map<String, Object> bodyMap = new Map<String, Object>();
        bodyMap.put('email', a.PersonEmail);
        bodyMap.put('tshirtSize', String.valueof(a.T_Shirt_Size__c));
        bodyMap.put('shoeSize', Decimal.valueOf(a.Shoe_Size__c));
        
        System.debug(JSON.serialize(bodyMap));
        req.setBody(JSON.serialize(bodyMap));
        
        HTTPResponse res = http.send(req);
        
        if(res.getStatusCode() == 400) {
	        System.debug(res.getBody());
			throw new IllegalArgumentException((String)((Map<String,Object>)JSON.deserializeUntyped(res.getBody())).get('message'));            
        } else {
        	return String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(res.getBody())).get('customer_id'));            
        }

        
    }
}