/**
* @description : The handler is used by the lightning web components markAttendance  // Add brief description about the class what is the use of this class.
* @group : markAttendance
* @author : Rishabh Singh - HRMS
* @date  : 02th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 07th Nov 2023
*/
public class MarkAttendanceController {

    /**
    * @description : Method will execute from markAttendance only create a attendance object persant record
    * @param : NA
    * @return : Boolean - true or false // Detailed explanation need to add here.
    */
    
    //markAttendance() and markHalfDayAttendance() are using the same code logic so for that reason need to combined it in a single method. 
    
    @AuraEnabled
    public static Boolean markAttendance() {
        List<Employee__c> employeeList = [SELECT Id From Employee__c WHERE User_Associated__c =: UserInfo.getUserId()];
            Attendance__c attendance = new Attendance__c();
            attendance.Attendance_Type__c = 'P';
            if(!employeeList.isEmpty()){
                attendance.Employee__c = employeeList[0].Id;
            }
            attendance.Attendance_Marked_Date__c = Date.today();
        try {
            if(attendance !=null) {
                insert attendance;
            }
        }catch(Exception ex){
                throw new AuraHandledException(ex.getMessage());
            } 
        if(attendance.Id != null){
            return true;
        }else{
            return false;
        }
        
    }

    /**
    * @description : Method will execute from markAttendance only create a attendance object halfDay record
    * @param : NA
    * @return : Boolean - true or false
    */
    @AuraEnabled
    public static Boolean markHalfDayAttendance(){
        List<Employee__c> employeeList = [SELECT Id From Employee__c WHERE User_Associated__c =: UserInfo.getUserId()];
        Attendance__c attendance = new Attendance__c();
        attendance.Attendance_Type__c = 'HD';
        if(!employeeList.isEmpty()){
            attendance.Employee__c = employeeList[0].Id;
        }
        attendance.Attendance_Marked_Date__c = Date.today();
        try {
            if(attendance != null) {
                insert attendance;
            }
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        } 
        if(attendance.Id != null){

            return true;
        }else{
            return false;
        }

    }
    
    /**
    * @description : Method will execute from markAttendance only check the mutiple valdation
    * @param : NA
    * @return : List<AttendanceManagement> attendanceManagementList // Need to add bit more explanation.
    */   
    @AuraEnabled
    public Static  List<AttendanceManagement> checkAttendance(){
        try{
            List<AttendanceManagement> attendanceManagementList = new List<AttendanceManagement>();
            List<Attendance__c> attendanceList = [SELECT Id , Attendance_Marked_Date__c, Employee__r.User_Associated__c 
                                                            FROM Attendance__c WHERE Employee__r.User_Associated__c =:  UserInfo.getUserId()
                                                            AND Attendance_Marked_Date__c =: date.TODAY() ];
            AttendanceManagement attendanceManagement = new AttendanceManagement();
            if(!attendanceList.isEmpty()){
            attendanceManagement.checkMarkAttendance = true;
            }else{
                attendanceManagement.checkMarkAttendance = false;
            }  

            if(CalculateBusinessDay.getBusinessday() != null){
                attendanceManagement.checkBusinessDay = true;
            }
            else{
                attendanceManagement.checkBusinessDay = false;
            }
            List<Comp_Off_Request__c> compofList = [SELECT Id , Employee_Name__r.User_Associated__c 
                                                            FROM Comp_Off_Request__c WHERE Employee_Name__r.User_Associated__c =:  UserInfo.getUserId()
                                                            AND Date_Of_Comp_off_Request__c =: date.TODAY() ];
            if(!compofList.isEmpty()){
                attendanceManagement.compOfCheck = true;
            }else{
                attendanceManagement.compOfCheck = false;
            }

            List<Attendance_Management__mdt> attendanceMdt = [SELECT Label, Mark_Attendance_Start_Time__c, 
                                                                        Mark_Attendance_End_Time__c  
                                                                        From Attendance_Management__mdt WHERE Label = 'Mark Attendance'];
            if(!attendanceMdt.isEmpty()){
                for(Attendance_Management__mdt mdtRecord : attendanceMdt ){
                    attendanceManagement.startTime = mdtRecord.Mark_Attendance_Start_Time__c;
                    attendanceManagement.endTime = mdtRecord.Mark_Attendance_End_Time__c;
                    attendanceManagementList.add(attendanceManagement);
                }
            }
            List<Attendance_Management__mdt> attendanceMdts = [SELECT Label, Mark_Attendance_Start_Time__c,
                                                                        Mark_Attendance_End_Time__c  
                                                                        From Attendance_Management__mdt WHERE Label = 'Mark Half Day Attendance'];
            if(!attendanceMdt.isEmpty()){
                for(Attendance_Management__mdt mdtRecord : attendanceMdts ){
                    attendanceManagement.halfDayStartTime = mdtRecord.Mark_Attendance_Start_Time__c;
                    attendanceManagement.halfDayEndTime = mdtRecord.Mark_Attendance_End_Time__c;
                    attendanceManagementList.add(attendanceManagement);
                }
            }
            return attendanceManagementList;
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        } 
    }


    public Class AttendanceManagement{
        @AuraEnabled  
        public Decimal startTime;
        @AuraEnabled
        public Decimal endTime;
        @AuraEnabled  
        public Decimal halfDayStartTime;
        @AuraEnabled
        public Decimal halfDayEndTime;
        @AuraEnabled
        public Boolean checkMarkAttendance;
        @AuraEnabled
        public Boolean checkBusinessDay;
        @AuraEnabled
        public Boolean compOfCheck;
    }

}