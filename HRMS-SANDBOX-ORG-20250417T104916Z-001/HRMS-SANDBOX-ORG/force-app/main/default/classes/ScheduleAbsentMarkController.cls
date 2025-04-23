/**
* @description : The handler is used by the flow Mark_Half_Day_Attendance // Include the detailed knowledge of class 	
* @group : Mark_Half_Day_Attendance
* @author : Rishabh Singh - HRMS
* @date  : 03th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 06th Nov 2023
*/
public class ScheduleAbsentMarkController {
    
    public class absentWrapper{
        @InvocableVariable public List<Id> recordIds;
    }
    
    /**
    * @description : Method will execute from flow Mark_Half_Day_Attendance
    * @param : List<absentWrapper> employeeIdList
    * @return : NA
    */
    @InvocableMethod(label='AbsentUpdate' description='Method will update the Employee Absent status')
    public static void getEmployeeRecord(List<absentWrapper> employeeIdList ){
        try{ // Put only those line of code into try block which can occur error at runtime. 
            Set<Id> EmpRecord = new Set<Id>();
            Map<Id,Boolean> employeeIdAttendenceMap = new Map<Id,Boolean>();
            for(absentWrapper employeeId : employeeIdList){
                for(Id empId :employeeId.recordIds){
                    employeeIdAttendenceMap.put(empId, false);
                    EmpRecord.add(empId); 
                }
            }
            List<Attendance__c> attendenceRecord = [SELECT Id,Employee__c, Attendance_Marked_Date__c 
                                                    FROM Attendance__c WHERE Employee__c IN:EmpRecord 
                                                    AND Attendance_Marked_Date__c =: Date.today()];
            for(Attendance__c attd : attendenceRecord){
                if(employeeIdAttendenceMap.containsKey(attd.Employee__c)){
                    employeeIdAttendenceMap.put(attd.Employee__c, true);
                }
            }
            createAttendanceRecord(employeeIdAttendenceMap);
            }catch (Exception ex) {
            system.debug('An unexpected exception occurred: ' + ex.getMessage());
        }
    }
	
    /**
    * @description : Method will execute from ScheduleAbsentMarkController // It should be more clear what is doing this method.
    * @param : Map<Id,Boolean> employeeIdAttendenceMap
    * @return : NA
    */
    private Static void createAttendanceRecord( Map<Id, Boolean> employeeIdAttendenceMap){
            Set<Id> empRecordId = new Set<Id>();
            List<Attendance__c> absentRecord = new List<Attendance__c>();
            for(Id empId : employeeIdAttendenceMap.KeySet()){
                if(!employeeIdAttendenceMap.get(empId)){
                    empRecordId.add(empId);
                    Attendance__c attRecord = new Attendance__c();
                    attRecord.Employee__c = empId;
                    attRecord.Attendance_Type__c = 'AB';
                    attRecord.Attendance_Sub_Type__c = 'AB';
                    attRecord.Attendance_Marked_Date__c = Date.today();
                    absentRecord.add(attRecord);
                }
            }
            if(!absentRecord.isEmpty()){
                insert absentRecord;
            }
            createFlagRecord(empRecordId);
    }
    
    /**
    * @description : Method will execute from ScheduleAbsentMarkController //It should be more clear what is doing this method.
    * @param : Map<Id,Boolean> employeeIdAttendenceMap
    * @return : NA
    */
    private Static void createFlagRecord(Set<Id> empRecordId){
            List<Flag__c> flagList = new List<Flag__c>();
            List<Employee__c> listOfEmployee = [SELECT Id, EMPLOYEE_ID__c FROM Employee__c WHERE Id IN : empRecordId];
            for(Employee__c emp : listOfEmployee){
                Flag__c flag = new Flag__c();
                flag.Employee__c = emp.Id;
                flag.Name = emp.EMPLOYEE_ID__c;
                flag.Date_Of_Flag__c = Date.today();
                flagList.add(flag);
            }
            if(flagList.size()>0){
                insert flagList;
            }
    }
    
}