import { LightningElement, wire, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import { reduceErrors } from 'c/ldsUtils';
import { getPicklistValues, getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import TO_DO_OBJECT from '@salesforce/schema/To_Do__c';
import NAME_FIELD from '@salesforce/schema/To_Do__c.Name';
import STATUS_FIELD from '@salesforce/schema/To_Do__c.Status__c';
import getRecordTypeNames from '@salesforce/apex/AstapenkoToDoItemController.getRecordTypeNames';

import { publish, MessageContext } from 'lightning/messageService';
import TO_DO_CREATE_CHANNEL from '@salesforce/messageChannel/ToDoCreate__c';

export default class ToDoItemCreateRecord extends LightningElement {
    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: STATUS_FIELD })
            picklistValues;

    recordTypes;
    retrievedRecordTypeNames;



//    @wire(getRecordTypeNames)
//    wiredToDoItems(retrievedRecordTypeNames) {
//            this.retrievedRecordTypeNames = retrievedRecordTypeNames;
//            console.log('Hello there:' + retrievedRecordTypeNames.data);
//              if (retrievedRecordTypeNames) {
//                   this.recordTypes = retrievedRecordTypeNames;
//                   //this.error = undefined;
//              } else if (retrievedRecordTypeNames.error) {
//                   this.error = retrievedRecordTypeNames.error;
//                   //this.toDoItems = undefined;
//              }
//    }

    @wire(MessageContext)
        messageContext;

    name = '';
    statusValue = '';
    recordType = '';

    handleNameChange(event) {
        this.name = event.target.value;
    }

    handleStatusChange(event) {
        this.statusValue = event.detail.value;
    }

    handleRecordTypeChange(event) {
        this.recordType = event.detail.value;
    }

    createToDo() {
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.name;
        fields[STATUS_FIELD.fieldApiName] = this.statusValue;
        const recordInput = { apiName: TO_DO_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'To Do created',
                        variant: 'success'
                    })
                );
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: reduceErrors(error).join(', '),
                        variant: 'error'
                    })
                );
            });
        this.name = '';
        this.statusValue = '';
        this.recordType = '';
        const searchKeyValue = '';
        const payload = { searchKey: searchKeyValue };
        publish(this.messageContext, TO_DO_CREATE_CHANNEL, payload);
    }
}