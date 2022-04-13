public with sharing class EMail2CaseTriggerHandlerHelper {
    public static void createCaseTodo(List<Case> cases) {
        List<To_Do__c> todos = new List<To_Do__c>();

        for (Case cs : cases) {
            if (cs.Origin == 'Email') {
                To_Do__c todo = new To_Do__c(
                    Name = cs.Subject,
                    Status__c = 'Ready to Take'
                );
                todos.add(todo);
            }
        }
        if(!todos.isEmpty()) {
            insert todos;
        }
    }
}