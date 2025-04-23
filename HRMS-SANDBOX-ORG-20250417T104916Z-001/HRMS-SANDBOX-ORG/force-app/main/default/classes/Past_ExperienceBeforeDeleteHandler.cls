/**
* @description : The Handler is used by the PastExperienceTrigger
* @group : PastExperienceTrigger
* @created By : Ankita Dhamgaya
* @created date : 03th Nov 2023
* @modified by: Akash Sahani
* @modified date: 03th Nov 2023
*/
public with sharing class Past_ExperienceBeforeDeleteHandler extends TriggerHandlerBase{
    
    public Past_ExperienceBeforeDeleteHandler() {
    }
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('Past_ExperienceBeforeDeleteHandler qualifyStartingRecords');
    }
    
    public override void start() {
    }
    
    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }
    
}