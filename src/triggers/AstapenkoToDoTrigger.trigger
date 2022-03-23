trigger AstapenkoToDoTrigger on To_Do__c (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete) {
    if (Trigger.isAfter && Trigger.isInsert) {
        List<To_Do__c> toDos = Trigger.new;
        for (To_Do__c toDo : toDos) {
            AstapenkoCalloutClassForToDo.makePostCallout(toDo.Name, toDo.Status__c, toDo.Is_Done__c, toDo.Id);
        }
    }
}