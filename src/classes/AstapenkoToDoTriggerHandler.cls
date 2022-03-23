public with sharing class AstapenkoToDoTriggerHandler {
    public static void handleBeforeInsert(List<To_Do__c> newList) {

    }

    public static void handleBeforeUpdate(List<To_Do__c> newList, Map<Id, To_Do__c> newMap, List<To_Do__c> oldList, Map<Id, To_Do__c> oldMap) {

    }

    public static void handleBeforeDelete(List<To_Do__c> oldList, Map<Id, To_Do__c> oldMap) {

    }

    public static void handleAfterInsert(List<To_Do__c> newList, Map<Id, To_Do__c> newMap) {
        AstapenkoToDoHelper.initializePostCallout(newList);
    }

    public static void handleAfterUpdate(List<To_Do__c> newList, Map<Id, To_Do__c> newMap, List<To_Do__c> oldList, Map<Id, To_Do__c> oldMap) {
        AstapenkoToDoHelper.initializePutCallout(newList);
    }

    public static void handleAfterDelete(List<To_Do__c> oldList, Map<Id, To_Do__c> oldMap) {
        AstapenkoToDoHelper.initializeDeleteCallout(oldList);
    }

    public static void handleAfterUndelete(List<To_Do__c> newList, Map<Id, To_Do__c> newMap) {

    }
}