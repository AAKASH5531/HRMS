/**
* @description : The ContentDocumentTrigger is used by the ContentDocumentTriggerHelperUtility
* @group : ContentDocumentTrigger
* @author : Aakash Mathur- HRMS
* @date  : 03th Oct 2023
* @modified by: Aakash Mathur
* @modified date: 03th Nov 2023
*/

trigger ContentDocumentTrigger on ContentDocument (before update, before insert, after insert, after update, before delete) {

   if(Util.isSkipTrigger('ContentDocument', null) || util.gethealthyTestSwitch()) return;

	Diagnostics.push('ContentDocument trigger fired');

	TriggerDispatcher.execute(ContentDocument.sObjectType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);

	Diagnostics.pop();
}