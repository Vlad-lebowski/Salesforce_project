@isTest
global class ToDoHttpMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody('{"Id" : "a035j000005ksEmAAI", "Name" : "White test", "Status__c" : "Ready to take", "External_Id__c" : "a005j00000BalZdAAJ", "RecordTypeId" : "0125j000000MvjyAAC", "Is_Done__c" : "true"}');
        response.setStatusCode(200);
        return response;
    }
}