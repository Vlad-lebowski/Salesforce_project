public with sharing class AntanovichEMail2CaseTriggerHandler {
    public static void onBeforeInsert(List<Case> cases) {
        AntanovichEMail2CaseTriggerHandlerHelper.createCaseTodo(cases);
    }
}