import { LightningElement, api, wire, track } from 'lwc';
import getRecordTypeName from '@salesforce/apex/ToDoController.getRecordTypeName';
import getIsDone from '@salesforce/apex/ToDoController.getIsDone';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import RECORD_TYPE_ID_FIELD from '@salesforce/schema/To_Do__c.RecordTypeId';
import ID_FIELD from '@salesforce/schema/To_Do__c.Id';
import IS_DONE_FIELD from '@salesforce/schema/To_Do__c.Is_Done__c'
import getSubToDos from '@salesforce/apex/ToDoController.getSubToDos';
import { NavigationMixin } from 'lightning/navigation';
import { updateRecord } from "lightning/uiRecordApi";

export default class ToDoItem extends NavigationMixin(LightningElement) {
    @api toDoItem;
    giveMeTypeName;
    subToDos;
    retrievedSubToDos;
    retrievedIsDone;
    doneIsSelected;
    showSubToDos = false;
    value = '';
    errorSubTodo;
    errorIsDone;
    errorChangeDone;

    @wire(getIsDone, {toDo: '$toDoItem'})
    retrievedIsDoneField(retrievedIsDone) {
        if(retrievedIsDone.data) {
            this.retrievedIsDone = retrievedIsDone;
            this.doneIsSelected = retrievedIsDone.data;
        } else if (retrievedIsDone.error) {
            this.errorIsDone = retrievedSubToDos.error;
        }
    }

    handleDoneClick() {
        this.doneIsSelected = !this.doneIsSelected;
        const fields = {};

        fields[ID_FIELD.fieldApiName] = this.toDoItem.Id;
        fields[IS_DONE_FIELD.fieldApiName] = this.doneIsSelected;

        const recordInput = {
           fields: fields
        };
        updateRecord(recordInput).then((record) => {
              console.log(record);
        });
    }

    @wire(getSubToDos, {toDo: '$toDoItem'})
    retrieveSubToDosFromToDo(retrievedSubToDos) {
        if(retrievedSubToDos.data) {
            this.retrievedSubToDos = retrievedSubToDos;
//            let options = [];
//            for (var key in retrievedSubToDos.data) {
//                  options.push({ label: retrievedSubToDos.data[key].Name, value: retrievedSubToDos.data[key].Id });
//            }
            this.subToDos = retrievedSubToDos.data;
            if(this.subToDos.length > 0) {
                this.showSubToDos = true;
            }
        } else if (retrievedSubToDos.error) {
            this.errorSubTodo = retrievedSubToDos.error;
            //this.toDoItems = undefined;
        }
    }

    handleDelete(event) {
       // 1. Prevent default behavior of anchor tag click which is to navigate to the href url
       event.preventDefault();
       // 2. Read about event best practices at http://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.events_best_practices
       const deleteEvent = new CustomEvent('deletetodo', {
            detail: this.toDoItem.Id
       });
       // 3. Fire the custom event
       this.dispatchEvent(deleteEvent);
    }

    @wire(getRecordTypeName, {toDo: '$toDoItem'})
    retrieveTypeNameFromTypeId(typeName) {
            if(typeName.data) {
                this.giveMeTypeName = typeName.data;
            }
    }

    handleEdit(){
       let temp = {
           type: 'standard__recordPage',
           attributes: {
               recordId: this.toDoItem.Id,
               objectApiName: 'To_Do__c',
               actionName: 'edit'
           },
           state : {
              nooverride: '1'
           }
       };
       this[NavigationMixin.Navigate](temp);
    }
}