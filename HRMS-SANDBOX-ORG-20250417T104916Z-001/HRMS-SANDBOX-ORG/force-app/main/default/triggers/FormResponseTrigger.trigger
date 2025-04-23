/**
* @description : The ResponseTrigger is used by the Response insert
* @group : ResponseTrigger
* @author : Rishabh Sahani - HRMS
* @created Date  : 30th Oct 2023
* @modified by: Rishabh Sahani
* @modified date: 03th Nov 2023
*/
trigger FormResponseTrigger on Form_Response__c ( after update) {

    system.debug('fired');
    if(Util.isSkipTrigger() || util.gethealthyTestSwitch()) return;

    Diagnostics.push('FormResponseTrigger fired');

    TriggerDispatcher.execute(Form_Response__c.sObjectType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);

    Diagnostics.pop();
}