/**
* @description : The EventTrigger is used by the EventTriggerHandler
* @group : EmployeeTrigger
* @author : Aakash Mathur - HRMS
* @date  : 03th Oct 2023
* @modified by: Aakash Mathur 
* @modified date: 03th Nov 2023
*/
trigger EventTrigger on Event (before update, before insert, after insert, after update, before delete) {
    if(Util.isSkipTrigger('Event', null) || util.gethealthyTestSwitch()) 
    return;
    Diagnostics.push('Event trigger fired');
    TriggerDispatcher.execute(Event.sObjectType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
    Diagnostics.pop();
}