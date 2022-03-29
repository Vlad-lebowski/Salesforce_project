import { LightningElement, wire, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import { reduceErrors } from 'c/ldsUtils';
import { getPicklistValues, getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import TO_DO_OBJECT from '@salesforce/schema/To_Do__c';
import NAME_FIELD from '@salesforce/schema/To_Do__c.Name';
import STATUS_FIELD from '@salesforce/schema/To_Do__c.Status__c';
import RECORD_TYPE_ID_FIELD from '@salesforce/schema/To_Do__c.RecordTypeId';
import getRecordTypeNames from '@salesforce/apex/ToDoController.getRecordTypeNames';
import getRecordTypeId from '@salesforce/apex/ToDoController.getRecordTypeId';

import { publish, MessageContext } from 'lightning/messageService';
import TO_DO_CREATE_CHANNEL from '@salesforce/messageChannel/ToDoCreate__c';

export default class ToDoItemCreateRecord extends LightningElement {
    name = '';
    statusValue = '';
    recordType = '';
    recordTypeId = '';


    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: STATUS_FIELD })
            picklistValues;

    @track recordTypes = [];
    @track retrievedRecordTypeNames;
    error;



    @wire(getRecordTypeNames)
    wiredToDoItems(recordTypeNames) {
        console.log('Kek:' + recordTypeNames);
            console.log('Hello there:' + recordTypeNames.data);
              if (recordTypeNames.data) {
                      this.retrievedRecordTypeNames = recordTypeNames.data;
                      let options = [];
                      for (var key in recordTypeNames.data) {
                          options.push({ label: recordTypeNames.data[key], value: recordTypeNames.data[key] });
                          console.log(recordTypeNames.data[key]);
                      }
                      console.log('options' + options);
                      this.recordTypes = options;
                   //this.error = undefined;
              } else if (recordTypeNames.error) {
                   this.error = recordTypeNames.error;
                   //this.toDoItems = undefined;
              }
    }

    @wire(getRecordTypeId, {recordTypeName: '$recordType'})
    wiredRecordTypeId(retrievedRecordTypeId) {
        console.log('id:' + retrievedRecordTypeId.data);
        if(retrievedRecordTypeId.data) {
            this.recordTypeId = retrievedRecordTypeId.data;
        }
    }

    @wire(MessageContext)
        messageContext;

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
        fields[RECORD_TYPE_ID_FIELD.fieldApiName] = this.recordTypeId;
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