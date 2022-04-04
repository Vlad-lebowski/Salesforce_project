public with sharing class EMail2CaseTriggerHandler {
    public static void onBeforeInsert(List<Case> cases) {
        EMail2CaseTriggerHandlerHelper.createCaseTodo(cases);
    }
}