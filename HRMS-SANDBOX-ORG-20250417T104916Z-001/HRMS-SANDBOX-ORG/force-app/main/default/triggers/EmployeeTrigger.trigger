/**
* @description : The EmployeeTrigger is used by the EmployeeAfterInsertHandler
* @group : EmployeeTrigger
* @author : Rishabh Singh - HRMS
* @date  : 03th Oct 2023
* @modified by: Rishabh Singh
* @modified date: 04th Nov 2023
*/
trigger EmployeeTrigger on Employee__c (before update, before insert, after insert, after update, before delete) {
    if(Util.isSkipTrigger() || util.gethealthyTestSwitch()){
        return;
    } 
    Diagnostics.push('EmployeeTrigger fired');

    TriggerDispatcher.execute(Employee__c.sObjectType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);

    Diagnostics.pop();
}