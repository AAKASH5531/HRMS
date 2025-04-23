/**
* @description : The Past_ExperienceAfterUpdateHandler is used by the PastExperienceTrigger
* @group : PastExperienceTrigger
* @created By : Ankita Dhamgaya
* @created date : 30th Oct 2023
* @modified by: Akash Sahani
* @modified date: 25th Nov 2023
*/
public with sharing class Past_ExperienceAfterUpdateHandler extends TriggerHandlerBase{
    List<Past_Experience__c> newRecords;
    List<Past_Experience__c> oldRecords;
    Map<Id,Past_Experience__c> oldRecordsMap;
    List<Employee__c> empListForUpdate;

    public Past_ExperienceAfterUpdateHandler() {
        empListForUpdate = new List<Employee__c>();
    }

	/**
    * @description : The method is executed from PastExperienceTrigger only on AfterUpdate of the Past Experience object.
    * @param : List<SObject> newList - Contains Past Experience object mapping from Trigger.new
    * @return : NA
    */
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('Past_ExperienceAfterUpdateHandler qualifyStartingRecords');
        newRecords = (List<Past_Experience__c>) newList;
        oldRecords = (List<Past_Experience__c>) oldList;
        oldRecordsMap = (Map<Id,Past_Experience__c>) oldMap;
    }

    /**
    * @description : The method is executed from PastExperienceTrigger only during the update of a Past Experience record.
    * @param : NA
    * @return : NA
    */
    public override void start() {
        
        empListForUpdate = calculatePastExperianceWhenUpdate(newRecords, oldRecordsMap);
    }

    /**
    * @description : The method is executed from PastExperienceTrigger only during the update of a Past Experience record.
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
    * @description : The method is executed from PastExperienceTrigger and returns the calculated Experience value on update condition.
    * @param : {List<Past_Experience__c>} newRecords, {Map<Id, Past_Experience__c>}oldMap - new List of Past Experience, old map of Past Experience Id and Past Experience
    * @return : List<Employee__c>
    */
    @testVisible
    private static List<Employee__c> calculatePastExperianceWhenUpdate(List<Past_Experience__c> newRecords, Map<Id, Past_Experience__c> oldRecordsMap){
        Set<String> setOfPastExperience = new Set<String>();
        for (Past_Experience__c pastExpRecords : newRecords) {
            Past_Experience__c oldPastExpRecords = oldRecordsMap.get(pastExpRecords.Id);
            if (pastExpRecords.Joining_Date__c != oldPastExpRecords.Joining_Date__c || pastExpRecords.Relieving_Date__c != oldPastExpRecords.Relieving_Date__c) {
                if(pastExpRecords.Employee__c != null){
                    setOfPastExperience.add(pastExpRecords.Employee__c);
                }						            
            }
        }
		List<Employee__c> empListForUpdate = Past_ExperienceTriggerHandlerUtility.calculateExperience(setOfPastExperience);
        return empListForUpdate;				   
    }
}