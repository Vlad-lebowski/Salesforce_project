@isTest
private class SubToDoManagerTest {
    
    @IsTest
    static void testGetSubTodo() {
        To_Do__c todo = TestDataFactory.TODO.createDummyTodo('White test', true);
        Sub_To_Do__c sub = TestDataFactory.SUBTODO.createDummySubTodo('html', todo.Id, true);
        String jsonString = sub.Id;
        System.assert(sub != null);
        System.assertEquals(sub.Name, 'html');
        Test.setMock(HttpCalloutMock.class, new SubHttpCalloutMock());
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Sub_To_Do__c/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        Sub_To_Do__c td = SubToDoManager.getSubToDo();
        Test.stopTest();
    }

    @IsTest
    static void testCreateSub() {
        To_Do__c todo = TestDataFactory.TODO.createDummyTodo('White test', true);
        String jsonString = '[{\n' +
                '    "Name" : "html",\n' +
                '    "To_Do__c" :"'+ todo.Id + '"\n' +
                '    "Is_Done__c" : true,\n' +
                '}]';
        Test.setMock(HttpCalloutMock.class, new SubHttpCalloutMock());
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Sub_To_Do__c/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        Sub_To_Do__c sub = SubToDoManager.createSubToDo('html', true, 'a005j00000BalZdAAJ');
        System.debug(sub);
        Test.stopTest();
        List<Sub_To_Do__c> subToDos = [SELECT Id, Name FROM Sub_To_Do__c];
        System.debug(subToDos);
        System.assertEquals(0, subToDos.size());
    }

    @IsTest
    static void testUpdateSubTodo() {
        To_Do__c todo = TestDataFactory.TODO.createDummyTodo('White test', true);
        String jsonString = '[{\n' +
                '    "Name" : "html",\n' +
                '    "To_Do__c" :"'+ todo.Id + '"\n' +
                '    "Is_Done__c" : true,\n' +
                '}]';
        Test.setMock(HttpCalloutMock.class, new SubHttpCalloutMock());
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Sub_To_Do__c/';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        Id id = SubToDoManager.updateSubToDo('Running test', false);
        Test.stopTest();
        List<Sub_To_Do__c> updatedSub = [SELECT Id, Name FROM Sub_To_Do__c WHERE Id = :id];
    }
    
 /*   @IsTest
    static void testUpsertSubToDo() {
        To_Do__c todo = TestDataFactory.TODO.createDummyTodo('White test', true);
        String jsonString = '[{\n' +
                '    "Name" : "html",\n' +
                '    "To_Do__c" :"'+ todo.Id + '"\n' +
                '    "Is_Done__c" : true,\n' +
                '}]';
        Test.setMock(HttpCalloutMock.class, new SubHttpCalloutMock());
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Sub_To_Do__c/';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        Id id = SubToDoManager.upsertSubToDo('Running test', false);
        Test.stopTest();
    }*/

    @IsTest
    static void testDeleteSub() {
        To_Do__c todo = TestDataFactory.TODO.createDummyTodo('White test', true);
        Sub_To_Do__c sub = TestDataFactory.SUBTODO.createDummySubTodo('html', todo.Id, true);
        String jsonString = sub.Id;
        Test.setMock(HttpCalloutMock.class, new SubHttpCalloutMock());
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Sub_To_Do__c/';
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        SubToDoManager.deleteSubToDo();
        Test.stopTest();
    }
}