/**
* @description : The PastExperienceTrigger is used by the Past Experience insert and update
* @group : PastExperienceTrigger
* @create By : Ankita Dhamgaya
* @created date: 30th Oct 2023
* @modified by: Akash Sahani
* @modified date: 25th Nov 2023
*/
trigger PastExperienceTrigger on Past_Experience__c (before update, before insert, after insert, after update, before delete, after delete) {
    
    if(Util.isSkipTrigger() || Util.gethealthyTestSwitch()){
        return;
        
    } 

	Diagnostics.push('Past_Experience trigger fired');
    

	TriggerDispatcher.execute(Past_Experience__c.sObjectType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);

	Diagnostics.pop();
}