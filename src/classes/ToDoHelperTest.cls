@isTest
private class ToDoHelperTest {
    static To_Do__c createRecord(String name, User user) {
        return new To_Do__c(
        	Name = name,
            Status__c = 'Ready to Take',
            IsPersonal__c = false,
            OwnerId = user.Id
        );
    }
    static To_Do__c createPersonalRecord(String name, User user) {
        return new To_Do__c(
        	Name = name,
            Status__c = 'Ready to Take',
            IsPersonal__c = true,
            OwnerId = user.Id
        );
    }
    
    @isTest
    public static void testAfterInsertFuture(){
        To_Do__c[] todos = new List<To_Do__c>();
        for(Integer i = 0; i < 5; i++){
            todos.add(
                new To_Do__c(Name = 'Todo' + i, RecordTypeId = '0125j000000MvjyAAC')
            );
        }
        insert todos;
        Map<Id, To_Do__c> todoMap = new Map<Id, To_Do__c>([SELECT Id FROM To_Do__c]);
        Test.setMock(HttpCalloutMock.class, new TodoHttpMock());
        Test.startTest();
        ToDoHelper.initializePostCallout(new List<To_Do__c>());
        Test.stopTest();
        To_Do__c[] newTodos = [SELECT Id, RecordTypeId FROM To_Do__c WHERE Name LIKE 'Todo'];
        for(To_Do__c todo : newTodos){
            System.assertEquals(todo.RecordTypeId, '0125j000000MvjyAAC');
        }
    }
    
    @isTest
    public static void testAfterUpdateFuture(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ToDosResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        ToDoHelper.initializePutCallout(new List<To_Do__c>());
        Test.stopTest();
    }
    
    @isTest
    public static void testBeforeDeleteFuture(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ToDosResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        ToDoHelper.initializeDeleteCallout(new List<To_Do__c>());
        Test.stopTest();
    }
    
    @isTest static void testAssignmentQueue() {
        User user = [SELECT Id FROM User WHERE Id IN (SELECT UserorGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Admin ToDos') AND isActive = true][0];
        To_Do__c todo = createRecord('Test1', user);
        System.debug('todo: ' + todo);
        System.debug('todo.OwnerId: ' + todo.OwnerId);
        List<To_Do__c> todos1 = new List<To_Do__c>();
        todos1.add(todo);
        System.debug('todos1: ' + todos1);
        ToDoHelper.assignToQueue(todos1);
        System.debug(todo.OwnerId);
        System.assertEquals(todo.OwnerId, '00G5j0000010tdHEAQ');
        
        user = [SELECT Id FROM User WHERE Id IN (SELECT UserorGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Security ToDos') AND isActive = true][0];
        todo = createRecord('Test2', user);
        System.debug('todo: ' + todo);
        System.debug('todo.OwnerId: ' + todo.OwnerId);
        List<To_Do__c> todos2 = new List<To_Do__c>();
        todos2.add(todo);
        System.debug('todos2: ' + todos2);
        ToDoHelper.assignToQueue(todos2);
        System.debug(todo.OwnerId);
        System.assertEquals(todo.OwnerId, '00G5j0000010tdMEAQ');

        user = [SELECT Id FROM User WHERE Id IN (SELECT UserorGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Random ToDos') AND isActive = true][0];
        todo = createRecord('Test3', user);
        System.debug('todo: ' + todo);
        System.debug('todo.OwnerId: ' + todo.OwnerId);
        List<To_Do__c> todos3 = new List<To_Do__c>();
        todos3.add(todo);
        System.debug('todos3: ' + todos3);
        ToDoHelper.assignToQueue(todos3);
        System.debug(todo.OwnerId);
        System.assertEquals(todo.OwnerId, '00G5j0000010tdREAQ');
        
        user = [SELECT Id FROM User WHERE Id IN (SELECT UserorGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Random ToDos') AND isActive = true][0];
        todo = createPersonalRecord('Test4', user);
        System.debug('todo: ' + todo);
        System.debug('todo.OwnerId: ' + todo.OwnerId);
        List<To_Do__c> todos4 = new List<To_Do__c>();
        todos4.add(todo);
        System.debug('todos4: ' + todos4);
        ToDoHelper.assignToQueue(todos4);
        System.debug(todo.OwnerId);
        System.assertEquals(todo.OwnerId, user.Id);
    }
}