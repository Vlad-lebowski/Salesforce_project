public with sharing class SubToDoTriggerHandler {
    public static Boolean recordBeingProcessed = false;

    public static void handleBeforeInsert(List<Sub_To_Do__c> newList) {

    }

    public static void handleBeforeUpdate(List<Sub_To_Do__c> newList, Map<Id, Sub_To_Do__c> newMap, List<Sub_To_Do__c> oldList, Map<Id, Sub_To_Do__c> oldMap) {

    }

    public static void handleBeforeDelete(List<Sub_To_Do__c> oldList, Map<Id, Sub_To_Do__c> oldMap) {

    }

    public static void handleAfterInsert(List<Sub_To_Do__c> newList, Map<Id, Sub_To_Do__c> newMap) {
        if (SubToDoTriggerHandler.recordBeingProcessed == true) {
            return;
        }
        SubToDoTriggerHandler.recordBeingProcessed = true;
        SubToDoHelper.initializePostCallout(newList);
        SubToDoTriggerHandler.recordBeingProcessed = false;
    }

    public static void handleAfterUpdate(List<Sub_To_Do__c> newList, Map<Id, Sub_To_Do__c> newMap, List<Sub_To_Do__c> oldList, Map<Id, Sub_To_Do__c> oldMap) {
        if (SubToDoTriggerHandler.recordBeingProcessed == true) {
            return;
        }
        SubToDoTriggerHandler.recordBeingProcessed = true;
        SubToDoHelper.initializePutCallout(newList);
        SubToDoTriggerHandler.recordBeingProcessed = false;
    }

    public static void handleAfterDelete(List<Sub_To_Do__c> oldList, Map<Id, Sub_To_Do__c> oldMap) {
        if (SubToDoTriggerHandler.recordBeingProcessed == true) {
            return;
        }
        SubToDoTriggerHandler.recordBeingProcessed = true;
        SubToDoHelper.initializeDeleteCallout(oldList);
        SubToDoTriggerHandler.recordBeingProcessed = false;
    }

    public static void handleAfterUndelete(List<Sub_To_Do__c> newList, Map<Id, Sub_To_Do__c> newMap) {

    }
}