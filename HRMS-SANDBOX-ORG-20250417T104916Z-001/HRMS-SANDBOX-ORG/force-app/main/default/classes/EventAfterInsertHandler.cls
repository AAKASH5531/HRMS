/**
* @description : The handler is used by the EventTrigger // I thought you also need to include it is  written on the basis of Trigger Framework.
                                                         // Also explain each method use in brief so that who came here try to understand all the things
* @group : EventTrigger
* @author : Aakash Mathur - HRMS
* @created On: 03 November 2023
* @modified by : Aakash Mathur 
* @modified date: 25th Nov 2023
*/
public with sharing class EventAfterInsertHandler extends TriggerHandlerBase{
    List<Event> newRecords;
    List<Event> eventList;
    public EventAfterInsertHandler() {
    List<Event> eventList = new List<Event>();
    }

    /**
    * @description : Method will execute from EventTrigger only on After Update of Event Object
    * @author : Aakash Mathur - HRMS 
    * @param : List<SObject> newList - Contains Event object mapping from Trigger.new
    * @return : NA
    */
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('EventAfterInsertHandler qualifyStartingRecords');
        newRecords = (List<Event>) newList;
    }

    public override void start() {
       eventList = EventTriggerHelperUtility.eventOnGoogleCalendar(newRecords, false);
    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }
}