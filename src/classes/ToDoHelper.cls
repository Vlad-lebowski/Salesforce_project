public with sharing class ToDoHelper {
    public static void initializePostCallout(List<To_Do__c> newList) {
        List<To_Do__c> toDos = newList;
        for (To_Do__c toDo : toDos) {
            String recordTypeName = Schema.SObjectType.To_Do__c.getRecordTypeInfosById().get(toDo.RecordTypeId).getName();
            CalloutClassForToDo.makePostCallout(toDo.Id, toDo.Name, toDo.Status__c, toDo.Is_Done__c, recordTypeName);
        }
    }

    public static void initializeDeleteCallout(List<To_Do__c> oldList) {
        List<To_Do__c> toDos = oldList;
        for (To_Do__c toDo : toDos) {
            CalloutClassForToDo.makeDeleteCallout(toDo.Id);
        }
    }

    public static void initializePutCallout(List<To_Do__c> newList) {
        List<To_Do__c> toDos = newList;
        for (To_Do__c toDo : toDos) {
            CalloutClassForToDo.makePutCallout(toDo.Id, toDo.Name, toDo.Status__c, toDo.Is_Done__c);
        }
    }
}