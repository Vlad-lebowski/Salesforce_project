public with sharing class SubToDoHelper {
    public static void initializePostCallout(List<Sub_To_Do__c> newList) {
        List<Sub_To_Do__c> subToDos = newList;
        for (Sub_To_Do__c subToDo : subToDos) {
            CalloutClassForSubToDo.makePostCallout(subToDo.Id, subToDo.Name, subToDo.Is_Done__c, subToDo.To_Do__c);
        }
    }

    public static void initializeDeleteCallout(List<Sub_To_Do__c> oldList) {
        List<Sub_To_Do__c> subToDos = oldList;
        for (Sub_To_Do__c subToDo : subToDos) {
            CalloutClassForSubToDo.makeDeleteCallout(subToDo.Id);
        }
    }

    public static void initializePutCallout(List<Sub_To_Do__c> newList) {
        List<Sub_To_Do__c> subToDos = newList;
        for (Sub_To_Do__c subToDo : subToDos) {
            CalloutClassForSubToDo.makePutCallout(subToDo.Id, subToDo.Name, subToDo.Is_Done__c);
        }
    }
}