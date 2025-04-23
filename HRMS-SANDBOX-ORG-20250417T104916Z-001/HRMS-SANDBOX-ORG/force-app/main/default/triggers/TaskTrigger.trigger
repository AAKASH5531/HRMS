/**
* @description : The TaskTrigger is used by the Task insert
* @group : TaskTrigger
* @author : Akash Sahani - HRMS
* @created Date  : 30th Oct 2023
* @modified by: Akash Sahani
* @modified date: 03th Nov 2023
*/

trigger TaskTrigger on Task (before insert) {

    if(Util.isSkipTrigger('TaskTriggerHandler', null) || util.gethealthyTestSwitch()) return;

    Diagnostics.push('TaskTrigger fired');

    TriggerDispatcher.execute(Task.sObjectType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
    Diagnostics.pop();
    
}