/**
* @description : The ReHireCustomCloneButton is used for ReHire employee
* @author : Rishabh Singh - HRMS
* @date  : 25th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 25th Nov 2023
*/
public class ReHireCustomCloneButton {
    
    /**
    * @description : Method will use for Rehire employee
    * @param : String empId
    * @return : employee record - (Employee__c) // It should be little bit more delaited.
    */
    @AuraEnabled
    public static Employee__c collectEmployeeDetails(String empId){// Param name should be more meaningful rather than empId. 
        try{// Put only those line of codes into try block which may occur runtime errors..
            List<String> fieldsList = new List<String>();
            Map<String, Schema.SObjectField> fieldSchemaMap = Schema.getGlobalDescribe().get('Employee__c').getDescribe().fields.getMap(); //Variable name should be more meaningful rather than fieldSchemaMap.
            for(String fieldName : fieldSchemaMap.keySet()){
                Schema.DescribeFieldResult fieldDescribe = fieldSchemaMap.get(fieldName).getDescribe(); //Variable name should be more meaningful rather than fieldDescribe.
                if(fieldDescribe.isCreateable()){
                    fieldsList.add(fieldName);
                }
            }
            return Database.Query('Select '+String.join(fieldsList, ',')+' from Employee__c where Id = \''+empId+'\'');
        }catch(Exception e) { // Don't just put e make it more meaningful. 
            throw new AuraHandledException(e.getMessage());
        }
    }
}