import { LightningElement,wire } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import uploadFiles from '@salesforce/apex/UploadDocumentsOnGDrive.uploadFileOnDrive';
import { CloseActionScreenEvent } from 'lightning/actions';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class UploadDocumentsOnGDrive extends LightningElement {
    isLoading = false;
    recordId;
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
           this.recordId = currentPageReference.state.recordId;
        }
    }
    connectedCallback(){
        this.isLoading = true;
        uploadFiles({recordId : this.recordId}).then(result=>{            
            if (result == 'uploaded') {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: ' Files uploaded Successfully On Drive: ',
                    variant: 'success',
                }), );
            } else {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Already Uploaded',
                    message: ' Files Already uploaded On Drive: ',
                    variant: 'Warning',
                }), );
            }
            this.dispatchEvent(new CloseActionScreenEvent());
        }).catch(error => {
            this.isLoading = false;
            const showError = new ShowToastEvent({
                title: 'Error!!',
                message: 'An Error occur while uploading the file.',
                variant: 'error',
            });
            this.dispatchEvent(showError);
            this.selectRecordType
            this.dispatchEvent(new CloseActionScreenEvent());
        });              
    }
    closeQuickAction() {
        const closeQA = new CustomEvent('close');
        this.dispatchEvent(closeQA);
    }
}