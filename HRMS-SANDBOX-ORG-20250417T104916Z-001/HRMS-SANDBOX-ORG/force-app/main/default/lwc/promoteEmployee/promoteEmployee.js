import { LightningElement ,api, wire} from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDesignation from '@salesforce/apex/PromoteEmployeeController.getDesignation';
import updateEmployeeDesignation from '@salesforce/apex/PromoteEmployeeController.updateEmployeeDesignation';




export default class PromoteEmployee extends LightningElement {
@api recordId;
designationList;
tempVar;
value = '';

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
            console.log('this.recordId',this.recordId);
        }
    }
 
    connectedCallback() {
        getDesignation().then(result => {
            let picklistOptions = result;
             this.designationList =  picklistOptions ;         
        }).catch(error => {
            console.log("Error Occured");
        })
    }

        sendButtonClick(){

            let designation;
            console.log('this.recordId',this.recordId);
            this.tempVar = this.template.querySelectorAll('[data-name = "inputValue"]');
            console.log(' this.tempVar', this.tempVar);
             this.tempVar.forEach((element) => {
                 designation = element.value;
                 console.log('designation' +designation);
             });

             updateEmployeeDesignation({designation : designation, recordId : this.recordId}).then(result => {
                 if(result){
                     console.log('result',result);
                     const showSuccess = new ShowToastEvent({
                        title: 'Success!!',
                        message: 'Your Designation is successfully updated to ' + result,
                        variant: 'Success',
                    });
                    this.dispatchEvent(showSuccess);
                    this.dispatchEvent(new CloseActionScreenEvent());

                 }else{
                     const showSuccess = new ShowToastEvent({
                        title: 'Warning!!',
                        message: 'You choose same designation..! Kindly choose correct designation to promote the Employee',
                        variant: 'Warning',
                    });
                    this.dispatchEvent(showSuccess);

                 }

             }).catch(error => {
            console.log("Error Occured");
        })

        }
    



















    handleCancelClick() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }


}