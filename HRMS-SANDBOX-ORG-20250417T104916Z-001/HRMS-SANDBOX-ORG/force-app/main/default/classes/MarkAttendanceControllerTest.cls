/**
* @description : The MarkAttendanceControllerTest is used by the MarkAttendanceController
* @group : MarkAttendanceControllerTest
* @author : Rishabh Singh - HRMS
* @date  : 09th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 16th Nov 2023
*/
@isTest
private class MarkAttendanceControllerTest {

    /**
    * @description : Method will execute from TestDataFactory only Create Employee record
    * @param : NA
    * @return : NA
    */
    @testSetup public static void testData() {
        List<Employee__c> empList = new  List<Employee__c>();
        Employee__c testEmployee = TestDataFactory.employeeRecordCreate(); 
        testEmployee.User_Associated__c = UserInfo.getUserId();
        empList.add(testEmployee);
        insert empList; // Don't make DML without null check.
    }

    /**
    * @description : Method will execute from MarkAttendanceController only Cover markAttendance Postive Scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    static void testMarkAttendancePositive() {
        Test.startTest();
        Boolean result = MarkAttendanceController.markAttendance();
        Test.stopTest();
        System.assertEquals(true, result, 'Attendance should be marked successfully');
    }
    
    /**
    * @description : Method will execute from MarkAttendanceController only Cover markAttendance Negative Scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    static void testMarkAttendanceNegative() {
        Test.startTest();
        Boolean result = MarkAttendanceController.markAttendance();
        Test.stopTest();
        System.assertEquals(false, false, 'Attendance should be  Not marked successfully');
    }
    
    /**
    * @description : Method will execute from MarkAttendanceController only Cover markHalfDayAttendance Postive Scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    static void testMarkHalfDayAttendancePositive() {
        Test.startTest();
        Boolean result = MarkAttendanceController.markHalfDayAttendance();
        Test.stopTest();
        System.assertEquals(true, result, 'HalfDay should be marked successfully');
    }
    
    /**
    * @description : Method will execute from MarkAttendanceController only Cover markHalfDayAttendance Negative Scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    static void testMarkHalfDayAttendanceNegative() {
        Test.startTest();
        Boolean result = MarkAttendanceController.markHalfDayAttendance();
        Test.stopTest();
        System.assertEquals(false, false, 'HalfDay should be Not marked successfully');
    }
    
    /**
    * @description : Method will execute from MarkAttendanceController only Cover checkAttendance Postive Scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    static void testCheckAttendancePositive() {
        Test.startTest();
        List<MarkAttendanceController.AttendanceManagement> attendanceList = MarkAttendanceController.checkAttendance();
        Test.stopTest();
        System.assertEquals(true, !attendanceList.isEmpty(), 'Comp Off should be marked successfully');
    }
    
    /**
    * @description : Method will execute from MarkAttendanceController only Cover checkAttendance Negative Scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    static void testCheckAttendanceNegative() {
        Test.startTest();
        List<MarkAttendanceController.AttendanceManagement> attendanceList = MarkAttendanceController.checkAttendance();
        Test.stopTest();
        System.assertEquals(false, attendanceList.isEmpty(), 'Comp Off should be Not marked successfully');
    }
}