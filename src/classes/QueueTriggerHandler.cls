public with sharing class QueueTriggerHandler {
    public static void onBeforeInsert(List<To_Do__c> todos) {
        QueueTriggerHandlerHelper.assignmentQueue(todos);
    }
}