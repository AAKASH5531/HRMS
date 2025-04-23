/**
* @description : The TaskAfterUpdateHandler is used by the TaskTrigger
* @group : TaskTrigger
* @author : Akash Sahani - HRMS
* @created date : 03th Nov 2023
* @modified by: Akash Sahani
* @modified date: 03th Nov 2023
*/

public with sharing class TaskAfterUpdateHandler extends TriggerHandlerBase{

    public TaskAfterUpdateHandler() {

    }

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('TaskAfterUpdateHandler qualifyStartingRecords');
    }

    public override void start() {

    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    } 
}