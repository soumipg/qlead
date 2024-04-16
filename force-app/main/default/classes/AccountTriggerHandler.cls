public class AccountTriggerHandler {
    
    static String sKey = '00DGA000008Z5gG2AS20240416160715';
    
    public static void sendAccountCreationEmail(List<Account> newAccounts) {
        
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        for(Account acc: newAccounts) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            System.debug(acc.PersonEmail);
            System.debug(acc.id);
            List<String> recipientEmailAddresses = new List<String>{String.valueOf(acc.PersonEmail)};
                mail.setToAddresses(recipientEmailAddresses);
            mail.setSubject('Welcome to ABC Fashion Co.');
            
			String profileLink = 'https://abc-fashion-co-dev-ed--c.develop.vf.force.com/apex/CustomerProfilePage?key='+ encryptId(acc.id);
            String body = 'Hi ' + acc.FirstName +',' + '<br/>' + 'Please visit the following link to setup your profile' + '<br/>' + profileLink ;
            mail.setHTMLBody(body);
            messages.add(mail);
        }
        
        Messaging.sendEmail(messages);
    }
    
    public static String encryptId(Id accountId) {
        Blob sKeyBLob = blob.valueOf(sKey);
        Blob cipherText = Crypto.encryptWithManagedIV('AES256', sKeyBLob, Blob.valueOf(accountId.toString()));
        String encodedCipherText = EncodingUtil.convertToHex(cipherText); 
        String encodedId = EncodingUtil.urlEncode(encodedCipherText,'UTF-8') ;
        system.debug('encoded version' + encodedId);
        return encodedId;
    }
    
    public static String decryptId(String encryptedId) {
        Blob sKeyBLob = blob.valueOf(sKey);
        String sCleanLink = EncodingUtil.urlDecode(encryptedId,'UTF-8');
        Blob encodedEncryptedBlob = EncodingUtil.convertFromHex(sCleanLink);
        Blob decryptedBlob = Crypto.decryptWithManagedIV('AES256', sKeyBLob, encodedEncryptedBlob);
        String decryptedId = decryptedBlob.toString();
        system.debug('decryptedId' + decryptedId);
        return decryptedId;
    }
    
    public static void validateAccount(Account acc) {
        Boolean isPhoneValid = Pattern.matches('^(\\+?1 ?)?\\(?([0-9]{3})\\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$', acc.Phone);
        if(!isPhoneValid) {
            throw new IllegalArgumentException('Only US/Canada Numbers allowed. E.g. formats - (123)-456-7890, 123 456 7890, +1 123-456-7890');
        }
        
        
    }
}