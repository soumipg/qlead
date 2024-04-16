public without sharing class CustomerProfilePageController {
    public string accountId {get;set;}
    public Account acc{get;set;}
    
    public CustomerProfilePageController() {
        this.accountID = ApexPages.currentPage().getParameters().get('id');
		acc = [Select Id, Name, PersonEmail, T_Shirt_Size__c, Shoe_Size__c,Profile_Completed__c,Loyalty_Customer_ID__c, Phone, Date_of_Birth__c , iSPersonaccount
                       from Account where id =: accountId];  
    }
    
    public Pagereference save() {
        if(acc.T_Shirt_Size__c == null || acc.Shoe_Size__c == null || acc.Date_of_Birth__c == null) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please input T-Shirt Size, Shoe Size and Date of Birth');
            ApexPages.addMessage(message);
            return null;
        }
        
        acc.Profile_Completed__c = true;
        update acc; 
        ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.confirm, 'Your details are saved.');
        ApexPages.addMessage(message);
        return null;
    }
}