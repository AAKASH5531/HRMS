import { LightningElement, wire } from 'lwc';
import updateRecordFile from '@salesforce/apex/UpdateEmployeeDocument.updateRecordFiles';
import calloutForUpload from '@salesforce/apex/UpdateEmployeeDocument.calloutForUpload';
import getFieldLabel from '@salesforce/apex/UpdateEmployeeDocument.getFieldLabelName';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import updateEmployeeDocuments from '@salesforce/label/c.Update_Employee_Documents';
export default class UpdateEmployeeDocument extends LightningElement {
    recordTypeName;
    isRadioSelect = true;
    selectedFileName = {};
    uploadFile;
    selectedFile;
    isSelected = false;
    isDisableSave = true;
    optionsArray = [];
    showCrossButton = false;
    mapData;
    variable = false;
    isLoading = false;
    isDisabledFileUploader = true;
 value = [];
    message = '';


 get options() {
        return [
            { label: 'Employee Docs', value: 'Employee_Docs' },
            { label: 'Company Docs', value: 'Company_Docs' }
        ];
    }


    label = {
        updateEmployeeDocuments
    };
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
        }
    }
    connectedCallback() {
        getFieldLabel().then(result => {
            console.log('====result=====33===============>',result);
            this.optionsArray = result;
        }).catch(error => {
            console.log("Error Found");
        })
    }

    handleChange(event) {
        this.isDisableSave = true;
        this.selectedFile = '';
        this.showCrossButton = false;
        this.uploadFile = event.detail.value;
        this.logSelectedLabel(event.detail.value);
        this.isDisabledFileUploader = false;
    }

    handleCheckBoxChanges(event) {
        if(this.isSelected){
            this.isDisableSave = false;
        } 
        var value = event.target.value;
        console.log('---------------------value-------------------',event.target.value);
        var field = event.target.value;
        this.recordTypeName = event.target.value;
    }

    handleUploadFile(event) {
        this.showCrossButton = true;
        this.isDisableSave = true;
        const file = event.target.files[0];
        this.isSelected = false;
        this.isSelected = true;
        this.isRadioSelect = false;
        let Fname = file.name;
        Fname = Fname.replaceAll(/[^A-Z0-9]/ig, " ").replace(/\s+/g, ' ').toLowerCase();
        if (Fname.match(this.value.toLowerCase())) {
            this.selectedFile = this.value;
            this.isDisableSave = true;
            if (file) {
                this.readFile(file, this.value);
            }
        } else {
            this.isSelected = false;
            this.isDisableSave = true;
            console.log('error');;
            const evt = new ShowToastEvent({
                title: "Warning",
                message: 'Please select the same file ',
                variant: "warning",
            });
            this.dispatchEvent(evt);
        }
    }

    uploadFileToApexAsNote() {
        this.isLoading = true;
        updateRecordFile({ recordId: this.recordId, uploadedFile: this.selectedFileName, recordType: this.recordTypeName }).then(result => {
            if (result) {
                calloutForUpload({ base64: this.selectedFileName.base64, filename: result.title, folderId: result.folderId, mimeType: result.mimeType, recordId: result.recordId, recordType: this.recordTypeName }).then(resultOfUploadDrive => {
                    if (resultOfUploadDrive) {
                        this.showToast('Success', ' Files Updated Successfully: ', 'success');
                        this.isLoading = false;

                    } else {
                        this.showToast('Error', ' Files not updated Successfully: ', 'error');
                        this.isLoading = false;
                    }
                })
            }
        })
    }

    readFile(file, Fname) {
        var filename = file.name;
        var extension = filename.split('.');
        var file_extension = extension[extension.length - 1];
        Fname = Fname.concat('.' + file_extension);
        var reader = new FileReader();
        reader.onload = () => {
            var base64 = reader.result.split(',')[1];
            var fileData = {
                'filename': Fname,
                'base64': base64,
                'mimeType': file.type,
            };
            this.selectedFileName = fileData;
        };
        reader.readAsDataURL(file);
    }

    logSelectedLabel(selectedValue) {
        const selectedOption = this.optionsArray.find(option => option.value === selectedValue);
        if (selectedOption) {
            this.value = selectedOption.label;
        }
    }

    clickedCrossIcon() {
        this.isRadioSelect = true;
        this.selectedFile = '';
        this.showCrossButton = false;
        this.isDisableSave = true;
        this.isSelected = false;
    }

    showToast(titles, messages, variants) {
        this.variable = true;
        const toastEvent = new ShowToastEvent({
            title: titles,
            message: messages,
            variant: variants,
        });
        this.dispatchEvent(toastEvent);
        this.closeModel();
    }

    closeModel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}