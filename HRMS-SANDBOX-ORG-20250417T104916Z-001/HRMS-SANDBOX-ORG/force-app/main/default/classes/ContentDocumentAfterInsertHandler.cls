/**
* @description : The handler is used by the ContentDocumentTrigger
* @group : ContentDocumentTrigger
* @author : Aakash Mathur - HRMS
* @created On : 03 November 2023
* @modified by : Aakash Mathur 
* @modified date : 25th Nov 2023
*/

public with sharing class ContentDocumentAfterInsertHandler extends TriggerHandlerBase{
    List<ContentDocument> newRecords;
    Map<ID, ContentDocument> newRecordMap;
    List<Employee__c> employeeListToUpdate;
    
    public ContentDocumentAfterInsertHandler(){
    	employeeListToUpdate = new List<Employee__c>() ;
    }
    
    /**
    * @description : Method will execute from ContentDocumentTrigger only on After Insert of ContentDocument Object
    * @param : List<SObject> newList - Contains ContentDocument object mapping from Trigger.new
    * @return : NA
    */     
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('ContentDocumentAfterInsertHandler qualifyStartingRecords');
        newRecords = (List<ContentDocument>) newList;
        newRecordMap = (Map<ID, ContentDocument>) newMap;
        
    }
    public override void start() {
        employeeListToUpdate = ContentDocumentTriggerHelperUtility.updateDocumentsUploadedOfEmployee(newRecordMap);
    }
    
    public override void finish(Boolean fromStart) {
        if(fromStart) {
            if(employeeListToUpdate.size() > 0){
                try{
                    update employeeListToUpdate;
                } 
                catch(Exception ex){
                    System.debug('Error--'+ex.getMessage());
                }
            }
        }
        Diagnostics.pop();
    }
}