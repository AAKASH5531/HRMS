/**
* @description : The Form_ResponseBeforeUpdateHandler is used by the FormResponseTrigger
* @group : FormResponseTrigger
* @author : Rishabh Singh - HRMS
* @created date : 30th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 01th Dec 2023
*/

public with sharing class Form_ResponseBeforeUpdateHandler extends TriggerHandlerBase{

    public Form_ResponseBeforeUpdateHandler() {

    }

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('Form_ResponseBeforeUpdateHandler qualifyStartingRecords');
    }

    public override void start() {

    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    } 
}