@isTest
global class SubHttpCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody('{"Id" : "a045j000009VMAMAA4", "Name" : "html", "To_Do__c" : "a005j00000BalZdAAJ", "Is_Done__c" : "true", "External_Id__c" : "a015j00000HOo8uAAD"}');
        response.setStatusCode(200);
        return response;
    }
}