import { LightningElement,api } from 'lwc';
import getSObjectRecordId from '@salesforce/apex/UploadDocumentStatus.getSObjectRecordId';
export default class uploadDocumentStatus extends LightningElement {
@api recordId;
isMultipleFileUploaded = false;
isEmployeeDocument= false;
records=[];
    connectedCallback(){
        console.log('this.recordId---> ',this.recordId);
        getSObjectRecordId({recordId : this.recordId}).then(result=>{
            if(result.length > 0){
           this.records = result;
             console.log('this.records--> ',this.records);
            if(this.records[0].objectName == 'Employee_Document__c'){
             this.isMultipleFileUploaded = true;
             this.isEmployeeDocument= true;
            }
            }
        })
    }
}