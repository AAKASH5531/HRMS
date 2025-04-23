import { LightningElement, api, wire, track } from 'lwc';
import dynamicForm from '@salesforce/apex/DynamicFormController.dynamicForm';
import { CurrentPageReference } from 'lightning/navigation';
import getOrgBaseUrl from '@salesforce/apex/DynamicFormController.getOrgBaseUrl';
import saveRecord from '@salesforce/apex/DynamicFormController.saveRecord';
import createValidation from '@salesforce/apex/DynamicFormController.createValidation';
import isFormIsCreated from '@salesforce/apex/DynamicFormController.isFormIsCreated';
import checkBusinessDay from '@salesforce/apex/RaiseRequestFormController.checkBusinessDay';
import { CloseActionScreenEvent } from 'lightning/actions';




import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class SurveyForm extends LightningElement {
    @track isLoading = false;
    questionList = [];
    @api recordId;
    communityBaseUrl;
    formURL;
    recordIds;
    tempVar;
    o = [];
    handleCheckbox = true;
    option = [];
    picValOption = [];
    showChild = false;
    mainComp = true;
    gettingNullResponse = false;
    @track isAttachmentCheck = true;
    errorMessage = '';
    fileData = [];
    isInOutTimeCheck = true;
    isAvailableLeave = true;
    isCheckWorkingDay = true;
    @api showFormType;
    showButton = false;
    closeModel = true;
    isOneDayPaidLeave;
    todayDate;
    setDate;
    startDate;
    endDate;
    leaveDateFrom;
    leaveDateTo;
    countDay;
    isCheckStartDate;
    isCheckEndDate;
    isCheckLeaveDateFrom;
    isCheckLeaveDateTo;
    isSickLeave = true;
    addAdditionalSkill = false;
    showSubmitButton = false;



    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
        }
    }

    @wire(getOrgBaseUrl)
    wiredBaseUrl(result) {
        const { error, data } = result;
        if (data) {
            this.communityBaseUrl = `${data}`;
            console.log(this.communityBaseUrl);
        } else if (error) {
            console.error('Error: ', error);
        }
    }

    handleAddSkill(event) {
        let label = event.target.options;
        let getvalue = event.target.value;

        label.forEach(element => {
            if (element.value == getvalue) {
                let tempObj = [];
                if (element.label == 'Other') {
                    this.tempQuestionList.forEach(element => {
                        tempObj.push(element);
                    });
                } else {
                    this.tempQuestionList.forEach(element => {
                        if (element.questionName != 'Other Skill') {
                            tempObj.push(element);
                        }
                    });
                }
                this.questionList = JSON.parse(JSON.stringify(tempObj));
            }
        })
        console.log('this.addAdditionalSkill', this.addAdditionalSkill);

    }


    tempQuestionList = [];
    connectedCallback() {

        let tempURL = document.URL.toString();
        this.recordIds = tempURL.substring(tempURL.indexOf('=') + 1);
        this.formURL = tempURL.substring(0, tempURL.indexOf('?'));

        isFormIsCreated({ recordId: this.recordIds }).then(data => {
            if (data) {
                this.errorMessage = 'Your response is already submitted';
                this.mainComp = false;
                this.showChild = false;
                this.gettingNullResponse = true;
            } else {
                createValidation({ recordId: this.recordIds }).then(result => {
                    console.log('OUTPUT : ', result);
                    result.forEach(element => {
                        if (element.outOfDate == 'Start Date') {
                            this.errorMessage = 'The form will be open from ' + element.surveyStartDate;
                        }
                        if (element.outOfDate == 'End Date') {
                            this.errorMessage = 'The form will be closed';
                        }
                        if (element.isFormStatus) {
                            this.gettingNullResponse = false;
                            this.ShowDataOnLoad();
                        } else {
                            this.mainComp = false;
                            this.showChild = false;
                            this.gettingNullResponse = true;
                        }
                    });

                }).catch(error => {
                })

                console.log(this.formURL);
                if (this.formURL == 'https://algocirrusprivatelimited--hrms.sandbox.lightning.force.com/lightning/action/quick/Form__c.Preview') {
                    this.showButton = true;

                    dynamicForm({ recordId: this.recordId, url: this.formURL }).then(result => {
                        this.questionList = result;
                        console.log('this.questionList', this.questionList);
                        result.forEach(element => {
                            this.showFormLabel = element.surveyName;
                            console.log(' element.surveyName', element.surveyName);
                        })

                    }).catch(error => {
                        console.log("Error Occured");
                    })
                }
            }

            if (this.showFormType != null) {
                this.showButton = true;
                this.showSubmitButton = true;

                console.log('this.showFormType', this.showFormType);
                dynamicForm({ recordId: this.showFormType, url: '' }).then(result => {
                    this.tempQuestionList = result;
                    let tempObj = [];
                    result.forEach(element => {
                        this.showFormLabel = element.surveyName;
                        if (element.questionName != 'Other Skill') {
                            console.log('Is ture');
                            tempObj.push(element);
                        }
                    });
                    this.questionList = JSON.parse(JSON.stringify(tempObj));
                }).catch(error => {
                    console.log("Error Occured");
                })
            }

        });

    }

    ShowDataOnLoad() {

        if (this.formURL == 'https://algocirrusprivatelimited--hrms.sandbox.my.site.com/') {

            this.showSubmitButton = true;
            dynamicForm({ recordId: this.recordIds, url: this.formURL }).then(result => {
                this.questionList = result;
                console.log('listquestion', this.questionList);
                result.forEach(element => {
                    this.showFormLabel = element.surveyName;
                })
            }).catch(error => {
                console.log("Error Occured");
            })
        }

    }



    handleQuestionChange(event) {

        let label = event.target.label;
        let value = event.target.value;
        if (event.target.type == 'file') {
            const file = event.target.files[0]
            var reader = new FileReader()
            reader.onload = () => {
                var base64 = reader.result.split(',')[1]
                this.fileData = {
                    'filename': file.name,
                    'base64': base64
                    //'recordId': this.recordId
                }
                console.log('this.fileData -> ', this.fileData)
            }
            reader.readAsDataURL(file)
        }
    }

    handleClick(event) {
        this.o = [];
        this.tempVar = this.template.querySelectorAll('[data-name = "inputValue"]');
        let inTime;
        let outTime;
        let reSourceType;
        let requestStatus;
        let attachment;
        let availableCompOff;
        let finalDate;
        let typeOfLeave;

        let reasonDescription;


        this.tempVar.forEach((element) => {

            if (!element.checkValidity()) {
                element.reportValidity();
                this.handleCheckbox = false;
            }
            if (element.label == 'In Time') {
                inTime = new Date(element.value);
                inTime.setHours(inTime.getHours() + 9);
            } else
                if (element.label == 'Out Time') {
                    outTime = new Date(element.value);
                }
            if (element.label == 'Resource Type') {
                reSourceType = element.value;
            }
            if (element.label == 'Request Status') {
                requestStatus = element.value;
            }
            if (element.label == 'Attachment') {
                attachment = element.value;
            }
            if (element.label == 'Available Comp-Off') {
                availableCompOff = element.value;
            }
            if (element.label == 'Start Date') {
                this.setDate = new Date(element.value);
                this.startDate = new Date(element.value);
            }
            if (element.label == 'End Date') {
                this.endDate = new Date(element.value);
                finalDate = new Date(this.startDate.setDate(this.startDate.getDate() + availableCompOff.length - 1));
                if (finalDate.getDate() == this.endDate.getDate()) {
                    this.isAvailableLeave = true;
                    console.log('correct', this.isAvailableLeave);

                } else {
                    const showSuccess = new ShowToastEvent({
                        title: 'Error!!',
                        message: 'The count of available leave is less then apply leaves count',
                        variant: 'Error',
                    });
                    this.dispatchEvent(showSuccess);
                    this.isAvailableLeave = false;
                    console.log('wrong', this.isAvailableLeave);
                }
            }
            if (element.label == 'Type of Leave') {
                typeOfLeave = element.value;
            }
            if (element.label == 'Leave Date From') {
                this.leaveDateFrom = element.value;
            }
            if (element.label == 'Leave Date To') {
                this.leaveDateTo = element.value;
            }
            if (element.label == 'Reason Description (attachment)') {
                reasonDescription = element.value;
            }


            this.o.push({ label: element.label, value: element.value.toString() });

        });
        console.log('test', JSON.stringify(this.o));

        // if (typeOfLeave == 'SL' && this.leaveDateFrom < this.leaveDateTo  && reasonDescription.length == 0) {
        //     const showSuccess = new ShowToastEvent({
        //         title: 'Error!!',
        //         message: 'Please attach your reports ',
        //         variant: 'Error',
        //     });
        //     this.dispatchEvent(showSuccess);
        //     this.isSickLeave = false;
        // } else
        //     if (typeOfLeave == 'SL' && this.leaveDateFrom < this.leaveDateTo && reasonDescription.length > 0) {
        //         this.isSickLeave = true;
        //     }


        if ((reSourceType == 'Laptop' || reSourceType == 'Access Card') && requestStatus == 'Lost' && attachment.length == 0) {
            console.log('reSourceType : ', reSourceType, ' -- requestStatus : ', requestStatus, ' -- attachment.length : ', attachment.length);
            const showSuccess = new ShowToastEvent({
                title: 'Error!!',
                message: 'please attach FIR copy ',
                variant: 'Error',
            });
            this.dispatchEvent(showSuccess);
            this.isAttachmentCheck = false;
        } else
            if ((reSourceType == 'Laptop' || reSourceType == 'Access Card') && requestStatus == 'Lost' && attachment.length > 0) {
                this.isAttachmentCheck = true;
            }

        if (inTime <= outTime) {
            console.log("inTime: ", inTime);
            console.log("outTime: ", outTime);
            this.isInOutTimeCheck = true;
        } else
            if (inTime > outTime) {
                this.isInOutTimeCheck = false;
                console.log('OUTPUT : ', 'Your 9 hours is not completed please complete your 9 hours');
                const showSuccess = new ShowToastEvent({
                    title: 'Error!!',
                    message: 'Your 9 hours is not completed please complete your 9 hours',
                    variant: 'Error',
                });
                this.dispatchEvent(showSuccess);
            }

        if (typeOfLeave == 'PL' && this.leaveDateFrom == this.leaveDateTo) {
            this.countDay = 5;
            this.checkLeaveApply();
        }
        else if (typeOfLeave == 'PL' && this.leaveDateFrom < this.leaveDateTo) {
            this.countDay = 10;
            this.checkLeaveApply();
        }

        else if (typeOfLeave == 'HD' && this.leaveDateFrom == this.leaveDateTo) {
            this.countDay = 3;
            this.checkLeaveApply();
        }

        else if (typeOfLeave == 'FL' && this.leaveDateFrom <= this.leaveDateTo) {
            this.countDay = 10;
            this.checkLeaveApply();
        } else if (this.startDate && this.endDate) {
            this.checkLeaveApply();
        }
        else if (typeOfLeave == 'SL' && this.leaveDateFrom < this.leaveDateTo && reasonDescription.length == 0) {
            const showSuccess = new ShowToastEvent({
                title: 'Error!!',
                message: 'Please attach your reports ',
                variant: 'Error',
            });
            this.dispatchEvent(showSuccess);
            this.isSickLeave = false;
        } else
            if (typeOfLeave == 'SL' && this.leaveDateFrom < this.leaveDateTo && reasonDescription.length > 0) {
                this.isSickLeave = true;
                this.countDay = 0;
                this.checkLeaveApply();
            }
            else if (typeOfLeave == 'SL' && this.leaveDateFrom == this.leaveDateTo) {
                this.countDay = 0;
                this.checkLeaveApply();
                this.isSickLeave = true;

            }
            else {
                this.submitFromRecord();
            }
    }


    checkLeaveApply() {
        checkBusinessDay({ leaveDateFrom: this.leaveDateFrom, leaveDateTo: this.leaveDateTo, countDay: this.countDay, startDate: this.setDate, endDate: this.endDate })
            .then(result => {
                console.log('result', result);
                result.forEach(element => {
                    this.isOneDayPaidLeave = element.countDate;
                    this.isCheckStartDate = element.isCheckStartDate;
                    this.isCheckEndDate = element.isCheckEndDate;
                    this.isCheckLeaveDateFrom = element.isCheckLeaveDateFrom;
                    this.isCheckLeaveDateTo = element.isCheckLeaveDateFrom;

                });
                //this.isOneDayPaidLeave = result;
                if (this.isOneDayPaidLeave != null && this.isCheckLeaveDateFrom && this.isCheckLeaveDateTo) {
                    console.log('this.isOneDayPaidLeave', this.isOneDayPaidLeave);
                    this.todayDate = new Date().toISOString().substring(0, 10);
                    if (this.isOneDayPaidLeave >= this.todayDate) {
                        this.submitFromRecord();
                    } else {
                        console.log('you are late');
                        const showSuccess = new ShowToastEvent({
                            title: 'Error!!',
                            message: 'You are late for apply leave contact with HR department',
                            variant: 'Error',
                        });
                        this.dispatchEvent(showSuccess);
                    }
                    console.log('1st run : ');
                } else
                    if (this.isOneDayPaidLeave != null && !this.isCheckLeaveDateFrom && !this.isCheckLeaveDateTo) {
                        console.log('2nd run : ');

                        const showSuccess = new ShowToastEvent({
                            title: 'Error!!',
                            message: 'Please apply leaves for working days only',
                            variant: 'Error',
                        });
                        this.dispatchEvent(showSuccess);
                    } else
                        if (this.isCheckStartDate && this.isCheckEndDate) {
                            console.log('workingday');
                            this.isCheckWorkingDay = true;
                            this.submitFromRecord();
                        } else {
                            this.isCheckWorkingDay = false;
                            console.log('you are not working day');
                            const showSuccess = new ShowToastEvent({
                                title: 'Error!!',
                                message: 'Apply leave separately because company holiday is lie between your leave duration',
                                variant: 'Error',
                            });
                            this.dispatchEvent(showSuccess);
                        }

            });
    }


    submitFromRecord() {
        if (this.o.length > 0) {
            console.log('handleCheckbox', this.handleCheckbox);
            console.log('this.isInOutTimeCheck', this.isInOutTimeCheck);
            console.log('this.isAttachmentCheck', this.isAttachmentCheck);
            console.log('this.isAvailableLeave', this.isAvailableLeave);
            console.log('this.isSickLeave', this.isSickLeave);

            if (this.handleCheckbox && this.isInOutTimeCheck && this.isAttachmentCheck && this.isAvailableLeave && this.isSickLeave && this.isCheckWorkingDay) {
                this.isLoading = true;
                console.log('call apex');
                var base64;
                var filename;

                if (Object.keys(this.fileData).length > 0) {
                    filename = this.fileData.filename;
                    base64 = this.fileData.base64;
                } else {
                    filename = '';
                    base64 = '';
                }
                saveRecord({ wrapLists: JSON.stringify(this.o), recordId: this.recordIds, showFormType: this.showFormType, base64: base64, filename: filename })
                    .then(result => {
                        // this.fileData = null

                        console.log("called", this.recordIds);
                        if (this.recordIds != null && this.recordIds != 'https://algocirrusprivatelimited--hrms.sandbox.lightning.force.com/lightning/page/home') {
                            this.mainComp = false;
                            this.showChild = true;
                            this.isLoading = false;
                        }
                        else {
                            this.dispatchEvent(new CustomEvent('inhidemodal', {
                                detail: {
                                    message: true
                                }
                            }));
                            this.isLoading = false;
                            const showSuccess = new ShowToastEvent({
                                title: 'Success!!',
                                message: 'Your request successfully submitted.',
                                variant: 'Success',
                            });
                            this.dispatchEvent(showSuccess);
                        }
                    })
                    .catch(error => {
                        console.log("error ", error);
                    });

            }
        }

    }




    hideModalBox(event) {
        console.log('-------1111');
        //this.mainComp = false;
        this.dispatchEvent(new CustomEvent('increasecount', {
            detail: {
                message: true
            }
        }));
        this.dispatchEvent(new CloseActionScreenEvent());
        //  var url = window.location.href; 
        // var value = url.substr(0,url.lastIndexOf('/') + 1);
        // window.history.back();

    }

}