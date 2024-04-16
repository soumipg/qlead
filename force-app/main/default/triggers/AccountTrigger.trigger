trigger AccountTrigger on Account (before insert, before update, after insert) {
    if(trigger.isBefore) {
        for(Account acc: trigger.new) {
            try {
            	AccountTriggerHandler.validateAccount(acc);
            } catch (Exception e) {
                acc.addError(e.getMessage());
            }
		}
    } else {
    	AccountTriggerHandler.sendAccountCreationEmail(trigger.new);
    }
}