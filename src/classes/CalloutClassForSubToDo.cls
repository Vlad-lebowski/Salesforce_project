public with sharing class CalloutClassForSubToDo {

    @Future(Callout=true)
    public static void makePostCallout(String subToDoId, String subToDoName, Boolean isDone, String parentToDoId) {
        SubToDoTriggerHandler.recordBeingProcessed = true;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SF/services/apexrest/Sub_To_Do__c/' + subToDoId);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"name":"' + subToDoName + '", "isDone":"' + isDone + '", "parentToDoId":"' + parentToDoId + '"}');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            System.debug(params);
            Sub_To_Do__c subToDo = [SELECT Id, External_Id__c FROM Sub_To_Do__c WHERE Id =:subToDoId LIMIT 1];
            subToDo.put('External_Id__c', params.get('Id'));
            update subToDo;
        }
        SubToDoTriggerHandler.recordBeingProcessed = false;
    }

    @Future(Callout=true)
    public static void makeDeleteCallout(String subToDoId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SF/services/apexrest/Sub_To_Do__c/' + subToDoId);
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
    public static void makePutCallout(String subToDoId, String subToDoName, Boolean isDone) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SF/services/apexrest/Sub_To_Do__c/' + subToDoId);
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"name":"' + subToDoName + '", "isDone":"' + isDone + '"}');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            System.debug('Upserted the following To Do:');
            System.debug(response.getBody());
        } else {
            System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
        }
    }
}