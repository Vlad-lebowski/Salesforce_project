@isTest
private class QueueTriggerHandlerHelperTest {
    static To_Do__c createRecord(String name, String recId) {
        return new To_Do__c(
        	Name = name,
            Status__c = 'Ready to Take',
            RecordTypeId = recId
        );
    }
    @isTest static void testAssignmentQueue() {
        Group queue = [SELECT id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Today ToDos'];
        To_Do__c todo = createRecord('Test1', '0125j000000MvjyAAC');
        System.debug('todo: ' + todo);
        System.debug('todo.RecID: ' + todo.RecordTypeId);
        List<To_Do__c> todos1 = new List<To_Do__c>();
        todos1.add(todo);
        System.debug('todos1: ' + todos1);
        QueueTriggerHandlerHelper.assignmentQueue(todos1);
        System.debug(todo.OwnerId);
        System.assertEquals(todo.OwnerId, queue.Id);
        
        queue = [SELECT id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Tomorrow ToDos'];
        todo = createRecord('Test2', '0125j000000Mvk3AAC');
        System.debug('todo: ' + todo);
        List<To_Do__c> todos2 = new List<To_Do__c>();
        todos2.add(todo);
        System.debug('todos2: ' + todos2);
        QueueTriggerHandlerHelper.assignmentQueue(todos2);
        System.debug(todo.OwnerId);
        System.assertEquals(todo.OwnerId, queue.Id);
        
        queue = [SELECT id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Later ToDos'];
        todo = createRecord('Test3', '0125j000000Mvk8AAC');
        System.debug('todo: ' + todo);
        List<To_Do__c> todos3 = new List<To_Do__c>();
        todos3.add(todo);
        System.debug('todos3: ' + todos3);
        QueueTriggerHandlerHelper.assignmentQueue(todos3);
        System.debug(todo.OwnerId);
        System.assertEquals(todo.OwnerId, queue.Id);
    }
}