import { LightningElement, api, track } from 'lwc';
import employeeIdInfo from '@salesforce/apex/EmployeeIdCard.getEmployeeInfo';
import cloudImage from "@salesforce/resourceUrl/claud1";
import cloudBorder from "@salesforce/resourceUrl/claud2";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
export default class EmployeeInformation extends LightningElement {

    gittoImage = cloudImage;
    claudBase = cloudBorder;
    @track imageUrl;
    userName;
    @api recordId;
    profileUploaded = false;
    nameInitials;
    employeeData;
    @track checkbox = [];
    checkBoxInfo = [];
    changeValueAndFieldApi = [];
    handleCheckBoxChanges(event) {
        var value = event.target.checked;
        var field = event.target.value;
        var obj = {};
        obj[field] = value;
        this.changeValueAndFieldApi.push(obj);
    }
    connectedCallback() {
        employeeIdInfo({
            employeeRecordId: this.recordId
        }).then(result => {
            this.employeeData = result;
            this.imageUrl = this.employeeData[0].contentVersion;
            console.log('this.imageUrl=============>',this.imageUrl);
            this.imageUrl
            if (this.employeeData[0].lastName != undefined) {
                this.userName = this.employeeData[0].salutation + ' ' + this.employeeData[0].firstName + ' ' + this.employeeData[0].lastName;
                this.nameInitials = this.employeeData[0].firstName.charAt(0) + this.employeeData[0].lastName.charAt(0);
            } else {
                const firstCharacter = this.employeeData[0].firstName.charAt(0);

                const lastCharacter = this.employeeData[0].firstName.charAt(this.employeeData[0].firstName.length - 1);
                
                this.nameInitials = firstCharacter + lastCharacter;
                //console.log('Initial ===>  ',this.nameInitials);
                this.userName = this.employeeData[0].salutation + ' ' + this.employeeData[0].firstName;
            }
            if (this.imageUrl == undefined) {
                this.profileUploaded = true;
            }
            
        })
    }
    showToast(message, variant, title) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}