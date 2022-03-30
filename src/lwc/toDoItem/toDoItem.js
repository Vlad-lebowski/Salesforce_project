import { LightningElement, api, wire, track } from 'lwc';
import getRecordTypeName from '@salesforce/apex/ToDoController.getRecordTypeName';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import RECORD_TYPE_ID_FIELD from '@salesforce/schema/To_Do__c.RecordTypeId';
import getSubToDos from '@salesforce/apex/ToDoController.getSubToDos';

export default class ToDoItem extends LightningElement {
    @api toDoItem;
    @api recordId;
    @api typeName = '0125j000000MvjyAAC';
    giveMeTypeName;
    subToDos;
    retrievedSubToDos;
    showSubToDos = false;
    value = '';

    @wire(getSubToDos, {toDo: '$toDoItem'})
    retrieveSubToDosFromToDo(retrievedSubToDos) {
        if(retrievedSubToDos.data) {
            this.retrievedSubToDos = retrievedSubToDos;
            let options = [];
            for (var key in retrievedSubToDos.data) {
                  options.push({ label: retrievedSubToDos.data[key].Name, value: retrievedSubToDos.data[key].Id });
            }
            this.subToDos = options;
            if(this.subToDos.length > 0) {
                this.showSubToDos = true;
            }
        } else if (retrievedSubToDos.error) {
            this.error = retrievedSubToDos.error;
            //this.toDoItems = undefined;
        }
    }

    @wire(getRecordTypeName, {toDo: '$toDoItem'})
    retrieveTypeNameFromTypeId(typeName) {
            if(typeName.data) {
                this.giveMeTypeName = typeName.data;
            }
        };
}