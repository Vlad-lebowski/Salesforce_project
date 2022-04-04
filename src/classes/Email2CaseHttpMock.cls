@isTest
global class Email2CaseHttpMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody('{"Id" : "a035j000005ktSkAAI", "Name" : "EmailSubject", "Status__c" : "Ready to take", "isDone" : "false", "recordType" : "Today"}');
        response.setStatusCode(200);
        return response;
    }
}