/**
* @description : The handler is used by the EventTrigger // I thought you also need to include it is  written on the basis of Trigger Framework.
                                                         // Also explain each method use in brief so that who came here try to understand all the things
* @group : EventTrigger
* @author : Aakash Mathur - HRMS
* @Created On: 03 November 2023
* @modified by:Aakash Mathur 
* @modified date: 15th Nov 2023
*/
public with sharing class EventBeforeInsertHandler extends TriggerHandlerBase{
    public EventBeforeInsertHandler() {
        
    }
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('EventBeforeInsertHandler qualifyStartingRecords');
    }
    
    public override void start() {
        
    }
    
    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }
}