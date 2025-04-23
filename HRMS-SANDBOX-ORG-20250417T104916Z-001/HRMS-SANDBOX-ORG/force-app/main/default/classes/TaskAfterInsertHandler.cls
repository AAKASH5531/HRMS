/**
* @description : The TaskAfterInsertHandler is used by the TaskTrigger
* @group : TaskTrigger
* @author : Akash Sahani - HRMS
* @created date : 03th Nov 2023
* @modified by: Akash Sahani
* @modified date: 03th Nov 2023
*/

public with sharing class TaskAfterInsertHandler extends TriggerHandlerBase{

    public TaskAfterInsertHandler() {

    }

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('TaskAfterInsertHandler qualifyStartingRecords');
    }

    public override void start() {

    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    } 
}