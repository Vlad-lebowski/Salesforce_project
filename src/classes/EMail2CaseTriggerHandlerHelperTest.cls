@isTest
private class EMail2CaseTriggerHandlerHelperTest {
@IsTest
    static void testcreateCaseTodo() {
        List<Case> cases = new List<Case>();
        Case cs = new Case();
        cs.Origin = 'Email';
        cs.Subject = 'EmailSubject';
        cases.add(cs);
        List<To_Do__c> todos = new List<To_Do__c>();

        Test.startTest();
        AntanovichEMail2CaseTriggerHandler.onBeforeInsert(cases);
        todos = [SELECT Id, Name, Status__c FROM To_Do__c];
        Test.stopTest();

        System.assertEquals(todos.size(), 1);
        for (To_Do__c todo : todos) {
            System.assertEquals(todo.Name, 'EmailSubject');
            System.assertEquals(todo.Status__c, 'Ready to Take');
        }
    }
}