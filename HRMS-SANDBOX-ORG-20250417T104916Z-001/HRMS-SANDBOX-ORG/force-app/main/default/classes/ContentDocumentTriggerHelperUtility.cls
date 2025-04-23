/**
* @description : The handler is used by the ContentDocumentTrigger
* @group : ContentDocumentTrigger
* @author : Aakash Mathur - HRMS
* @created date  : 03th Oct 2023
* @modified by: Aakash Mathur
* @modified date : 25 Nov 2023
*/
public class ContentDocumentTriggerHelperUtility {
     
    /**
    * @description : Method will execute from ContentDocumentTrigge only on afterInsert of ContentDocument Object record
    * @param : List<ContentDocument> newList - Contains Employee object mapping from Trigger.new
    * @return : List<Employee__c>    // Return statement need to be more clear.
    */
    public static List<Employee__c> updateDocumentsUploadedOfEmployee(Map<ID, ContentDocument> newRecordMap) {
        Set<Id> contentDocumentId = new Set<Id>(); 
        Set<Id> idofEmployeeDoc = new Set<Id>();
        Set<Id> idofEmployee = new Set<Id>();
        List<Employee__c> employeeListToUpdate = new List<Employee__c>();
        Set<Id> empIdtoUpdate = new Set<Id>();
        // code should be formated way.
        try{  
           if(!newRecordMap.isEmpty() && newRecordMap != null){
                List<ContentDocumentLink> contLink = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN : newRecordMap.keySet()];
                if(contLink.size() > 0){
                for(ContentDocumentLink conDocLink : contLink){
                    if(conDocLink.LinkedEntityId.getSObjectType() == Employee_Document__c.sObjectType ){
                        idofEmployeeDoc.add(conDocLink.LinkedEntityId);
                    }
                }
            }
            List<Employee_Document__c> employeDocList = [SELECT Id, Name, File_Uploaded__c, Employee__c
                                                         FROM Employee_Document__c  WHERE Id IN : idofEmployeeDoc];
            for(Employee_Document__c empdoc: employeDocList){
                idofEmployee.add(empdoc.Employee__c);
            }
            List<Employee__c> employeList = [SELECT Id, Name, (SELECT Id, File_Uploaded__c, Name
                                             FROM Employee_Documents__r ) FROM Employee__c WHERE Id IN : idofEmployee ];
            for(Employee__c emp : employeList){
                Integer i = 0;
                for(Employee_Document__c empdoc : emp.Employee_Documents__r){
                    if(empdoc.File_Uploaded__c){
                        empIdtoUpdate.add(emp.Id);
                        i++;
                    }
                }    
                if(empIdtoUpdate.size() > 0 && i >= 21){
                    for(Id empId : empIdtoUpdate){
                        Employee__c  empRec = new Employee__c ();
                        empRec.Id = empId;
                        empRec.Documents_Uploaded__c = true;
                        employeeListToUpdate.add(empRec);
                    }
                }
            }   
        }
            return employeeListToUpdate ;  
        }
        catch(Exception ex){
            System.debug('Error--'+ex.getMessage());
             System.debug('Error line--'+ex.getLineNumber());
        }
        return null;
    }
}