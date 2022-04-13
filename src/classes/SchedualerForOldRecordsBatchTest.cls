@isTest
private class SchedualerForOldRecordsBatchTest {
    @isTest static void testExecute() {        
        test.startTest();
        SchedualerForOldRecordsBatch cleanOld = new SchedualerForOldRecordsBatch();   
        String cron = '0 0 23 * * ?';        
        Id jobId = system.schedule('Test Scheduled', cron, cleanOld);
        test.stopTest();
        System.assertNotEquals(null, jobId);
    }
}