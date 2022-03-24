@RestResource(UrlMapping='/To_Do__c/*')
global with sharing class AstapenkoToDoManager {
    @HttpGet
    global static To_Do__c getToDo() {
        RestRequest request = RestContext.request;
        String toDoId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        To_Do__c result = [SELECT Id, Name, Status__c, Is_Done__c, External_Id__c FROM To_Do__c WHERE External_Id__c=:toDoId LIMIT 1];
        return result;
    }

    @HttpPost
    global static To_Do__c createToDo(String name, String status, Boolean isDone, String recordType) {
        AstapenkoToDoTriggerHandler.recordBeingProcessed = true;
        RestRequest request = RestContext.request;
        String externalId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        String recordTypeId = Schema.SObjectType.To_Do__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        To_Do__c thisToDo = new To_Do__c(RecordTypeId = recordTypeId, Name = name, Status__c = status, Is_Done__c = isDone, External_Id__c = externalId);
        insert thisToDo;
        AstapenkoToDoTriggerHandler.recordBeingProcessed = false;
        return thisToDo;
    }

    @HttpDelete
    global static void deleteToDo() {
        AstapenkoToDoTriggerHandler.recordBeingProcessed = true;
        RestRequest request = RestContext.request;
        String toDoId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        To_Do__c thisToDo = [SELECT Id FROM To_Do__c WHERE External_Id__c = :toDoId LIMIT 1];
        delete thisToDo;
        AstapenkoToDoTriggerHandler.recordBeingProcessed = false;
    }

    @HttpPut
    global static Id upsertToDo(String name, String status, Boolean isDone) {
        AstapenkoToDoTriggerHandler.recordBeingProcessed = true;
        RestRequest request = RestContext.request;
        String externalId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        List<To_Do__c> toDos = [SELECT Id FROM To_Do__c WHERE External_Id__c = :externalId LIMIT 1];
        To_Do__c thisToDo;
        if (toDos.size() == 0) {
            thisToDo = new To_Do__c(Name = name, Status__c = status, Is_Done__c = isDone, External_Id__c = externalId);
        } else {
            thisToDo = toDos.get(0);
            thisToDo.Name = name;
            thisToDo.Status__c = status;
            thisToDo.Is_Done__c = isDone;
        }
        upsert thisToDo;
        AstapenkoToDoTriggerHandler.recordBeingProcessed = false;
        // Return the to_do ID.
        return thisToDo.Id;
    }

    @HttpPatch
    global static Id updateAccountFields() {
        RestRequest request = RestContext.request;
        String toDoId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        List<To_Do__c> toDos = [SELECT Id FROM To_Do__c WHERE Id = :toDoId LIMIT 1];
        To_Do__c thisToDo;
        if (toDos.size() == 0) {
            return null;
        } else {
            thisToDo = toDos.get(0);
        }
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Account sObject
            thisToDo.put(fieldName, params.get(fieldName));
        }
        update thisToDo;
        return thisToDo.Id;
    }
}