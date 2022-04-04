import { LightningElement, api, wire, track } from 'lwc';
import getRecordTypeName from '@salesforce/apex/ToDoController.getRecordTypeName';
import getIsDone from '@salesforce/apex/ToDoController.getIsDone';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import RECORD_TYPE_ID_FIELD from '@salesforce/schema/To_Do__c.RecordTypeId';
import ID_FIELD from '@salesforce/schema/To_Do__c.Id';
import IS_DONE_FIELD from '@salesforce/schema/To_Do__c.Is_Done__c';
import STATUS_FIELD from '@salesforce/schema/To_Do__c.Status__c';
import getSubToDos from '@salesforce/apex/ToDoController.getSubToDos';
import { NavigationMixin } from 'lightning/navigation';
import { updateRecord, deleteRecord } from "lightning/uiRecordApi";
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import IS_DONE_SUB_FIELD from '@salesforce/schema/Sub_To_Do__c.Is_Done__c'
import ID_SUB_FIELD from '@salesforce/schema/Sub_To_Do__c.Id'
import TO_DO from '@salesforce/schema/Sub_To_Do__c.To_Do__c';

export default class ToDoItem extends NavigationMixin(LightningElement) {
    @api toDoItem;
    @api toDoExpired;
    @api expiredByDate;
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
    createdDate;
    showCreatedDate;
    showStatus;

    @wire(getIsDone, {toDo: '$toDoItem'})
    retrievedIsDoneField(retrievedIsDone) {
        if(retrievedIsDone.data) {
            this.retrievedIsDone = retrievedIsDone;
            this.doneIsSelected = retrievedIsDone.data;

        } else if (retrievedIsDone.error) {
            this.errorIsDone = retrievedSubToDos.error;
        }
    }

    handleDoneClick(event) {
        this.doneIsSelected = !this.doneIsSelected;

        const fields = {};

        fields[ID_FIELD.fieldApiName] = this.toDoItem.Id;
        fields[IS_DONE_FIELD.fieldApiName] = this.doneIsSelected;

        const recordInput = {
           fields: fields
        };
        updateRecord(recordInput).then((record) => {
              console.log(record);
              if (this.showStatus != 'Done' && this.doneIsSelected == true) {
                  this.showStatus = 'Done';
              } else if (this.showStatus == 'Done' && this.doneIsSelected == false) {
                  this.showStatus = 'In progress';
              }
        });

        if(this.doneIsSelected == true) {
           this.toDoExpired = false;
        } else if (this.doneIsSelected == false && this.expiredByDate == true) {
          this.toDoExpired = true;
        } else if (this.doneIsSelected == false && this.expiredByDate == false) {
            this.toDoExpired = false;
        }

        event.preventDefault();

        const selectEvent = new CustomEvent('doneischanged', {
            detail: this.toDoItem.Id
        });

        his.dispatchEvent(selectEvent);
    }

    handleClick(event) {
       refreshApex(this.retrievedSubToDos);
    }

    @wire(getSubToDos, {toDo: '$toDoItem'})
    retrieveSubToDosFromToDo(retrievedSubToDos) {
        if(retrievedSubToDos.data) {
            this.retrievedSubToDos = retrievedSubToDos;
            this.subToDos = retrievedSubToDos.data;
            this.createdDate = new Date(this.toDoItem.CreatedDate);
            this.showCreatedDate = this.createdDate.toDateString();
            this.showStatus = this.toDoItem.Status__c;
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
           }
       };
       this[NavigationMixin.Navigate](temp);
    }

    handleNewSubToDo() {
        const defaultValues = encodeDefaultFieldValues({
             To_Do__c: this.toDoItem.Id
         });

        let temp = {
            type: 'standard__objectPage',
            attributes: {
               recordId: this.toDoItem.Id,
               objectApiName: 'Sub_To_Do__c',
               actionName: 'new'
            },
            state : {
                defaultFieldValues: defaultValues
            }
        };
        this[NavigationMixin.Navigate](temp)
    }

    handleDeleteSubToDo(event) {
        const subToDoId = event.target.dataset.subtodoid;
        deleteRecord(subToDoId)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'SubToDo deleted',
                    variant: 'success'
                })
            );
            return refreshApex(this.retrievedSubToDos);
        })
        .catch((error) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error deleting record',
                    message: reduceErrors(error).join(', '),
                    variant: 'error'
                })
            );
        });
    }

    handleSubDoneClick(event) {
        const fields = {};
        console.log('checked: ' + event.target.checked);
        fields[ID_SUB_FIELD.fieldApiName] = event.target.dataset.subtodoid;
        fields[IS_DONE_SUB_FIELD.fieldApiName] = event.target.checked;

        const recordInput = {
             fields: fields
        };
        updateRecord(recordInput).then((record) => {
             console.log(record);
        });
    }

    handleReadyToTake(event) {
        const fields = {};

        fields[ID_FIELD.fieldApiName] = this.toDoItem.Id;
        fields[STATUS_FIELD.fieldApiName] = 'Ready to Take';

        const recordInput = {
            fields: fields
        };
        updateRecord(recordInput).then((record) => {
           console.log(record);
           this.showStatus = 'Ready to Take';
           this.doneIsSelected = false;
           if (this.expiredByDate == true) {
                this.toDoExpired = true;
           } else if (this.expiredByDate == false) {
                this.toDoExpired = false;
           }
        });
    }

    handleInProgress(event) {
        const fields = {};

        fields[ID_FIELD.fieldApiName] = this.toDoItem.Id;
        fields[STATUS_FIELD.fieldApiName] = 'In progress';

        const recordInput = {
                fields: fields
        };
        updateRecord(recordInput).then((record) => {
            console.log(record);
            this.showStatus = 'In progress';
            this.doneIsSelected = false;
            if (this.expiredByDate == true) {
                 this.toDoExpired = true;
            } else if (this.expiredByDate == false) {
                 this.toDoExpired = false;
            }
        });
    }
}