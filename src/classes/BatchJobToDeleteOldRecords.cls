public class BatchJobToDeleteOldRecords implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        ToDo_Setting__mdt term = new ToDo_Setting__mdt();
        Date s = term.Term_for_old_records__c;
        System.debug(s);
        return Database.getQueryLocator('SELECT id FROM To_Do__c WHERE createdDate <:s');
    }
    public void execute(Database.BatchableContext bc, List<To_Do__c> records){
        ToDoTriggerHandler.recordBeingProcessed = true;
        delete records;
        ToDoTriggerHandler.recordBeingProcessed = false;
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
}