@IsTest
private class CalloutClassForSubToDoTest {
    @IsTest
    static void testPushInserted() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SubResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        CalloutClassForSubToDo.makePostCallout('a045j000009VMAMAA4', 'html', true, 'a035j000005ktV1AAI');
        Integer futureCalls = Limits.getFutureCalls();
        Test.stopTest();
        System.assertEquals(1, futureCalls);
    }

    @IsTest
    static void testpushUpdated() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SubResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        CalloutClassForSubToDo.makePutCallout('a045j000009VMAMAA4', 'html', true);
        Integer futureCalls = Limits.getFutureCalls();
        Test.stopTest();
        System.assertEquals(1, futureCalls);
    }

    @IsTest
    static void testpushDeleted() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SubResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new SubHttpCalloutMock());
        List<Sub_To_Do__c> subs = new List<Sub_To_Do__c>();
        Test.startTest();
        CalloutClassForSubToDo.makeDeleteCallout('a045j000009VMAMAA4');
        Integer futureCalls = Limits.getFutureCalls();
        Test.stopTest();
        System.assertEquals(1, futureCalls);
    }
}