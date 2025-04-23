/**
* @description : The ReHireCustomCloneButtonTest is used by the ReHireCustomCloneButton
* @author : Rishabh Singh - HRMS
* @date  : 25th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 25th Nov 2023
*/
@IsTest
public class ReHireCustomCloneButtonTest {
    
    /**
    * @description : Method will execute from ReHireCustomCloneButton only for dml on record 
    * @param : NA
    * @return : NA
    */
    @testSetup
    static void setupTestData() {
        List<Employee__c> empList = new  List<Employee__c>();
        Employee__c employee = TestDataFactory.employeeRecordCreate();
        empList.add(employee);
        insert empList; // This is not the right way of making DML without checking the list.
    }
    
    /**
    * @description : Method will execute from ReHireCustomCloneButton only cover collectEmployeeDetails positive scenario
    * @param : NA
    * @return : NA
    */ 
    @IsTest
    static void testCollectEmployeeDetailsPositive() {
        Employee__c employee = [SELECT Id FROM Employee__c LIMIT 1]; // Dont make soql query without any condition it's not good way of writing the soql query.
        Test.startTest();
        Employee__c result = ReHireCustomCloneButton.collectEmployeeDetails(employee.Id); // Variable should be more clear insted of just using "result".
        Test.stopTest();
        System.assertNotEquals(employee.Id, 'invalidId', 'result not null'); // It should we check the record id into Ecpected and actual both insted of checking the assertNot equal and assert message should be meaningful.
    } 

    /**
    * @description : Method will execute from ReHireCustomCloneButton only cover collectEmployeeDetails negative scenario
    * @param : NA
    * @return : NA
    */
    @IsTest
    static void testCollectEmployeeDetailsNegative() {
        try {
            Test.startTest();
            Employee__c result = ReHireCustomCloneButton.collectEmployeeDetails('invalidId'); // Variable should be more clear insted of just using "result".
            Test.stopTest();
        }catch (AuraHandledException e) {
        }
         System.assertNotEquals('invalidId', 'result', 'result  null'); // Assert message need to more detailed.


    } 
}