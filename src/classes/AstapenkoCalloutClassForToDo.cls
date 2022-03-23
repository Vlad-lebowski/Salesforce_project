public with sharing class AstapenkoCalloutClassForToDo {

    @Future(Callout=true)
    public static void makePostCallout(String toDoName, String status, Boolean isDone, String externalId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SF/services/apexrest/To_Do__c/');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"name":"' + toDoName + '", "status":"' + status + '", "isDone":"' + isDone + '", "externalId":"' + externalId + '"}');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
    }
}