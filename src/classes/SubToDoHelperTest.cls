@IsTest
private class SubToDoHelperTest {
@IsTest
    static void testInitializePostCallout() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SubResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new SubHttpCalloutMock());
        To_Do__c todo = new To_Do__c(Id = 'a035j000005ktEoAAI', Name = 'Todo', RecordTypeId = '0125j000000MvjyAAC');
        System.debug(todo);
        List<Sub_To_Do__c> subs = new List<Sub_To_Do__c>();
        for(Integer i = 0; i < 5; i++) {
            subs.add(
                new Sub_To_Do__c(Name = 'Sub' + i, To_Do__c = todo.Id)
            );
        }
        System.debug(subs);
        insert subs;
        Test.startTest();
        SubToDoHelper.initializePostCallout(subs);
        Integer futureCalls = Limits.getFutureCalls();
        Test.stopTest();
        System.assertEquals(5, futureCalls);
    }

    @IsTest
    static void testInitializePutCallout() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SubResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new SubHttpCalloutMock());
        List<Sub_To_Do__c> subs = new List<Sub_To_Do__c>();
        Test.startTest();
        SubToDoHelper.initializePutCallout(subs);
        Integer futureCalls = Limits.getFutureCalls();
        Test.stopTest();
        System.assertEquals(0, futureCalls);
    }

    @IsTest
    static void testInitializeDeleteCallout() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SubResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new SubHttpCalloutMock());
        List<Sub_To_Do__c> subs = new List<Sub_To_Do__c>();
        Test.startTest();
        SubToDoHelper.initializeDeleteCallout(subs);
        Integer futureCalls = Limits.getFutureCalls();
        Test.stopTest();
        System.assertEquals(0, futureCalls);
    }
}