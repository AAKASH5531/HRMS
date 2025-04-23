/**
* @description : The handler is used by the EmployeeTrigger
* @group : EmployeeTrigger
* @author : Rishabh Singh - HRMS
* @created date : 03th Oct 2023
* @modified by: Rishabh Singh
* @modified date: 25th Nov 2023
*/
public with sharing class EmployeeAfterInsertHandler extends TriggerHandlerBase{
    List<Employee__c> newRecords;
    List<Employee_Document__c> employeeDocument;
    List<Leaves_Allocated__c> leavesAllocatedList;

    public EmployeeAfterInsertHandler() {
        employeeDocument = new List<Employee_Document__c>();
        leavesAllocatedList = new List<Leaves_Allocated__c>();
    }

    /**
    * @description : The method is executed from EmployeeTrigger only on AfterInsert of the Employee object.
    * @param : List<SObject> newList - Contains Employee object mapping from Trigger.new
    * @return : NA
    */
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        Diagnostics.push('EmployeeAfterInsertHandler qualifyStartingRecords');
        newRecords = (List<Employee__c>) newList;
        
    }
    
	/**
    * @description : The method is executed from EmployeeTrigger only in the EmployeeAfterInsertHandler.
    * @param : NA
    * @return : NA
    */
    public override void start() {
        employeeDocument = createEmployeeDocument(newRecords);
        leavesAllocatedList = createLeavesAllocated(newRecords);
    }
    
	/**
    * @description : The method is executed from EmployeeTrigger only during the insertion of an employeeDocument.
    * @param : Boolean - Contains fromStart from TriggerHandlerBase
    * @return : NA
    */
    public override void finish(Boolean fromStart) {
        if(fromStart) {
            if(employeeDocument.size()>0){
                insert employeeDocument;
            }
            if(!leavesAllocatedList.isEmpty()){
                insert leavesAllocatedList;
            }
        }
        Diagnostics.pop();
    }
    
    /**
    * @description : The method is executed from EmployeeTrigger only to create an Employee Document record.
    * @param : List<SObject> newList - Contains Employee object mapping from Trigger.new
    * @return : List<Employee_Document__c>
    */
    @testVisible
    private static List<Employee_Document__c> createEmployeeDocument(List<Employee__c> empList){
        try{
            List<Employee_Document__c> employeeDocument = new List<Employee_Document__c>();
            if(empList.size()>0){
                for(EmployeeDocument__mdt getFieldDetails : [SELECT Document_Label__c FROM EmployeeDocument__mdt WHERE Document_Label__c != null]){
                    Employee_Document__c empDocument = new Employee_Document__c();
                    empDocument.Name = getFieldDetails.Document_Label__c;
                    empDocument.Employee__c = empList[0].Id;
                    employeeDocument.add(empDocument);
                }
            }
            return employeeDocument;
        } catch (Exception ex) {
            system.debug('An unexpected exception occurred: ' + ex.getMessage());
            return null; 
        }
    }
    
    private static List<Leaves_Allocated__c> createLeavesAllocated(List<Employee__c> empList){
        List<Leaves_Allocated__c> leavesAllocatedList = new List<Leaves_Allocated__c>();
        List<Employee__c> employeeList = [SELECT Id, Name, Date_of_Joining__c FROM Employee__c WHERE Id IN : empList];
        for(Employee__c empRecord : employeeList ){
            decimal dateOfJoiningMonth = empRecord.Date_of_Joining__c.month();
            System.debug('month'+dateOfJoiningMonth);
            Leaves_Allocated__c leavesAllocated = new Leaves_Allocated__c();
            if((dateOfJoiningMonth == 1 || dateOfJoiningMonth == 2 || dateOfJoiningMonth == 3 || dateOfJoiningMonth == 4 || dateOfJoiningMonth == 5 || dateOfJoiningMonth == 6)){
                // leavesAllocated.Leave_Type__c = 'SL';
                // leavesAllocated.Count_Of_Leave__c = 5;
                // leavesAllocated.Employee__c = empRecord.Id;
                // leavesAllocatedList.add(leavesAllocated);
                leavesAllocatedList = createLeavesAllocatedrecord(5, empRecord.Id);

            }
            else if((dateOfJoiningMonth == 7 || dateOfJoiningMonth == 8 || dateOfJoiningMonth == 9 || dateOfJoiningMonth == 10 || dateOfJoiningMonth == 11  || dateOfJoiningMonth == 12)){
                decimal  roundMonth = (12.0 - dateOfJoiningMonth);
                system.debug('roundMonth'+roundMonth);
                 decimal roundYear = 5/12.0;
                 system.debug('roundYear'+roundYear);
                 decimal round = roundMonth *roundYear;
                 System.debug('round'+round);
                Decimal rounded = round.setScale(1, RoundingMode.HALF_UP);
                System.debug('rounded'+rounded);
                if(rounded == 2.1){
                // leavesAllocated.Leave_Type__c = 'SL';
                // leavesAllocated.Count_Of_Leave__c = 2;
                // leavesAllocated.Employee__c =empRecord.Id;
                // leavesAllocatedList.add(leavesAllocated); 
                leavesAllocatedList = createLeavesAllocatedrecord(2, empRecord.Id);

                }
                else if(rounded == 1.7 && rounded == 1.3){
                // leavesAllocated.Leave_Type__c = 'SL';
                // leavesAllocated.Count_Of_Leave__c = 1.5;
                // leavesAllocated.Employee__c =empRecord.Id;
                // leavesAllocatedList.add(leavesAllocated);
                leavesAllocatedList = createLeavesAllocatedrecord(1.5, empRecord.Id);

                }
                else if(rounded == 0.8){
                // leavesAllocated.Leave_Type__c = 'SL';
                // leavesAllocated.Count_Of_Leave__c = 1;
                // leavesAllocated.Employee__c =empRecord.Id;
                // leavesAllocatedList.add(leavesAllocated);
                leavesAllocatedList = createLeavesAllocatedrecord(1, empRecord.Id);

                }
                else if(rounded == 0.4){
                // leavesAllocated.Leave_Type__c = 'SL';
                // leavesAllocated.Count_Of_Leave__c = 0.5;
                // leavesAllocated.Employee__c =empRecord.Id;
                // leavesAllocatedList.add(leavesAllocated); 
                leavesAllocatedList = createLeavesAllocatedrecord(0.5, empRecord.Id);

                }
            	else if(rounded == 0.0){
                // leavesAllocated.Leave_Type__c = 'SL';
                // leavesAllocated.Count_Of_Leave__c = 0;
                // leavesAllocated.Employee__c =empRecord.Id;
                // leavesAllocatedList.add(leavesAllocated); 
                leavesAllocatedList = createLeavesAllocatedrecord(0, empRecord.Id);

                }
           }
        }
        return leavesAllocatedList;
    }

    private Static List<Leaves_Allocated__c> createLeavesAllocatedrecord(Decimal countOfLeave, String empRecordId ){
        List<Leaves_Allocated__c> leavesAllocatedList = new List<Leaves_Allocated__c>();
        Leaves_Allocated__c leavesAllocated = new Leaves_Allocated__c();
        leavesAllocated.Leave_Type__c = 'SL';
        leavesAllocated.Count_Of_Leave__c = countOfLeave;
        leavesAllocated.Employee__c = empRecordId;
        leavesAllocatedList.add(leavesAllocated);
        return leavesAllocatedList;
    }
    
}