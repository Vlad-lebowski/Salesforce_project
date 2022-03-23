public with sharing class AstapenkoCalloutClassForToDo {

    @Future(Callout=true)
    public static void makePostCallout(String toDoId, String toDoName, String status, Boolean isDone) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SF/services/apexrest/To_Do__c/' + toDoId);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"name":"' + toDoName + '", "status":"' + status + '", "isDone":"' + isDone + '"}');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
    }

    @Future(Callout=true)
    public static void makeDeleteCallout(String toDoId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SF/services/apexrest/To_Do__c/' + toDoId);
        request.setMethod('DELETE');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            System.debug('ToDo successfully deleted.');
            System.debug(response.getBody());
        } else {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
    }

    @Future(Callout=true)
    public static void makePutCallout(String toDotId, String toDoName, String status, Boolean isDone) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SF/services/apexrest/To_Do__c/' + toDotId);
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"name":"' + toDoName + '", "status":"' + status + '", "isDone":"' + isDone + '"}');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            System.debug('Upserted the following account:');
            System.debug(response.getBody());
        } else {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
    }
}