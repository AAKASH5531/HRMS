import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import searchForExistingEmployee from '@salesforce/apex/SearchForExistingEmployee.searchForExistingEmployee';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import validAadharNumber from '@salesforce/label/c.Valid_Aadhar_number';
import validateAadharOrPan from '@salesforce/label/c.Validate_Aadhar_or_Pan';
import validPanNumber from '@salesforce/label/c.Valid_Pan_number';
import existingEmployee from '@salesforce/label/c.Existing_employee';
import noExistingEmployee from '@salesforce/label/c.No_Existing_employee';
import { RefreshEvent } from 'lightning/refresh';
const columns = [{
    label: "EMPLOYEE ID",
    fieldName: "recordLink",
    type: "url",
    typeAttributes: {
        label: {
            fieldName: "Name"
        },
        tooltip: "Name",
        target: "_blank"
    }
},
{
    label: "Name",
    fieldName: "recordLink",
    type: "url",
    typeAttributes: {
        label: {
            fieldName: "First_Name__c"
        },
        tooltip: "Name",
        target: "_blank"
    }
},

{
    label: 'Designation',
    fieldName: 'Designation__c',

}, {
    label: 'AADHAR Number',
    fieldName: 'AADHAR_Number__c',
    type: 'text'
},
{
    label: 'PAN Number',
    fieldName: 'PAN_Number__c',
    type: 'text'
},
];

export default class RehireEmployee extends NavigationMixin(LightningElement) {
    
    showToast = false;
    panInput = false;
    searchData;
    columns = columns;
    errorMsg = '';
    strSearchAccName = '';
    firstNAme;
    ExistingEmployeeId;
    showData = false;
    dataList = [];
    afterSpace; 

    handleEmployeeInfo(event) {
        this.showData = false;
        this.errorMsg = '';
        this.strSearchInput = event.currentTarget.value.replaceAll(' ', '');
        this.strSearchAccName = event.currentTarget.value;
        searchForExistingEmployee({
            searchInput: this.strSearchAccName
        }).then(result => {
            var tempList = [];
            if (result.length > 0) {
                this.showToast = true;
            } else {
                this.showToast = false;
            }
            for (var i = 0; i < result.length; i++) {
                let tempRecord = {};
                tempRecord = result[i];
                tempRecord.recordLink = "/" + result[i].Id;
                tempList.push(tempRecord);
            }
            this.dataList = tempList;
            this.searchData = result;
            this.firstNAme = this.searchData[0].First_Name__c;
            this.ExistingEmployeeId = this.searchData[0].Id;
        }).catch(error => {
            this.searchData = undefined;
        })
    }

    handleSearch() {
        this.dispatchEvent(new RefreshEvent());
        this.showData = true;
        let regex = new RegExp(/^[2-9]{1}[0-9]{3}\s[0-9]{4}\s[0-9]{4}$/);
        var regpan = /^([a-zA-Z]){5}([0-9]){4}([a-zA-Z]){1}?$/;
        if (!this.strSearchAccName) {
           this.showData = false;
            this.errorMsg = validateAadharOrPan;
            this.searchData = undefined;
            return;
        }
        if ((!regpan.test(this.strSearchAccName) == true) && (/^\d/.test(this.strSearchAccName) == false)) {
            this.showData = false;
            this.panInput = true;
            this.errorMsg = validPanNumber;
            return;
        }
         if ((regex.test(this.strSearchAccName) == true || this.strSearchAccName.length != 12) && (/^\d/.test(this.strSearchAccName)) || /\s/g.test(this.strSearchAccName)) {
            this.showData = false;
            this.errorMsg = validAadharNumber;
            this.searchData = undefined;
            return;
        }
        if ((this.showToast == true) && ((regex.test(this.strSearchAccName) == false || this.strSearchAccName.length == 12))) {
            const showSuccess = new ShowToastEvent({
                title: 'Success!!',
                message: existingEmployee,
                variant: 'Success',
            });
            this.dispatchEvent(showSuccess);
            this.dispatchEvent(new RefreshEvent());
            this.dispatchEvent(new CloseActionScreenEvent());
        }
        if (this.showToast == false) {
            this.showData = false;
            const showError = new ShowToastEvent({
                title: 'Error!!',
                message: noExistingEmployee,
                variant: 'error',
            });
            this.dispatchEvent(showError);
            this.dispatchEvent(new CloseActionScreenEvent());
        }
    }
    navigateToRecord(event) {
        const recordId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.currentTarget.dataset.id,
                objectApiName: 'Employee__c',
                actionName: 'view'
            }
        });
    }
}