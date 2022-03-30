public with sharing class ToDoController {
    @AuraEnabled(Cacheable=true)
    public static List<To_Do__c> findToDoItems(String searchKey, Boolean isTodaySelected, Boolean isTomorrowSelected, Boolean isLaterSelected) {
        String key = '%' + searchKey + '%';
        List<Id> recordTypeIds = new List<Id>();
        if (isTodaySelected) {
            String recordTypeId = Schema.SObjectType.To_Do__c.getRecordTypeInfosByName().get('Today').getRecordTypeId();
            recordTypeIds.add(recordTypeId);
        }
        if (isTomorrowSelected) {
            String recordTypeId = Schema.SObjectType.To_Do__c.getRecordTypeInfosByName().get('Tomorrow').getRecordTypeId();
            recordTypeIds.add(recordTypeId);
        }
        if (isLaterSelected) {
            String recordTypeId = Schema.SObjectType.To_Do__c.getRecordTypeInfosByName().get('Later').getRecordTypeId();
            recordTypeIds.add(recordTypeId);
        }
        if (key == '') {
            return [
                    SELECT
                            Id,
                            Name,
                            Status__c,
                            Is_Done__c,
                            External_Id__c,
                            RecordTypeId,
                            CreatedDate
                    FROM To_Do__c
                    WHERE RecordTypeId IN :recordTypeIds
                    WITH SECURITY_ENFORCED
                    LIMIT 100
            ];
        } else {
            return [
                    SELECT
                            Id,
                            Name,
                            Status__c,
                            Is_Done__c,
                            External_Id__c,
                            RecordTypeId,
                            CreatedDate
                    FROM To_Do__c
                    WHERE Name LIKE :key AND RecordTypeId IN :recordTypeIds
                    WITH SECURITY_ENFORCED
                    LIMIT 100
            ];
        }
    }

    @AuraEnabled(Cacheable=true)
    public static List<Sub_To_Do__c> getSubToDos(To_Do__c toDo) {
        List<Sub_To_Do__c> subToDos = [SELECT Id, Name, To_Do__c FROM Sub_To_Do__c WHERE To_Do__c=:toDo.Id LIMIT 20];
        return subToDos;
    }

    @AuraEnabled(Cacheable=true)
    public static List<String> getRecordTypeNames() {
        Schema.DescribeSObjectResult R = To_Do__c.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        List<String> recordTypesNames = new List<String>();
        for (Schema.RecordTypeInfo info : RT) {
            String name = info.name;
            if (name == 'Master') {
                continue;
            }
            recordTypesNames.add(name);
        }
        return recordTypesNames;
    }

    @AuraEnabled(Cacheable=true)
    public static String getRecordTypeName(To_Do__c toDo) {
        String recordTypeName = Schema.SObjectType.To_Do__c.getRecordTypeInfosById().get(toDo.RecordTypeId).getName();
        return recordTypeName;
    }

    @AuraEnabled(Cacheable=true)
    public static String getRecordTypeId(String recordTypeName) {
        String recordTypeId = Schema.SObjectType.To_Do__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return recordTypeId;
    }
}