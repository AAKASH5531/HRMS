/**
* @description : The Past_ExperienceBeforeInsertHandler is used by the PastExperienceTrigger
* @created By: Ankita Dhamgaya
* @created Date: 03 Nov 2023
* @modified by: Akash Sahani
* @modified date: 02 Dec 2023
*/
public with sharing class Past_ExperienceAfterDeleteHandler extends TriggerHandlerBase{
    List<Past_Experience__c> oldRecords;
    List<Employee__c> empListForUpdate;
    
    public Past_ExperienceAfterDeleteHandler() {
		empListForUpdate = new List<Employee__c>();
    }

    /**
    * @description : The method is executed from PastExperienceTrigger only on AfterDelete of the Past Experience object.
    * @param : List<SObject> newList - Contains Past Experience object mapping from Trigger.old
    * @return : NA
    */
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('Past_ExperienceAfterDeleteHandler qualifyStartingRecords');
        oldRecords = (List<Past_Experience__c>) oldList;
    }

    /**
    * @description : The method is executed from PastExperienceTrigger only in the Past_ExperienceAfterDeleteHandler.
    * @param : NA
    * @return : NA
    */
    public override void start() {
		empListForUpdate = removePastExperienceRecord(oldRecords);
    }

    /**
    * @description : The method is executed from PastExperienceTrigger only during the deletion of a Past Experience record.
    * @param : Boolean - Contains fromStart from TriggerHandlerBase
    * @return : NA
    */
    public override void finish(Boolean fromStart) {
        if(fromStart) {
            if(empListForUpdate.size()>0){
                update empListForUpdate;
            }
        }
        Diagnostics.pop();
    }
    
    /**
    * @description : The method is executed from PastExperienceTrigger and returns the calculated Experience value on delete condition.
    * @param : {List<Past_Experience__c>} oldRecords - new List of Past Experience
    * @return : List<Employee__c>
    */
    private static List<Employee__c> removePastExperienceRecord(List<Past_Experience__c> oldRecords){
        Set<String> setOfPastExperience = new Set<String>();
        for(Past_Experience__c pastExp : oldRecords){
            if(pastExp.Employee__c != null){
                setOfPastExperience.add(pastExp.Employee__c);
            }
        }
        List<Employee__c> empListForUpdate = Past_ExperienceTriggerHandlerUtility.calculateExperience(setOfPastExperience);
        return empListForUpdate;
    }
}