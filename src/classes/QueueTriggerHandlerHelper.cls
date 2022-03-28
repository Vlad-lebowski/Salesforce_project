public class QueueTriggerHandlerHelper {
    public static void assignmentQueue(List<To_Do__c> todos) {
        Group adminQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Admin ToDos' LIMIT 1];
        Group securityQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Security ToDos' LIMIT 1];
        Group randomQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Random ToDos' LIMIT 1];
        Map<Id, User> adminUsers = new Map<Id, User>([SELECT Id FROM User WHERE Id IN (SELECT UserorGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Admin ToDos') AND isActive = true]);
        Map<Id, User> securityUsers = new Map<Id, User>([SELECT Id FROM User WHERE Id IN (SELECT UserorGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Security ToDos') AND isActive = true]);
        Map<Id, User> randomUsers = new Map<Id, User>([SELECT Id FROM User WHERE Id IN (SELECT UserorGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Random ToDos') AND isActive = true]);
        
        for(To_Do__c todo : todos) {
            if(todo.IsPersonal__c == false) {
                if(adminUsers.keyset().contains(todo.OwnerId)) {
                    todo.OwnerId = adminQueue.Id;
                } else if(securityUsers.keyset().contains(todo.OwnerId)) {
                    todo.OwnerId = securityQueue.Id;
                } else if(randomUsers.keyset().contains(todo.OwnerId)) {
                    todo.OwnerId = randomQueue.Id;
                }
            }
        }
    }
}