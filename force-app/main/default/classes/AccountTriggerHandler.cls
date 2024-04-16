public class AccountTriggerHandler {
    public static void sendAccountCreationEmail(List<Account> newAccounts) {
        
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        for(Account acc: newAccounts) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            System.debug(acc.PersonEmail);
            System.debug(acc.id);
            List<String> recipientEmailAddresses = new List<String>{String.valueOf(acc.PersonEmail)};
                mail.setToAddresses(recipientEmailAddresses);
            mail.setSubject('Welcome to ABC Fashion Co.');
            String body = 'Hi ' + acc.Name +',' + '<br/>' + 'Please visit the following link to setup your profile' + '<br/>' + 'https://abc-fashion-co-dev-ed--c.develop.vf.force.com/apex/CustomerProfilePage?id='+acc.id;
            mail.setHTMLBody(body);
            messages.add(mail);
        }
        
        Messaging.sendEmail(messages);
    }
    
    public static void validateAccount(Account acc) {
        Boolean isPhoneValid = Pattern.matches('^(\\+?1 ?)?\\(?([0-9]{3})\\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$', acc.Phone);
        if(!isPhoneValid) {
            throw new IllegalArgumentException('Only US/Canada Numbers allowed. E.g. formats - (123)-456-7890, 123 456 7890, +1 123-456-7890');
        }
        
        
    }
}