global class SchedualerForOldRecordsBatch implements Schedulable {
	 global void execute(SchedulableContext sc) {
         BatchJobToDeleteOldRecords batch = new BatchJobToDeleteOldRecords(); 
         Database.executeBatch(batch);
     }
}