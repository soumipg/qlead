trigger AccountTrigger on Account (after insert) {
    AccountTriggerHandler.sendAccountCreationEmail(trigger.new);
}