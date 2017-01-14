public class InTheArea {
    @AuraEnabled
        public static String getLocal (String searchTerm, Decimal lat, Decimal lon) {
        String url = 'https://th-yelp-locator.herokuapp.com/search?address=' + lat +','+ lon + '&term=' + EncodingUtil.urlEncode(searchTerm, 'UTF-8');
       /* HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET');    
        req.setEndpoint(url);
        HTTPResponse res = http.send(req);
        return res.getBody();    */
        String resultList = getHttp(url);
            return resultList;
    }
    
    private static String getHttp(String url) {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET');
        req.setEndpoint(url);
        HTTPResponse res = http.send(req);
        return res.getBody();
    }
    
    @AuraEnabled
    public static string getListByAddress(Id recordId, String objectType, String searchQuery) {
        try {
            String location;
            if(objectType == 'Account')
            {
                location = accountSelect(recordId);
            }
            else if (objectType == 'Contact')
            {
                location = contactSelect(recordId);
            }
            else {
                return '{"error": "This component cannot be used on this page type."}';
            }
            String url = 'https://th-yelp-locator.herokuapp.com/search?address=' + 
                EncodingUtil.urlEncode(location, 'UTF-8') + '&term=' + EncodingUtil.urlEncode(searchQuery, 'UTF-8');
            String resultList = getHttp(url);
            return resultList;
        } catch(exception ex) {
            return '{"error": "' + ex.getMessage() + '"}';
        }

    }
    
    private static String contactSelect(Id recordId) { 
    	Contact contact = [select MailingStreet, MailingCity, MailingState from Contact where Id = :recordId];
        String location = contact.MailingStreet + ',' + contact.MailingCity + ',' + contact.MailingState;
        return location;
        
        
    }
    
    private static String accountSelect (Id recordId) {
        Account account = [select BillingStreet, BillingCity, BillingState from Account where Id =:recordId];
        String location = account.BillingStreet + ',' + account.BillingCity + ',' + account.BillingState;
        return location;
    }
    
    
    
}