/**
* @description : The Past_ExperienceAfterInsertHandler is used by the PastExperienceTrigger
* @group : PastExperienceTrigger
* @created By : Ankita Dhamgaya
* @created date : 30th Oct 2023
* @modified by: Akash Sahani
* @modified date: 25th Nov 2023
*/
public with sharing class Past_ExperienceAfterInsertHandler extends TriggerHandlerBase{
    List<Past_Experience__c> newRecords;
    List<Past_Experience__c> oldRecords;
    List<Employee__c> empListForUpdate;

    public Past_ExperienceAfterInsertHandler() {
        empListForUpdate = new List<Employee__c>();
    }

    /**
    * @description : The method is executed from PastExperienceTrigger only on AfterInsert of the Past Experience object.
    * @param : List<SObject> newList - Contains Past Experience object mapping from Trigger.new
    * @return : NA
    */
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('Past_ExperienceAfterInsertHandler qualifyStartingRecords');
        newRecords = (List<Past_Experience__c>) newList;
        oldRecords = (List<Past_Experience__c>) oldList;
    }

    /**
    * @description : The method is executed from PastExperienceTrigger only in the Past_ExperienceAfterInsertHandler.
    * @param : NA
    * @return : NA
    */
    public override void start() {
        empListForUpdate = calculatePastExperiance(newRecords);
    }

	/**
    * @description : The method is executed from PastExperienceTrigger only during the insertion of a Past Experience record.
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
    * @description : The method is executed from PastExperienceTrigger and returns the calculated Experience value on insert condition.
    * @param : {List<Past_Experience__c>} newRecords - new List of Past Experience
    * @return : List<Employee__c>
    */
    private static List<Employee__c> calculatePastExperiance(List<Past_Experience__c> newRecords){
        Set<String> setOfPastExperience = new Set<String>();
        for(Past_Experience__c pastExp : newRecords){
            if(pastExp.Employee__c != null){
            	setOfPastExperience.add(pastExp.Employee__c);
            }
        }
        List<Employee__c> empListForUpdate = Past_ExperienceTriggerHandlerUtility.calculateExperience(setOfPastExperience);
        return empListForUpdate;
    }
}