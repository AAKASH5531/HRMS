import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import collectAllEmpInfo from '@salesforce/apex/ReHireCustomCloneButton.collectEmployeeDetails';

export default class ReHireCloneButton extends NavigationMixin(LightningElement) {
    recordId;
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
        }
    }

    connectedCallback() {
        collectAllEmpInfo({ empId: this.recordId }).then(record => {
            console.log(record);
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    objectApiName: 'Employee__c',
                    actionName: 'clone',
                },
                state: {
                    useRecordTypeCheck: 1
                }
            });
        }).catch(error => this.displaytoast('error', error.message ? (Array.isArray(error.message) ? error.message[0] : error.message) : error.body.message));
    }

    displaytoast = (type, message) => {
        this.dispatchEvent(new ShowToastEvent({ variant: type, title: type.toUpperCase(), message: message }));
    }
}