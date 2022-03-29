public with sharing class ToDoController {
    @AuraEnabled(Cacheable=true)
    public static List<To_Do__c> findToDoItems(String searchKey) {
        String key = '%' + searchKey + '%';
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
                    WHERE Name LIKE :key
                    WITH SECURITY_ENFORCED
                    LIMIT 100
            ];
        }
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