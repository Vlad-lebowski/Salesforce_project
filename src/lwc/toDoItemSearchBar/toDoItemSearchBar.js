import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import TO_DO_SEARCH_CHANNEL from '@salesforce/messageChannel/ToDoSearch__c';

export default class ToDoItemSearchBar extends LightningElement {

    @wire(MessageContext)
    messageContext;

    searchKey = '';

    handleSearch(event) {
        const searchKey = event.target.value;
        this.searchKey = searchKey;
        const payload = { searchKey: this.searchKey };
        console.log(payload);
        publish(this.messageContext, TO_DO_SEARCH_CHANNEL, payload);
    }
}