public with sharing class ToDoHelper {
    public static void initializePostCallout(List<To_Do__c> newList) {
        List<To_Do__c> toDos = newList;
        for (To_Do__c toDo : toDos) {
            String recordTypeName = Schema.SObjectType.To_Do__c.getRecordTypeInfosById().get(toDo.RecordTypeId).getName();
            CalloutClassForToDo.makePostCallout(toDo.Id, toDo.Name, toDo.Status__c, toDo.Is_Done__c, recordTypeName);
        }
    }

    public static void initializeDeleteCallout(List<To_Do__c> oldList) {
        List<To_Do__c> toDos = oldList;
        for (To_Do__c toDo : toDos) {
            CalloutClassForToDo.makeDeleteCallout(toDo.Id);
        }
    }

    public static void initializePutCallout(List<To_Do__c> newList) {
        List<To_Do__c> toDos = newList;
        for (To_Do__c toDo : toDos) {
            CalloutClassForToDo.makePutCallout(toDo.Id, toDo.Name, toDo.Status__c, toDo.Is_Done__c);
        }
    }

    public static void assignToQueue(List<To_Do__c> todos) {
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