/**
* @description : QueueableGoogleCalendarCallout is used by GoogleCalendarIntegration // Include the detailed knowledge of class.
* @author : Aakash Mathur - HRMS
* @date  : 12th Oct 2023
* @modified by: Aakash Mathur 
* @modified date: 25th Nov 2023
*/
public class QueueableGoogleCalendarCallout implements Queueable,Database.AllowsCallouts  {
    String eventId;
    String recordId;
   
    /**
    * @description this method used as Constructor
    * @param : String recordId String eventId  - contains Id of event record Id of the event 
    * @return : NA
    */  
    public QueueableGoogleCalendarCallout(String eventId ,String recordId ){
        this.eventId = eventId;
        this.recordId = recordId;
    }
    
    /**
    * @method execute() 
    * @param {QueueableContext}
    * @description :This method is responsible for executing the Queueable
    * @return : NA
    */    
    public void execute(QueueableContext context ) {
        SchemaUtility.checkRecursive = false;
        Event event = new Event();
        event.Id = recordId;
        event.Event_Id__c = eventId;
        update event; // // This not the right way of making DML without Null check.
        SchemaUtility.checkRecursive = false;
    } 
}