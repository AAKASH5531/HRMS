/**
* @description : The handler is used by the ContentDocumentTrigger
* @group : ContentDocumentTrigger
* @author : Aakash Mathur - HRMS
* @created On : 10 November 2023
* @modified by : Aakash Mathur 
* @modified date : 25th Nov 2023
*/
public with sharing class ContentDocumentBeforeUpdateHandler extends TriggerHandlerBase{
    public ContentDocumentBeforeUpdateHandler() {
    }

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('ContentDocumentBeforeUpdateHandler qualifyStartingRecords');
    }

    public override void start() {

    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }
}