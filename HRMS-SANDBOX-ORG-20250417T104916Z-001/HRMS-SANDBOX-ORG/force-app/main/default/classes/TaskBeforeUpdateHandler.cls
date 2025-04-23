/**
* @description : The Handler is used by the TaskTrigger
* @group : TaskTrigger
* @author : Akash Sahani - HRMS
* @created date : 03th Nov 2023
* @modified by: Akash Sahani
* @modified date: 03th Nov 2023
*/

public with sharing class TaskBeforeUpdateHandler extends TriggerHandlerBase{

    public TaskBeforeUpdateHandler() {

    }
    
    // Need to add the comment section for variables in to all the framework class accept this class and try to create all the records into that section.

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('TaskBeforeUpdateHandler qualifyStartingRecords');
    }

    public override void start() {

    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    } 
}