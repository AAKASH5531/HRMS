/**
* @description : EmployeeBatch is responsibale to check that employee  100 % Consumed or not
* @group : EmployeeBatch
* @author :Aakash Mathur - HRMS
* @date  : 20th Nov 2023
* @modified by: Aakash Mathur
* @modified date: 20th Nov 2023
*/
public class EmployeeBatch implements Database.Batchable<sObject>, Database.Stateful,Schedulable {
    private List<String> directors;
    public EmployeeBatch() {
        directors = new List<String>();
        List<User> userList = [SELECT Email FROM User WHERE UserRole.Name = 'Director'];
        if(userList.size() > 0){
           for (User u : userList) {
            directors.add(u.Email);
            } 
        }     
    } 
    
   /**
    * @description : Start method is identifies the scope (list of data to be processed) and automatically called at the beginning of the apex job. This method will collect record or objects on which the operation should be performed.
    * @param : Database.BatchableContext
    * @return : Database.QueryLocator
    */
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,Name, Employee_Manager__c, Employee_Manager__r.Personal_Email_ID__c , Snooze_Project_task_allocation_for_W__c,Total_Percentage_Consume__c FROM Employee__c Where Total_Percentage_Consume__c < 100 AND createddate = today';
        return Database.getQueryLocator(query);
    }
    
    /**
    * @description : this method executes the batch logic for each employee.
    * @param : {Database.BatchableContext} 
    * @param : {List<Employee__c>}
    * @return : NA
    */   
    public void execute(Database.BatchableContext bc, List<Employee__c> employees) {
        try{ 
            List<Task> taskList = new List<Task>();
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            List<Employee__c> employeesToUpdate = new List<Employee__c>();
            Date nextWorkingDate = CalculateBusinessDayWithHoliday.getBusinessday(null, 1);
            for (Employee__c empRec : employees) {
                if (!empRec.Snooze_Project_task_allocation_for_W__c) {
                    Task taskRec = new Task();
                    taskRec.OwnerId = empRec.Id;
                    taskRec.Subject = 'Contact your manager and get a project task';
                    taskRec.ActivityDate = nextWorkingDate;
                    taskList.add(taskRec);
                    empRec.Snooze_Project_task_allocation_for_W__c = true;
                    employeesToUpdate.add(empRec);
                    if(empRec.Employee_Manager__r.Personal_Email_ID__c != null){
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setSubject('Employee occupancy alert');
                        email.setPlainTextBody('Hello ' + empRec.Employee_Manager__c + ',\n\n' + 'This is an automated email to inform you that your employee ' + empRec.Name + ' is occupied less than 100%. Please assign them a project task as soon as possible.\n\n' + 'Thank you.');
                        email.setToAddresses(new List<String>{empRec.Employee_Manager__r.Personal_Email_ID__c});
                        email.setCcAddresses(directors);
                        emails.add(email);
                    }
                }
            }
            Messaging.sendEmail(emails);
            Database.insert(taskList, false);
            Database.update(employeesToUpdate, false);
        }
        catch(Exception e){
            System.debug('Error--'+e.getMessage());
        }
    }
    public void finish(Database.BatchableContext bc) {
    }
    
    /**
    * @description : this method  is responsebal to schedule the  the EmployeeBatch
    * @param : {SchedulableContext} 
    * @return : NA
    */ 
    public void execute(SchedulableContext sc) {
            EmployeeBatch batchJob = new EmployeeBatch();
 			Id batchJobId = Database.executeBatch(batchJob, 200);
           }
}