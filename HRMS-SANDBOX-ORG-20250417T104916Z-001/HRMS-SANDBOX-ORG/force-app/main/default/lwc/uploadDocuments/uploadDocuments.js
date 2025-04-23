import {LightningElement,track, api, wire} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {CloseActionScreenEvent} from "lightning/actions";
import {CurrentPageReference} from 'lightning/navigation';
import saveFiles from '@salesforce/apex/DocumentsUpload.saveFiles';
import saveNonAttestedFile from '@salesforce/apex/DocumentsUpload.saveNonAttestedFile';
import updateEmployeeDoc from '@salesforce/apex/DocumentsUpload.updateEmployeeDoc';
import uploadDocument from '@salesforce/label/c.Upload_Document';
import uploadAttested from '@salesforce/label/c.Upload_Attested';
import uploadNonAttested from '@salesforce/label/c.Upload_Non_Attested';
export default class UploadDocuments extends LightningElement {
    disableNextButton= true;
    isLoading = false;
    @api recordId;
    fileData
    dataFile
    label = {
        uploadDocument,
        uploadAttested,
        uploadNonAttested


    };
    attestedFileUpload(event) {
        this.disableNextButton = false;
        const file = event.target.files[0];
        var reader = new FileReader();
        reader.onload = () => {
            var base64 = reader.result.split(',')[1];
            this.fileData = {
                'fileName': file.name,
                'base64': base64,
                'recordId': this.recordId
            }
        }
        reader.readAsDataURL(file);
    }

    nonAttestedFileUpload(event) {
        this.disableNextButton= false;
        const file = event.target.files[0];
        console.log('==28====>',file);
        var reader = new FileReader();
        reader.onload = () => {
            var base65 = reader.result.split(',')[1]
            this.dataFile = {
                'docName': file.name,
                'base65': base65,
                'recordId': this.recordId
            }
        }
        reader.readAsDataURL(file);
    }

    handleSaveFiles() {
           this.isLoading = true;
     if (this.fileData) {
            const {
                base64,
                fileName,
                recordId
            } = this.fileData
            console.log('fileData : ', this.fileData);
               
            saveFiles({
                base64,
                fileName,
                recordId
            }).then(result => { 
             
                this.fileData = null
                let title = `${fileName} uploaded successfully!!`
                this.toast(title)
                //  updateEmployeeDoc({employeeRecordId: this.recordId});
            })
        }
        if (this.dataFile) {
            const {
                base65,
                docName,
                recordId
            } = this.dataFile
            console.log('dataFile : ', this.dataFile);
            saveNonAttestedFile({
                base65,
                docName,
                recordId
            }).then(result => {
                
                console.log('result : ', result);
               
                this.dataFile = null
                let title = `${docName} uploaded successfully!!`
                this.toast(title)
                // updateEmployeeDoc({employeeRecordId: this.recordId});
            })
        }
    }
    
    toast(title) {
         this.isLoading = false;
        const toastEvent = new ShowToastEvent({
            title,
            variant: "success"
        })
        this.dispatchEvent(toastEvent)
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    handleCancelClick(){
 this.dispatchEvent(new CloseActionScreenEvent());    }
    closeQuickAction() {
        const closeQA = new CustomEvent('close');
        this.dispatchEvent(closeQA);
    }
    
}