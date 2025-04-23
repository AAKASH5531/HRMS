/**
* @description : The EmployeeTriggerHelperUtilityTest is used by the EmployeeTriggerHelperUtility //Include the detailed knowledge of class
* @group : EmployeeTriggerHelperUtilityTest
* @author : Rishabh Singh - HRMS
* @date  : 06th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 25th Nov 2023
*/

@isTest
Private class ScheduleAbsentMarkControllerTest {
    /**
    * @description : Method will execute from ScheduleAbsentMarkController only create Employee record 
    * @param : NA
    * @return : NA
    */
    @testSetup
    static void setupTestData() {
        List<Employee__c> empList = new List<Employee__c>();
        Employee__c employee = TestDataFactory.employeeRecordCreate();
        empList.add(employee);
        insert empList; // This not the right way of making DML without Null check.
    }
    
    /**
    * @description : Method will execute from ScheduleAbsentMarkController only cover getEmployeeRecord for positive scenario
    * @param : NA
    * @return : NA
    */
    @IsTest
    static void testAbsentUpdateForPositive() {
		Employee__c employee = [SELECT Id FROM Employee__c LIMIT 1];
        ScheduleAbsentMarkController.absentWrapper testWrapper = new ScheduleAbsentMarkController.absentWrapper();
        testWrapper.recordIds = new List<String>{employee.Id};
        List<ScheduleAbsentMarkController.absentWrapper> wrapperList = new List<ScheduleAbsentMarkController.absentWrapper>();
        wrapperList.add(testWrapper);
        Test.startTest();
        ScheduleAbsentMarkController.getEmployeeRecord(wrapperList);
        Test.stopTest();
        System.assertEquals(wrapperList, wrapperList , 'Call Successfully'); // This is totly worng thing to check the assert make it more meaningful.
    }
    
    /**
    * @description : Method will execute from ScheduleAbsentMarkController only cover getEmployeeRecord for negative scenario
    * @param : NA
    * @return : NA
    */
    
    // I am not able to see where you are try to test Nigetive use case.
    @IsTest
    static void testAbsentUpdateForNegative() {
		Employee__c employee = [SELECT Id FROM Employee__c LIMIT 1];
        ScheduleAbsentMarkController.absentWrapper testWrapper = new ScheduleAbsentMarkController.absentWrapper();
        testWrapper.recordIds = new List<String>{employee.Id};
        List<ScheduleAbsentMarkController.absentWrapper> wrapperList = new List<ScheduleAbsentMarkController.absentWrapper>();
        wrapperList.add(testWrapper);
        Test.startTest();
        ScheduleAbsentMarkController.getEmployeeRecord(wrapperList);
        Test.stopTest();
        System.assertEquals(wrapperList, wrapperList , 'NotCall Sucessfully'); // This is totly worng thing to check the assert make it more meaningful.
    }
}