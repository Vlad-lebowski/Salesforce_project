public with sharing class AstapenkoToDoHelper {
    public static void initializePostCallout(List<To_Do__c> newList) {
        List<To_Do__c> toDos = newList;
        for (To_Do__c toDo : toDos) {
            AstapenkoCalloutClassForToDo.makePostCallout(toDo.Id, toDo.Name, toDo.Status__c, toDo.Is_Done__c);
        }
    }

    public static void initializeDeleteCallout(List<To_Do__c> oldList) {
        List<To_Do__c> toDos = oldList;
        for (To_Do__c toDo : toDos) {
            AstapenkoCalloutClassForToDo.makeDeleteCallout(toDo.Id);
        }
    }

    public static void initializePutCallout(List<To_Do__c> newList) {
        List<To_Do__c> toDos = newList;
        for (To_Do__c toDo : toDos) {
            AstapenkoCalloutClassForToDo.makePutCallout(toDo.Id, toDo.Name, toDo.Status__c, toDo.Is_Done__c);
        }
    }
}