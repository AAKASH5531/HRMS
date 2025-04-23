/**
* @description : The handler is used by the EmployeeTrigger
* @created By: Ankita Dhamgaya
* @created Date: 25 November 2023
*/
public with sharing class EmployeeBeforeDeleteHandler extends TriggerHandlerBase{
    public EmployeeBeforeDeleteHandler() {

    }

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('EmployeeBeforeDeleteHandler qualifyStartingRecords');
    }

    public override void start() {

    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }
}