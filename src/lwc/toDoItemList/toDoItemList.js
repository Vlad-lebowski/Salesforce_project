import { LightningElement, wire, api } from 'lwc';
import { reduceErrors } from 'c/ldsUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { deleteRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import findToDoItems from '@salesforce/apex/AstapenkoToDoItemController.findToDoItems';

// Import message service features required for subscribing and the message channel
import { subscribe, MessageContext } from 'lightning/messageService';
import TO_DO_SEARCH_CHANNEL from '@salesforce/messageChannel/ToDoSearch__c';
import TO_DO_CREATE_CHANNEL from '@salesforce/messageChannel/ToDoCreate__c';

export default class ToDoItemList extends NavigationMixin(LightningElement) {
    subscription = null;

    searchValue = '';
    error;
    toDoItems;
    isEmpty = false;
    selectedAndNotEmpty = false;
    retrievedToDos;

    @wire(findToDoItems, { searchKey: '$searchValue'})
    wiredToDoItems(retrievedToDos) {
        this.retrievedToDos = retrievedToDos;
        console.log(retrievedToDos.data);
          if (retrievedToDos.data) {
               this.toDoItems = retrievedToDos.data;
               //this.error = undefined;
               if (this.toDoItems.length == 0) {
                   this.isEmpty = true;
                   this.selectedAndNotEmpty = false;
               } else {
                   this.isEmpty = false;
               }
          } else if (retrievedToDos.error) {
               this.error = retrievedToDos.error;
               //this.toDoItems = undefined;
          }
    }

    handleSelect(event) {
       refreshApex(this.retrievedToDos);
    }

    deleteToDoItem(event) {
            const recordId = event.target.dataset.recordid;
            deleteRecord(recordId)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'To Do Item deleted',
                            variant: 'success'
                        })
                    );
                    return refreshApex(this.retrievedToDos);
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

        @wire(MessageContext)
            messageContext;
        // Encapsulate logic for LMS subscribe.
        subscribeToMessageChannel() {
            this.subscription = subscribe(
                this.messageContext,
                TO_DO_SEARCH_CHANNEL,
                (message) => this.handleMessage(message)
            );
        }

        subscribeToAnotherMessageChannel() {
            this.subscription = subscribe(
                this.messageContext,
                TO_DO_CREATE_CHANNEL,
                (message) => this.handleMessage(message)
            );
        }

        // Handler for message received by component
        handleMessage(message) {
            this.searchValue = message.searchKey;
        }

        connectedCallback() {
            this.subscribeToMessageChannel();
        }


}