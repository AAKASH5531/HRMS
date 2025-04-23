/**
* @description : The TaskBeforeInsertHandler is used by the TaskTrigger  // Include the detailed knowledge of all the trigger Framework based class like use of methods and other details. 
* @group : TaskTrigger
* @author : Akash Sahani - HRMS
* @created date : 30th Oct 2023
* @modified by: Akash Sahani
* @modified date: 25th Nov 2023
*/
public with sharing class TaskBeforeInsertHandler extends TriggerHandlerBase{
    List<Task> newRecords;
    List<Task> task;
    public TaskBeforeInsertHandler() {
        task = new List<Task>();
    }

    /**
    * @description : The method is executed from TaskTrigger only on BeforeInsert of the Task object.
    * @param : List<SObject> newList - Contains Task object mapping from Trigger.new
    * @return : NA
    */
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('TaskBeforeInsertHandler qualifyStartingRecords');
        newRecords = (List<Task>) newList;
    }

    /**
    * @description : The method is executed from TaskTrigger only in the TaskBeforeInsertHandler. 
    * @param : NA
    * @return : NA
    */
    public override void start() {
		task = fillBusinessDayFieldsBeforeInsert(newRecords);
    }


    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    } 
    
    /**
    * @description : The method is executed from TaskTrigger and returns a list of tasks with calculated business days.
    * @param : {List<Task>} taskList - new List of Task
    * @return : list of task - (List<Task>)
    */
    private static List<Task> fillBusinessDayFieldsBeforeInsert(List<Task> taskList){
        try{
            Date threeBusinessDay = CalculateBusinessDayWithHoliday.getBusinessDay(null,3); // I don't think these two lines [48, 49] need to put under the try block.
            Date sevenBusinessDay = CalculateBusinessDayWithHoliday.getBusinessDay(null,7);
            for(Task task : taskList){ // Without NULL check on the param don't use it blindly this is not the right way.
                if(task.Subject == 'Medical Addition'){
                    task.After_Three_Bussines_Day__c = threeBusinessDay;
                    task.After_Seven_Business_day__c = sevenBusinessDay;
                }
            }
            return taskList;
        } catch (Exception ex) {
            system.debug('An unexpected exception occurred: ' + ex.getMessage());
            return null; 
        }
    } 
}