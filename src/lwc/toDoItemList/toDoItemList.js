import { LightningElement, wire, api } from 'lwc';
import { reduceErrors } from 'c/ldsUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { deleteRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import findToDoItems from '@salesforce/apex/ToDoController.findToDoItems';

// Import message service features required for subscribing and the message channel
import { subscribe, MessageContext } from 'lightning/messageService';
import TO_DO_SEARCH_CHANNEL from '@salesforce/messageChannel/ToDoSearch__c';
import TO_DO_CREATE_CHANNEL from '@salesforce/messageChannel/ToDoCreate__c';

export default class ToDoItemList extends NavigationMixin(LightningElement) {
    subscription = null;

    searchValue = '';
    error;
    toDoItems;
    retrievedToDos;
    isEmpty = false;
    statusNotSelected = false;
    visibleToDos;

    todayIsSelected = true;
    handleTodayClick() {
        this.todayIsSelected = !this.todayIsSelected;
    }

    tomorrowIsSelected = true;
    handleTomorrowClick() {
        this.tomorrowIsSelected = !this.tomorrowIsSelected;
    }

    laterIsSelected = true;
    handleLaterClick() {
        this.laterIsSelected = !this.laterIsSelected;
    }

    doneIsSelected = true;
    handleDoneClick() {
        this.doneIsSelected = !this.doneIsSelected;
    }

    notDoneIsSelected = true;
    handleNotDoneClick() {
       this.notDoneIsSelected = !this.notDoneIsSelected;
    }

    @wire(findToDoItems, { searchKey: '$searchValue', isTodaySelected : '$todayIsSelected',
     isTomorrowSelected : '$tomorrowIsSelected', isLaterSelected : '$laterIsSelected',
     doneIsSelected: '$doneIsSelected', notDoneIsSelected: '$notDoneIsSelected'})
    wiredToDoItems(retrievedToDos) {
        this.retrievedToDos = retrievedToDos;
        console.log(retrievedToDos.data);
        console.log('doneIsSelected:' + this.doneIsSelected);
        console.log('notDoneIsSelected:' + this.notDoneIsSelected);
          if (retrievedToDos.data) {
               this.toDoItems = retrievedToDos.data;
               if (this.doneIsSelected == false && this.notDoneIsSelected == false) {
                   this.statusNotSelected = true;
                   this.isEmpty = true;
               } else {
                   this.statusNotSelected = false;
                   this.isEmpty = false;
               }
          } else if (retrievedToDos.error) {
               this.error = retrievedToDos.error;
          }
    }

    handleSelect(event) {
       refreshApex(this.retrievedToDos);
    }

    handleDelete(event) {
        const toDoId = event.detail;
        console.log('toDoId: ' + toDoId);
        deleteRecord(toDoId)
             .then(() => {
                   this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'To Do deleted',
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

    updateToDoHandler(event){
        this.visibleToDos = [...event.detail.records];
        console.log(event.detail.records);
    }


}