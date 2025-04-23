import { LightningElement, wire, api,track} from 'lwc';
import getSurveyRecord from '@salesforce/apex/DynamicFormController.getSurveyRecord';
import createSurveyResponse from '@salesforce/apex/DynamicFormController.createSurveyResponse';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { CurrentPageReference } from 'lightning/navigation';

export default class DynamicForm extends LightningElement {

    surveyList = [];
    @track selectedItemsLabel;
    @track selectedItemValue;
    cheked = false;
    value = '';
    @api recordId;
    @track isLoading = false;


    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
        }
    }

    @wire(getSurveyRecord, {})
    wireData(result) {
        this.surveyList = result.data;
    }

    get options() {
        return this.surveyList;
    }

    handleRadioChange(event) {
        this.selectedItemValue = event.target.value;
        let labelVal = event.target.options;
        labelVal.forEach(element => {
        if( this.selectedItemValue == element.value){
            this.selectedItemsLabel = element.label;
        }
        });
        
    }

    sendButtonClick() {
            this.isLoading = true;
        createSurveyResponse({ surveyName: this.selectedItemsLabel, surveyId: this.selectedItemValue, employeeId: this.recordId }).then(result => {
            console.log('____________',result);
            if(result){
                console.log('_____________',result);
                this.isLoading = false;
                const showSuccess = new ShowToastEvent({
                title: 'Success!!',
                message: 'sent Email successfully.',
                variant: 'Success',
            });
            this.dispatchEvent(showSuccess);
            this.dispatchEvent(new CloseActionScreenEvent());
            }
            else{
                this.isLoading = false;
                const showSuccess = new ShowToastEvent({
                title: 'Error!!',
                message: 'Email Not sent successfully.',
                variant: 'Error',
            });
            this.dispatchEvent(showSuccess);
            this.dispatchEvent(new CloseActionScreenEvent());

            }
            
        }).catch(error => {
            console.log("Error Occured");
        })
        
    }

    handleCancelClick() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}