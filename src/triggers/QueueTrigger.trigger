trigger QueueTrigger on To_Do__c (before insert) {
    if (Trigger.isInsert && Trigger.isBefore) {
        QueueTriggerHandler.onBeforeInsert(Trigger.new);
    }
}