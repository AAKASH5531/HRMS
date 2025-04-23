/**
* @description : The handler is used by the CalculateCompoffController
* @group : CalculateCompoffController
* @author : Rishabh Singh - HRMS
* @date  : 16th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 16th Nov 2023
*/
public class LeaveAllocatedBatch implements Database.Batchable<sObject>, Database.Stateful,Schedulable {
    
    /**
    * @description : Start method is identifies the scope (list of data to be processed) and automatically called at the beginning of the apex job. This method will collect record or objects on which the operation should be performed.
    * @param : NA
    * @author : Rishabh Singh - HRMS
    * @return : NA
    */
    public Database.QueryLocator start(Database.BatchableContext BC) {
       String query =' SELECT Id, Name, Designation__c, Employee_Activity_Status__c FROM Employee__c WHERE NOT toLabel(Designation__c) LIKE  \'%Trainee%\'';
           
         system.debug('query' +query);
        return database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Employee__c> EmployeeList) {
        system.debug('EmployeeList' +EmployeeList);
        List<Leaves_Allocated__c> leavesAllocatedList = new List<Leaves_Allocated__c>();
        for(Employee__c employeeRecord :EmployeeList ){
            if(employeeRecord.Employee_Activity_Status__c == 'Active'){
                Leaves_Allocated__c leavesAllocated = new Leaves_Allocated__c();
                leavesAllocated.Leave_Type__c = 'PL';
                leavesAllocated.Count_Of_Leave__c = 1;
                leavesAllocated.Employee__c =employeeRecord.Id;
                leavesAllocatedList.add(leavesAllocated);
            }
        }
        if(!leavesAllocatedList.isEmpty()){
            insert leavesAllocatedList;
            System.debug('leavesAllocatedList'+leavesAllocatedList);
        }
       
    }   
    
    public void finish(Database.BatchableContext BC) {
           
    }
    

    /**
    * @description : this method  is responsebal to schedule the  the EmployeeBatch
    * @param : {SchedulableContext} 
    * @return : NA
    */ 
    public void execute(SchedulableContext sc) {
        LeaveAllocatedBatch batchJob = new LeaveAllocatedBatch();
        Id batchJobId = Database.executeBatch(batchJob, 200);
    }
}