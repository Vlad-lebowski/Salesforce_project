trigger ToDoTrigger on To_Do__c (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete) {
    if (Trigger.isBefore && Trigger.isInsert) {

    }

    if (Trigger.isBefore && Trigger.isUpdate) {

    }

    if (Trigger.isBefore && Trigger.isDelete) {

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

    if (Trigger.isAfter && Trigger.isUndelete) {

    }
}