@isTest
private class ToDoManagerTest {
static To_Do__c createRecord() {
        To_Do__c testTodo = new To_Do__c(Name = 'Write test',
                                         Status__c = 'Ready to Take',
                                         Is_Done__c = false,
                                         External_Id__c = 'a005j00000B2D06AAF');
        Test.setMock(HttpCalloutMock.class, new TodoHttpMock());
        insert testTodo;
        return testTodo;
    }
    
    static To_Do__c createRecord2() {
        To_Do__c testTodo = new To_Do__c(Name = 'Running test',
                                       Status__c = 'Ready to Take',
                                       Is_Done__c = false,
                                       External_Id__c = null);
        Test.setMock(HttpCalloutMock.class, new TodoHttpMock());
        insert testTodo;
        return testTodo;
    }
    
    @IsTest
    static void testGetTodo() {
        To_Do__c todo = createRecord();
        String jsonString = todo.Id;
        System.assert(todo != null);
        System.assertEquals(todo.Name, 'Write test');
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/To_Do__c/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        To_Do__c td = ToDoManager.getToDo();
        Test.stopTest();
    }


    @IsTest
    static void testCreateTodo() {
         String jsonString = '[{\n' +
                '  "Name" : "White test",\n' +
                '  "Status__c" : "Ready to Take",\n' +
                '  "Is_Done__c" : "false",\n' +
                '  "RecordType" : "Today"\n' +
                '}]';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/To_Do__c/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        ToDoManager.createToDo('White test','Ready to Take', false, 'Today');
        Test.stopTest();
        List<To_Do__c> toDos = [SELECT Id, Name FROM To_Do__c];
        System.assertEquals(1, toDos.size());
        System.assertEquals('White test', toDos.get(0).Name);
    }

   @IsTest
    static void testUpdateTodo() {
        String jsonString = '[{\n' +
                '  "Name" : "White test",\n' +
                '  "Status__c" : "Ready to Take",\n' +
                '  "Is_Done__c" : "false",\n' +
                '  "RecordType" : "Today"\n' +
                '}]';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/To_Do__c/';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        Id id = ToDoManager.updateToDoFields('Running test', 'Ready to take', false);
        Test.stopTest();
        List<To_Do__c> updatedTodo = [SELECT Id, Name FROM To_Do__c WHERE Id = :id];
    }

    @IsTest
    static void testDeleteTodo() {
        String jsonString = 'a035j000005ksEmAAI';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/To_Do__c/';
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        ToDoManager.deleteToDo();
        Test.stopTest();
    }
    
    @IsTest
    static void testUpsertTodo() {
        String jsonString = '[{\n' +
                '  "Name" : "White test",\n' +
                '  "Status__c" : "Ready to Take",\n' +
                '  "Is_Done__c" : "false",\n' +
                '  "RecordType" : "Today"\n' +
                '}]';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/To_Do__c/';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        Id id = ToDoManager.upsertToDo('Running test', 'Ready to take', false);
        Test.stopTest();
        List<To_Do__c> updatedTodo = [SELECT Id, Name FROM To_Do__c WHERE Id = :id];
        System.assertEquals(1, updatedTodo.size());
        System.assertEquals('Running test', updatedTodo.get(0).Name);
    }
}