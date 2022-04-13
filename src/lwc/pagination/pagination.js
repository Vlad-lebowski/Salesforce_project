import { LightningElement, api } from 'lwc';

export default class Pagination extends LightningElement {
    currentPage = 1;
    totalRecords;
    @api recordSize = 5;
    visibleRecords;
    totalPage;

    get records(){
        return this.visibleRecords;
    }

    @api
    set records(data){
        if(data){
            this.totalRecords = data;
            this.totalPage = Math.ceil(data.length/this.recordSize);
            this.updateRecords();
        }
    }

    get disablePrevious(){
        return this.currentPage<=1;
    }

    get disableNext(){
        return this.currentPage>=this.totalPage;
    }

    previousHandler(){
        if(this.currentPage > 1){
            this.currentPage = this.currentPage - 1;
            this.updateRecords();
        }
    }

    nextHandler(){
        console.log(this.currentPage);
        console.log(this.totalPage);
        if(this.currentPage < this.totalPage){
            this.currentPage = this.currentPage + 1;
            this.updateRecords();
        }
    }

    updateRecords(){
        const start = (this.currentPage - 1) * this.recordSize;
        console.log(start);
        const end = this.recordSize * this.currentPage;
        console.log(end);
        console.log(this.visibleRecords);
        this.visibleRecords = this.totalRecords.slice(start, end);
        this.dispatchEvent(new CustomEvent('update', {
            detail: {
                records: this.visibleRecords
            }
        }))
    }
}