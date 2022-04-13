trigger Email2CaseTrigger on Case (before insert) {
    if (Trigger.isInsert && Trigger.isBefore) {
        EMail2CaseTriggerHandler.onBeforeInsert(Trigger.new);
    }
}