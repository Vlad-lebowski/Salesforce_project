trigger ToDoTrigger on To_Do__c (
        before insert,
        after insert,
        after update,
        after delete) {
    if (Trigger.isBefore && Trigger.isInsert) {
        ToDoTriggerHandler.handleBeforeInsert(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        ToDoTriggerHandler.handleAfterInsert(Trigger.new, Trigger.newMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        ToDoTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isDelete) {
        ToDoTriggerHandler.handleAfterDelete(Trigger.old, Trigger.oldMap);
    }
}