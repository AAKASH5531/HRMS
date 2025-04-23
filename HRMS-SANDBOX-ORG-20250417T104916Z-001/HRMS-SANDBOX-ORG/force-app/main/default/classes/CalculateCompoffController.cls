/**
* @description : The handler is used by the CalculateCompoffController
* @group : CalculateCompoffController
* @author : Rishabh Singh - HRMS
* @date  : 16th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 16th Nov 2023
*/
public class CalculateCompoffController implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
    Set<String> emailIdList = new Set<String>();
    List<String> toAdd = new List<String>();
    
    /**
    * @description : Start method is identifies the scope (list of data to be processed) and automatically called at the beginning of the apex job. This method will collect record or objects on which the operation should be performed.
    * @param : NA
    * @author : Rishabh Singh - HRMS
    * @return : NA
    */
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query ='SELECT Id, Name, Employee_Name__c, Employee_Name__r.Personal_Email_ID__c, Comp_Off_Validity_date__c, Comp_Off_Leave_Status__c, Date_Of_Comp_off_Request__c FROM Comp_Off_Request__c Where Comp_Off_Leave_Status__c =\'Valid\' AND Update_Approval_Status__c =\'Approved\'';
        return database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Comp_Off_Request__c> CompOffRequestList) {
        Map<String,Integer> MapOfEmpId = new Map<String,Integer>();
        Date currentDate = Date.today();   
        List<Comp_Off_Request__c> compList = new List<Comp_Off_Request__c>();
        for(Comp_Off_Request__c compOffRequest : CompOffRequestList)
        {   
            Integer count = 0;
            if(MapOfEmpId.containsKey(compOffRequest.Employee_Name__c)){
                count = MapOfEmpId.get(compOffRequest.Employee_Name__c);
            }
            count = count + 1;
            MapOfEmpId.put(compOffRequest.Employee_Name__c,count);  
            Date afterOneMonthApplyDate = compOffRequest.Date_Of_Comp_off_Request__c + 30;
            if(compOffRequest.Comp_Off_Leave_Status__c == 'Valid' && afterOneMonthApplyDate < currentDate){
                Comp_Off_Request__c compObj = new Comp_Off_Request__c();
                compObj.Id = compOffRequest.Id;
                compObj.Comp_Off_Leave_Status__c = 'Invalid';
                compList.add(compObj);
            }
            Date getTenDaysBeforeApplyDate = compOffRequest.Date_Of_Comp_off_Request__c + 20;
            if(getTenDaysBeforeApplyDate == currentDate){
                emailIdList.add(compOffRequest.Employee_Name__c);
                toAdd.add(compOffRequest.Employee_Name__r.Personal_Email_ID__c);
            }    
        }
        
        if(!compList.iSEmpty()){
            update compList;
        }
        
        List<Employee__c> employeeList = [SELECT Id,Total_Comp_Off__c FROM Employee__c Where Id IN : MapOfEmpId.keySet()];
        List<Employee__c> employeeListUpdate = new  List<Employee__c>();
        
        for(Employee__c  empObj : employeeList){
            Employee__c employeeObj = new Employee__c();
            employeeObj.Id =empObj.Id;
            employeeObj.Total_Comp_Off__c = MapOfEmpId.get(empObj.Id);
            employeeListUpdate.add(employeeObj);
            
        }
        
        if(!employeeListUpdate.isEmpty()){
            update employeeListUpdate;
        }
    }   
    
    public void finish(Database.BatchableContext BC) {
        if(!toAdd.isEmpty()){
            List<Messaging.Email> emailList= new List<Messaging.Email>();     
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAdd);
            mail.setSubject('Batch job complated');
            mail.setPlainTextBody('Hey,the batch job that you Started is succesfully Completed');
            emailList.add(mail);
            Messaging.sendEmail(emailList);
        }
    }

    /**
    * @description : this method  is responsebal to schedule the  the EmployeeBatch
    * @param : {SchedulableContext} 
    * @return : NA
    */ 
    public void execute(SchedulableContext sc) {
            CalculateCompoffController batchJob = new CalculateCompoffController();
            Id batchJobId = Database.executeBatch(batchJob, 200);
           }
}