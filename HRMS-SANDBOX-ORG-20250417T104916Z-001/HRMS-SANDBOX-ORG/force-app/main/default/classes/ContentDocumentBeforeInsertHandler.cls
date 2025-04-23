/**
* @description : The handler is used by the ContentDocumentTrigger
* @group : ContentDocumentTrigger
* @author : Aakash Mathur - HRMS
*Created On: 03 November 2023
* @modified by:Aakash Mathur 
* @modified date: 15th Nov 2023
*/
public with sharing class ContentDocumentBeforeInsertHandler extends TriggerHandlerBase{
    public ContentDocumentBeforeInsertHandler() {

    }

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('ContentDocumentBeforeInsertHandler qualifyStartingRecords');
    }

    public override void start() {

    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }
}