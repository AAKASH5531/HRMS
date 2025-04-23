/**
* @description : The handler is used by the EmployeeTrigger
* @created By: Ankita Dhamgaya
* @created Date: 03 November 2023
*/
public with sharing class EmployeeAfterUpdateHandler extends TriggerHandlerBase{
    List<Employee__c> newRecords;
    Map<Id, Employee__c> oldMapRecord; 
    public EmployeeAfterUpdateHandler() {

    }

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('EmployeeAfterUpdateHandler qualifyStartingRecords');
        newRecords = (List<Employee__c>) newList;
        oldMapRecord = (Map<Id, Employee__c>) oldMap;
    }

    public override void start() {
        Set<Id> setOfEmployeeId = new Set<Id>();
        for(Employee__c employeeRecord : newRecords){
            if(employeeRecord.Employee_Activity_Status__c == 'On Notice' && employeeRecord.Employee_Activity_Status__c != oldMapRecord.get(employeeRecord.Id).Employee_Activity_Status__c ){
                setOfEmployeeId.add(employeeRecord.Id);
            }
        }
        updateLeavesAllocatedrecord(setOfEmployeeId);

    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }


    private Static void updateLeavesAllocatedrecord(Set<Id> setOfEmployeeId){
        List<Employee__c> employeeList = [SELECT Id, Name, Date_of_Relieving__c FROM Employee__c WHERE Id IN : setOfEmployeeId];
        List<Attendance__c> attendanceList = [SELECT Id, Attendance_Type__c, Attendance_Sub_Type__c, Attendance_Marked_Date__c
                                              FROM  Attendance__c WHERE Attendance_Type__c = 'AB' AND  Attendance_Sub_Type__c = 'SL'
                                              AND Attendance_Marked_Date__c = THIS_YEAR AND Employee__c IN : setOfEmployeeId];
        decimal count = 0;
        if(!attendanceList.isEmpty()){
            for(Attendance__c attendance : attendanceList ){
                count ++;
            }
            System.debug('count'+count);

        }
        for(Employee__c empRecord : employeeList ){
            decimal dateOfRelievingMonth = empRecord.Date_of_Relieving__c.month();
            System.debug('month'+dateOfRelievingMonth);
            decimal  roundMonth = (12.0 - dateOfRelievingMonth);
                system.debug('roundMonth'+roundMonth);
                 decimal roundYear = 5/12.0;
                 system.debug('roundYear'+roundYear);
                 decimal round = roundMonth *roundYear -5;
                 System.debug('round'+round);
                Decimal rounded = round.setScale(1, RoundingMode.HALF_UP);
                System.debug('rounded'+rounded);
        }


    }
}