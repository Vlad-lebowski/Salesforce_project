@RestResource(UrlMapping='/Sub_To_Do__c/*')
global with sharing class SubToDoManager {
    @HttpGet
    global static Sub_To_Do__c getSubToDo() {
        RestRequest request = RestContext.request;
        String externalId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Sub_To_Do__c result = [SELECT Id, Name, Is_Done__c, External_Id__c FROM Sub_To_Do__c WHERE External_Id__c=:externalId LIMIT 1];
        return result;
    }

    @HttpPost
    global static Sub_To_Do__c createSubToDo(String name, Boolean isDone, String parentToDoId) {
        SubToDoTriggerHandler.recordBeingProcessed = true;
        RestRequest request = RestContext.request;
        String externalId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        To_Do__c localParent = [SELECT Id FROM To_Do__c WHERE External_Id__c =:parentToDoId LIMIT 1];
        Sub_To_Do__c subToDo = new Sub_To_Do__c(Name = name, Is_Done__c = isDone, External_Id__c = externalId, To_Do__c = localParent.Id);
        insert subToDo;
        SubToDoTriggerHandler.recordBeingProcessed = false;
        return subToDo;
    }

    @HttpDelete
    global static void deleteSubToDo() {
        SubToDoTriggerHandler.recordBeingProcessed = true;
        RestRequest request = RestContext.request;
        String externalId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Sub_To_Do__c subToDo = [SELECT Id FROM Sub_To_Do__c WHERE External_Id__c = :externalId LIMIT 1];
        delete subToDo;
        SubToDoTriggerHandler.recordBeingProcessed = false;
    }

    @HttpPut
    global static Id upsertSubToDo(String name, Boolean isDone) {
        SubToDoTriggerHandler.recordBeingProcessed = true;
        RestRequest request = RestContext.request;
        String externalId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        List<Sub_To_Do__c> subToDos = [SELECT Id FROM Sub_To_Do__c WHERE External_Id__c = :externalId LIMIT 1];
        Sub_To_Do__c subToDo;
        if (subToDos.size() == 0) {
            subToDo = new Sub_To_Do__c(Name = name, Is_Done__c = isDone, External_Id__c = externalId);
        } else {
            subToDo = subToDos.get(0);
            subToDo.Name = name;
            subToDo.Is_Done__c = isDone;
        }
        upsert subToDo;
        SubToDoTriggerHandler.recordBeingProcessed = false;
        // Return the to_do ID.
        return subToDo.Id;
    }

    @HttpPatch
    global static Id updateSubToDo(String name, Boolean isDone) {
        SubToDoTriggerHandler.recordBeingProcessed = true;
        RestRequest request = RestContext.request;
        String externalId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        List<Sub_To_Do__c> subToDos = [SELECT Id FROM Sub_To_Do__c WHERE External_Id__c = :externalId LIMIT 1];
        Sub_To_Do__c subToDo;
        if (subToDos.size() == 0) {
            return null;
        } else {
            subToDo = subToDos.get(0);
            subToDo.Name = name;
            subToDo.Is_Done__c = isDone;
        }
        update subToDo;
        SubToDoTriggerHandler.recordBeingProcessed = false;
        return subToDo.Id;
    }
}