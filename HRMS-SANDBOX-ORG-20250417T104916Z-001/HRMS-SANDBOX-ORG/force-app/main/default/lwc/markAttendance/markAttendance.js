import { LightningElement,track } from 'lwc';
import markAttendance from '@salesforce/apex/MarkAttendanceController.markAttendance';
import checkAttendance from '@salesforce/apex/MarkAttendanceController.checkAttendance';
import markHalfDayAttendance from '@salesforce/apex/MarkAttendanceController.markHalfDayAttendance';
import applyAttendance from '@salesforce/label/c.Apply_Attendance';
import applyHalfDay from '@salesforce/label/c.Apply_Half_Day';
import applyCompOff from '@salesforce/label/c.Apply_Comp_Off';
import logYourAttendance from '@salesforce/label/c.Log_Your_Attendance';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MarkAttendance extends LightningElement {

    label = {
        applyAttendance,
        applyHalfDay,
        applyCompOff,
        logYourAttendance
    };
    
    isAttendanceButtonDisable = true;
    markAttendanceStartTime;
    markAttendanceEndTime;
    checkBusinessDay;
    checkMarkAttendance;
    halfDayStartTime;
    halfDayEndTime;
    isHalfDayAttendanceDisable = true;
    compOfCheck ;
    iscompOfCheckDisable = true;
     @track isShowModal = false;
     showFormId;
     @track isShowSkillModal = false;

    connectedCallback() {
        
       const currentTime = new Date();
        checkAttendance({})
        .then(result => {
                result.forEach(element => {
                this.markAttendanceStartTime = element.startTime;
                this.markAttendanceEndTime= element.endTime;
                this.checkMarkAttendance= element.checkMarkAttendance;
                this.checkBusinessDay= element.checkBusinessDay;
                this.halfDayStartTime= element.halfDayStartTime;
                this.halfDayEndTime= element.halfDayEndTime;
                this.compOfCheck = element.compOfCheck;
                });

                if(this.checkMarkAttendance){
                    this.isAttendanceButtonDisable = true;
                    this.isHalfDayAttendanceDisable = true;
                }
           
                    else if(this.checkBusinessDay){
                        const currentHour = currentTime.getHours();
                        const startTime = this.markAttendanceStartTime; 
                        const endTime =  this.markAttendanceEndTime;

                        if (currentHour >= startTime  && currentHour < endTime ) {
                            this.isAttendanceButtonDisable = false;
                        }
                        else{
                            this.isAttendanceButtonDisable = true;
                        }
                    }
                    else{
                        this.isAttendanceButtonDisable = true;
                    }


                    if(this.checkMarkAttendance){
                    this.isHalfDayAttendanceDisable = true;

                   }

                    else if(this.checkBusinessDay){
                        const currentHour = currentTime.getHours();
                        const startTime = this.halfDayStartTime; 
                        const endTime =  this.halfDayEndTime;

                        if(currentHour >= startTime  && currentHour < endTime ) {
                                this.isHalfDayAttendanceDisable = false;

                        }
                        else{
                            this.isHalfDayAttendanceDisable = true;
                        }
                    }
                    else{
                        this.isHalfDayAttendanceDisable = true;
                    }

                    if(this.compOfCheck){
                    this.iscompOfCheckDisable = true;
                   }

                    else if(!this.checkBusinessDay){
                    this.iscompOfCheckDisable = false;

                        
                    }
                    else{
                        this.iscompOfCheckDisable = true;


                    }
            
        });
        
    }

    attendancehandleClick(){

        markAttendance({}).then(result => {
            if(result){
               this.isAttendanceButtonDisable = true;
                const showSuccess = new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Mark Attendance successfully.',
                    variant: 'Success',
                });
                this.dispatchEvent(showSuccess);
            }else{
                this.isAttendanceButtonDisable = false;

            }

        }).catch(error => {
            console.log("Error Occured");
        })

    }

    halfdayattendancehandleClick(){

        markHalfDayAttendance({}).then(result => {
            if(result){
                this.isHalfDayAttendanceDisable = true;
                const showSuccess = new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Mark Half Day Attendance successfully.',
                    variant: 'Success',
                });
                this.dispatchEvent(showSuccess);
            }else{
                this.isHalfDayAttendanceDisable = false;

            }

        }).catch(error => {
            console.log("Error Occured");
        })

    }

     comofhandleClick(){

         this.isShowModal= true;
         this.showFormType = 'Comp-off Request';
    }

    closeModel(event) {
        if (event.detail.message) {
            this.isShowModal = false;
            this.isShowSkillModal = false;

        }
    }
    hidemodal(event) {
        if (event.detail.message) {
            this.isShowModal = false;
            this.isShowSkillModal = false;
            this.iscompOfCheckDisable = true;

        }
    }

    hideModalBox(){
        this.isShowModal = false;
        this.isShowSkillModal = false;

    }

    skillHandleClick(){
        this.isShowSkillModal = true;
        this.showFormType = 'Add Skills';
    }
}