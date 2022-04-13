@isTest
public with sharing class CalloutClassForToDoTest {
    @isTest
    public static void testToDoInsert() {
       Test.setMock(HttpCalloutMock.class, new TodoHttpMock());
       Test.startTest();
           CalloutClassForToDo.makePostCallout('a035j000005ksEmAAI', 'White test', 'Ready to Take', false, 'Tomorrow');
       Test.stopTest();
    }
    
    @isTest
    public static void testToDoInsertReturn() {
       Test.setMock(HttpCalloutMock.class, new TodoHttpMock());
       Test.startTest();
           ToDoTriggerHandler.recordBeingProcessed = true;
           CalloutClassForToDo.makePostCallout('a035j000005ksEmAAI', 'White test', 'Ready to Take', false, 'Tomorrow');
       Test.stopTest();
    }
    
    @isTest
    public static void testToDoDelete() {
        Test.setMock(HttpCalloutMock.class, new TodoHttpMock());
        Test.startTest();
            CalloutClassForToDo.makeDeleteCallout('a035j000005ksEmAAI');
        Test.stopTest();
        To_Do__c[] todos = [SELECT Id FROM To_Do__c WHERE Id = 'a035j000005ksEmAAI' LIMIT 1];
        System.assert(todos.isEmpty());
    }
    
    @isTest
    public static void testToDoPut() {
        Test.setMock(HttpCalloutMock.class, new TodoHttpMock());
        Test.startTest();
           CalloutClassForToDo.makePutCallout('a035j000005ksEmAAI', 'White test', 'Ready to Take', false);
        Test.stopTest();
    }
}