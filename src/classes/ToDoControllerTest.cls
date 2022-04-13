@isTest
private class ToDoControllerTest {
    @TestSetup
    static void setup() {
        To_Do__c todo = new To_Do__c(
                Name = 'White',
                Is_Done__c = false,
                RecordTypeId = '0125j000000MvjyAAC'
        );

        Test.setMock(HttpCalloutMock.class, new TodoHttpMock());

        insert todo;
    }

    @IsTest
    static void testfindToDos() {
        To_Do__c todo = [SELECT Id FROM To_Do__c WHERE Name = 'White'];

        Test.startTest();
        List<To_Do__c> todos = ToDoController.findToDoItems('White', true, true, true, true, true);
        Test.stopTest();

        System.assert(todos != null);
        for (To_Do__c result: todos){
            System.assertEquals(toDo.Id, result.Id);
        }
    }
    
    @IsTest
    static void testfindAllToDos() {
        To_Do__c todo = [SELECT Id FROM To_Do__c LIMIT 1];

        Test.startTest();
        List<To_Do__c> todos = ToDoController.findToDoItems('', true, true, true, true, true);
        Test.stopTest();

        System.assert(todos != null);
        for (To_Do__c result: todos){
            System.assertEquals(toDo.Id, result.Id);
        }
    }
    
    @IsTest
    static void testgetSubToDos() {
        To_Do__c todo = [SELECT Id FROM To_Do__c WHERE Name = 'White'];

        Test.startTest();
        List<Sub_To_Do__c> subTodos = ToDoController.getSubToDos(todo);
        Test.stopTest();

        System.assert(subTodos != null);
        for (Sub_To_Do__c result: subTodos){
            System.assertEquals(toDo.Id, result.To_Do__c);
        }
    }
    
    @IsTest
    static void testgetRecordTypeNames() {
        List<String> recordTypesNames = new List<String>();
        Test.startTest();
        recordTypesNames = ToDoController.getRecordTypeNames();
        Test.stopTest();
        for (String name: recordTypesNames) {
            System.assertNotEquals(name, 'Master');
        }
    }
    @IsTest
    static void testgetRecordTypeName() {
        To_Do__c todo = [SELECT Id FROM To_Do__c WHERE Name = 'White'];
        todo.RecordTypeId = '0125j000000MvjyAAC';
        Test.startTest();
        String name = ToDoController.getRecordTypeName(todo);
        Test.stopTest();
        System.assertEquals(name, 'Today');
    }
    @IsTest
    static void testgetRecordTypeId() {
        Test.startTest();
        String id = ToDoController.getRecordTypeId('Today');
        Test.stopTest();
        System.assertEquals(id, '0125j000000MvjyAAC');
    }
    @IsTest
    static void testgetIsDone() {
        To_Do__c todo = [SELECT Id FROM To_Do__c WHERE Name = 'White' LIMIT 1];
        todo.Is_Done__c = true;
        Test.startTest();
        Boolean isDone = ToDoController.getIsDone(todo);
        Test.stopTest();
        System.assertEquals(isDone, true);
    }
}