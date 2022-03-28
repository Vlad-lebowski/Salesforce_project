@isTest
private class QueueTriggerHandlerHelperTest {
    static To_Do__c createRecord(String name, User user) {
        return new To_Do__c(
        	Name = name,
            Status__c = 'Ready to Take',
            IsPersonal__c = false,
            OwnerId = user.Id
        );
    }
    @isTest static void testAssignmentQueue() {
        User user = [SELECT Id FROM User WHERE Id IN (SELECT UserorGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Admin ToDos') AND isActive = true][0];
        To_Do__c todo = createRecord('Test1', user);
        System.debug('todo: ' + todo);
        System.debug('todo.OwnerId: ' + todo.OwnerId);
        List<To_Do__c> todos1 = new List<To_Do__c>();
        todos1.add(todo);
        System.debug('todos1: ' + todos1);
        QueueTriggerHandlerHelper.assignmentQueue(todos1);
        System.debug(todo.OwnerId);
        System.assertEquals(todo.OwnerId, '00G5j0000010tdHEAQ');
        
        user = [SELECT Id FROM User WHERE Id IN (SELECT UserorGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Security ToDos') AND isActive = true][0];
        todo = createRecord('Test2', user);
        System.debug('todo: ' + todo);
        System.debug('todo.OwnerId: ' + todo.OwnerId);
        List<To_Do__c> todos2 = new List<To_Do__c>();
        todos2.add(todo);
        System.debug('todos2: ' + todos2);
        QueueTriggerHandlerHelper.assignmentQueue(todos2);
        System.debug(todo.OwnerId);
        System.assertEquals(todo.OwnerId, '00G5j0000010tdMEAQ');

        user = [SELECT Id FROM User WHERE Id IN (SELECT UserorGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Random ToDos') AND isActive = true][0];
        todo = createRecord('Test3', user);
        System.debug('todo: ' + todo);
        System.debug('todo.OwnerId: ' + todo.OwnerId);
        List<To_Do__c> todos3 = new List<To_Do__c>();
        todos3.add(todo);
        System.debug('todos3: ' + todos3);
        QueueTriggerHandlerHelper.assignmentQueue(todos3);
        System.debug(todo.OwnerId);
        System.assertEquals(todo.OwnerId, '00G5j0000010tdREAQ');
    }
}