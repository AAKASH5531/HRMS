/**
* @description : The handler is used by the EmployeeTrigger
* @created By: Ankita Dhamgaya
* @created Date: 03 November 2023
*/
public with sharing class EmployeeAfterDeleteHandler extends TriggerHandlerBase{
    public EmployeeAfterDeleteHandler() {

    }

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('EmployeeAfterDeleteHandler qualifyStartingRecords');
    }

    public override void start() {

    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }
}