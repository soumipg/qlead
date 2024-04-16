public without sharing class CustomerProfilePageController {
    public string accountId {get;set;}
    public Account acc{get;set;}
    
    public CustomerProfilePageController() {
        this.accountID = AccountTriggerHandler.decryptId(ApexPages.currentPage().getParameters().get('key'));
		acc = [Select Id, Name, PersonEmail, T_Shirt_Size__c, Shoe_Size__c,Profile_Completed__c,Loyalty_Customer_ID__c, Phone, Date_of_Birth__c , iSPersonaccount
                       from Account where id =: accountId];  
    }
    
    public Pagereference save() {
        if(acc.T_Shirt_Size__c == null || acc.T_Shirt_Size__c == ''
           || acc.Shoe_Size__c == null || acc.Shoe_Size__c == ''
           || acc.Date_of_Birth__c == null) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please input T-Shirt Size, Shoe Size and Date of Birth');
            ApexPages.addMessage(message);
            return null;
        }
        
        try {
            AccountTriggerHandler.validateAccount(acc);
            acc.Profile_Completed__c = true;
            acc.Loyalty_Customer_ID__c = WebhookHandler.callCommutatusWebhook(acc);
			update acc;
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.confirm, 'Your details are saved.');
            ApexPages.addMessage(message);
        	return null;
        } catch (Exception e) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(message);
            return null;
        }
    }
}