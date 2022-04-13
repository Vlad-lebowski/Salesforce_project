trigger AntanovichEmail2CaseTrigger on Case (before insert) {
    if (Trigger.isInsert && Trigger.isBefore) {
        AntanovichEMail2CaseTriggerHandler.onBeforeInsert(Trigger.new);
    }
}