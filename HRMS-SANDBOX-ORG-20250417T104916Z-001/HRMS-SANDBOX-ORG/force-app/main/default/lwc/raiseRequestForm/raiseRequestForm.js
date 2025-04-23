import { LightningElement, track } from 'lwc';
import getFormRecord from '@salesforce/apex/RaiseRequestFormController.getFormRecord';


export default class RaiseRequestForm extends LightningElement {
    formList = [];
    @track isShowModal = false;
    showFormType;
    showFormId;


    connectedCallback() {
        getFormRecord()
            .then(data => {
                data.forEach(currentItem => {
                    console.log('OUTPUT : ', currentItem.Name);
                    this.formList = [...this.formList, { label: currentItem.Name, value: currentItem.Id }];
                });

            });

    }

    showModalBox() {
        console.log('OUTPUT : ', event.detail.value);
        this.showFormType = event.detail.value;
        this.showFormId = event.detail.label;
        console.log('this.showFormId', this.showFormId);
        this.isShowModal = true;

        console.log('this.isShowModal', this.isShowModal);
    }

    closeModel(event) {
        if (event.detail.message) {
            this.isShowModal = false;
        }
    }
    hidemodal(event) {
        if (event.detail.message) {
            this.isShowModal = false;

        }
    }
    hideModalBox() {
        this.isShowModal = false;
    }


}