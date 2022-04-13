@IsTest
private class BatchJobToDeleteOldRecordsTest {
    @IsTest
        static void deleteOldRecordsTest() {
        Date dt = Date.today() - 100;
        To_Do__c todo = TestDataFactory.TODO.createDummyTodo('White', false);
        insert todo;
        Test.setCreatedDate(todo.Id, dt);
        update todo;
        List<To_Do__c> todos = TestDataFactory.TODO.createDummyTodoList('White', 3, true);
        List<To_Do__c> allTodo = [SELECT Id, CreatedDate FROM To_Do__c WHERE Name = 'White'];
        System.debug(allTodo);
            
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ToDosResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock); 
        
        Test.startTest();
        BatchJobToDeleteOldRecords batch = new BatchJobToDeleteOldRecords();
        Database.executeBatch(batch, 200);
        Test.stopTest();
        System.debug([SELECT Id, CreatedDate FROM To_Do__c WHERE Name = 'White']);
        List<To_Do__c> oldTodo = [SELECT Id, CreatedDate FROM To_Do__c WHERE CreatedDate < LAST_90_DAYS];
        List<To_Do__c> newTodo = [SELECT Id, CreatedDate FROM To_Do__c WHERE CreatedDate = LAST_90_DAYS];
        System.debug(newTodo);
        System.assertEquals(0, oldTodo.size());
    }
}