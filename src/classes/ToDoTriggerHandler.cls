public with sharing class ToDoTriggerHandler {
    public static Boolean recordBeingProcessed = false;

    public static void handleBeforeInsert(List<To_Do__c> newList) {

    }

    public static void handleBeforeUpdate(List<To_Do__c> newList, Map<Id, To_Do__c> newMap, List<To_Do__c> oldList, Map<Id, To_Do__c> oldMap) {

    }

    public static void handleBeforeDelete(List<To_Do__c> oldList, Map<Id, To_Do__c> oldMap) {

    }

    public static void handleAfterInsert(List<To_Do__c> newList, Map<Id, To_Do__c> newMap) {
        if (ToDoTriggerHandler.recordBeingProcessed == true) {
            return;
        }
        ToDoTriggerHandler.recordBeingProcessed = true;
        ToDoHelper.initializePostCallout(newList);
        ToDoTriggerHandler.recordBeingProcessed = false;
    }

    public static void handleAfterUpdate(List<To_Do__c> newList, Map<Id, To_Do__c> newMap, List<To_Do__c> oldList, Map<Id, To_Do__c> oldMap) {
        if (ToDoTriggerHandler.recordBeingProcessed == true) {
            return;
        }
        ToDoTriggerHandler.recordBeingProcessed = true;
        ToDoHelper.initializePutCallout(newList);
        ToDoTriggerHandler.recordBeingProcessed = false;
    }

    public static void handleAfterDelete(List<To_Do__c> oldList, Map<Id, To_Do__c> oldMap) {
        if (ToDoTriggerHandler.recordBeingProcessed == true) {
            return;
        }
        ToDoTriggerHandler.recordBeingProcessed = true;
        ToDoHelper.initializeDeleteCallout(oldList);
        ToDoTriggerHandler.recordBeingProcessed = false;
    }

    public static void handleAfterUndelete(List<To_Do__c> newList, Map<Id, To_Do__c> newMap) {

    }
}