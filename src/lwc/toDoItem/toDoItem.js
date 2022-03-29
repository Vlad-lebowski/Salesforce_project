import { LightningElement, api, wire, track } from 'lwc';
import getRecordTypeName from '@salesforce/apex/AstapenkoToDoItemController.getRecordTypeName';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import RECORD_TYPE_ID_FIELD from '@salesforce/schema/To_Do__c.RecordTypeId';

export default class ToDoItem extends LightningElement {
    @api toDoItem;
    @api recordId;
    @api typeName = '0125j000000MvjyAAC';
    giveMeTypeName;

    handleClick(event) {
            // 1. Prevent default behavior of anchor tag click which is to navigate to the href url
            event.preventDefault();
            // 2. Read about event best practices at http://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.events_best_practices
            const selectEvent = new CustomEvent('select', {
                detail: this.toDoItem.Id
            });
            // 3. Fire the custom event
            this.dispatchEvent(selectEvent);
    }

    @wire(getRecordTypeName, {toDo: '$toDoItem'})
    getSomethingReturned(something) {
            if(something.data) {
                this.giveMeTypeName = something.data;
            }
        };
}