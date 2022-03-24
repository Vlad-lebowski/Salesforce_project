public with sharing class AstapenkoToDoTriggerHandler {

    public static Boolean recordBeingProcessed = false;

    public static void handleBeforeInsert(List<To_Do__c> newList) {

    }

    public static void handleBeforeUpdate(List<To_Do__c> newList, Map<Id, To_Do__c> newMap, List<To_Do__c> oldList, Map<Id, To_Do__c> oldMap) {

    }

    public static void handleBeforeDelete(List<To_Do__c> oldList, Map<Id, To_Do__c> oldMap) {

    }

    public static void handleAfterInsert(List<To_Do__c> newList, Map<Id, To_Do__c> newMap) {
        if (AstapenkoToDoTriggerHandler.recordBeingProcessed == true) {
            return;
        }
        AstapenkoToDoTriggerHandler.recordBeingProcessed = true;
        AstapenkoToDoHelper.initializePostCallout(newList);
        AstapenkoToDoTriggerHandler.recordBeingProcessed = false;
    }

    public static void handleAfterUpdate(List<To_Do__c> newList, Map<Id, To_Do__c> newMap, List<To_Do__c> oldList, Map<Id, To_Do__c> oldMap) {
        if (AstapenkoToDoTriggerHandler.recordBeingProcessed == true) {
            return;
        }
        AstapenkoToDoTriggerHandler.recordBeingProcessed = true;
        AstapenkoToDoHelper.initializePutCallout(newList);
        AstapenkoToDoTriggerHandler.recordBeingProcessed = false;
    }

    public static void handleAfterDelete(List<To_Do__c> oldList, Map<Id, To_Do__c> oldMap) {
        if (AstapenkoToDoTriggerHandler.recordBeingProcessed == true) {
            return;
        }
        AstapenkoToDoTriggerHandler.recordBeingProcessed = true;
        AstapenkoToDoHelper.initializeDeleteCallout(oldList);
        AstapenkoToDoTriggerHandler.recordBeingProcessed = false;
    }

    public static void handleAfterUndelete(List<To_Do__c> newList, Map<Id, To_Do__c> newMap) {

    }
}