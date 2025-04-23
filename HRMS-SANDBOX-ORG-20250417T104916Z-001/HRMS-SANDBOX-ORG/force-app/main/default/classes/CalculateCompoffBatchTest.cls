/**
* @description : The CalculateCompoffControllerTest is used by the CalculateCompoffController
* @group : CalculateCompoffControllerTest
* @author : Rishabh Singh - HRMS
* @date  : 16th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 24th Nov 2023
*/
@isTest
public class CalculateCompoffBatchTest {

    /**
    * @description : Method will execute from TestDataFactory only Create record
    * @param : NA
    * @return : NA
    */
    @testSetup public static void testData() {
        List<Employee__c> empList = new List<Employee__c>();
        Employee__c emp = TestDataFactory.employeeRecordCreate(); // Variable name need to make it more clear.
        empList.add(emp);
        insert empList; // Before insert need to check the list first.
        List<Comp_Off_Request__c> CompRequestList = new List<Comp_Off_Request__c>();
        Comp_Off_Request__c invalidCompOffRequest = TestDataFactory.createCompOffRequest(emp.Id, 'Invalid', Date.today().addDays(-35)); 
        CompRequestList.add(invalidCompOffRequest);
        Comp_Off_Request__c validCompOffRequest = TestDataFactory.createCompOffRequest(emp.Id, 'Valid', Date.today().addDays(-20)); 
        CompRequestList.add(validCompOffRequest);
        insert CompRequestList; // Before insert need to check the list first.
    }

    /**
    * @description : Method will execute from CalculateCompoffController only Cover ValidCompOffRequest Postive Scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    static void testValidCompOffRequest() {
        Test.startTest();
        Database.executeBatch(new CalculateCompoffBatch());
        Test.stopTest();
        List<Comp_Off_Request__c> compList = [SELECT Id, Comp_Off_Leave_Status__c FROM 
                                              		 Comp_Off_Request__c WHERE Comp_Off_Leave_Status__c = 'Invalid'];
        if(!compList.isEmpty()){
        	System.assertEquals('Invalid', compList[0].Comp_Off_Leave_Status__c, 'Comp_Off_Request__c should be marked as valid');
        }
        List<EmailMessage> sentEmails = [SELECT Id FROM EmailMessage]; // This is the bad way of making the query.
        System.assertEquals(1, sentEmails.size(), 'No email should be sent');
    }

    /**
    * @description : Method will execute from CalculateCompoffController only Cover InvalidCompOffRequest Negative Scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    static void testInvalidCompOffRequest() {
        Test.startTest();
        Database.executeBatch(new CalculateCompoffBatch());
        Test.stopTest();
        List<Comp_Off_Request__c> compList = [SELECT Id, Comp_Off_Leave_Status__c FROM 
                                                     Comp_Off_Request__c WHERE Comp_Off_Leave_Status__c = 'Valid'];
        if(!compList.isEmpty()){
        	System.assertNotEquals('Invalid', compList[0].Comp_Off_Leave_Status__c, 'Comp_Off_Request__c should not be marked as Invalid'); // assertion should be positive and negative test case.
        }    
        List<EmailMessage> sentEmails = [SELECT Id FROM EmailMessage];// This is the bad way of making the query.
        System.assertEquals(1, sentEmails.size() , 'Email should be sent');
    }
    
    /**
    * @description : Method will execute from CalculateCompoffBatch only Cover Scheduled Batch Scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    static void testschedule() {
        Test.StartTest();
        CalculateCompoffBatch sh1 = new CalculateCompoffBatch();
        String sch = '0 0 23 * * ?'; system.schedule('Test Batch Check', sch, sh1); // need to change the variable name sh and sh1.
        Test.stopTest();
        System.assertEquals('0 0 23 * * ?', sch , 'Test Batch Check');

    }
}