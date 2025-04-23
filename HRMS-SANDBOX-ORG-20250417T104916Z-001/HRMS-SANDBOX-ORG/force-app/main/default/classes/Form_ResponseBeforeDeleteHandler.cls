/**
* @description : The Form_ResponseBeforeDeleteHandler is used by the FormResponseTrigger
* @group : FormResponseTrigger
* @author : Rishabh Singh - HRMS
* @created date : 30th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 01th Dec 2023
*/

public with sharing class Form_ResponseBeforeDeleteHandler extends TriggerHandlerBase{

    public Form_ResponseBeforeDeleteHandler() {

    }

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('Form_ResponseBeforeDeleteHandler qualifyStartingRecords');
    }

    public override void start() {

    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    } 
}