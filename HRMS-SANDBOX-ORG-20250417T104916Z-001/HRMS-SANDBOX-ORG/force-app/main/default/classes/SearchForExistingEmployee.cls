/**
* @description : The handler is used by the lightning web components rehireEmployee
* @author : Aakash Mathur - HRMS
* @Created Date : 7th Oct 2023
* @modified by: Aakash Mathur - HRMS 
* @modified date : 25th Nov 2023
*/

public with sharing class SearchForExistingEmployee {

    /** 
    * @description : This method is responsible for geting Aadhar or Pan card number and return Employee Information on the custom screen.
    * @param : String searchInput - Contains Aadhar or Pan card number
    * @return : List<Employee__c> employeeList
    */
    @AuraEnabled
    public Static List<Employee__c> searchForExistingEmployee(String searchInput) {
        try{
            if(!String.isBlank(searchInput)){
              List<Employee__c> employeeList = [SELECT Id, Salutation__c, Middle_Name__c, Designation__c, Date_of_Joining__c, Gender__c,
                                                    EMPLOYEE_ID__c, Name, RecordTypeId, AADHAR_Number__c, Last_Name__c, Employee_Activity_Status__c,
                                                    PAN_Number__c FROM Employee__c WHERE (AADHAR_Number__c =:searchInput AND Employee_Activity_Status__c = 'Inactive') 
                                                    OR (PAN_Number__c =:searchInput  AND Employee_Activity_Status__c = 'Inactive') ];
             return employeeList;
            }
            else{
               return null; 
            }
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }  
   }
}