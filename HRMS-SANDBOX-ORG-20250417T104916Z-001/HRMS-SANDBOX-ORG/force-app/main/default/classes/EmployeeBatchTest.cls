/**
* @description : The EmployeeBatchTest is used by the EmployeeBatch
* @group : CalculateCompoffControllerTest
* @author :Aakash Mathur - HRMS
* @date  : 20th Nov 2023
* @modified by: Aakash Mathur
* @modified date: 28th Nov 2023
*/
@isTest
private class EmployeeBatchTest {
    
    /**
    * @description : Method is used to create  the test data 
    * @param : NA
    * @return : NA
    */
     @testSetup
    private static void insertRecordTest(){
        Integer numberEmployeeId;
        List<Employee__c> empList = new  List<Employee__c>();
        String employeeId = 'AC000';
        Employee__c employeeManager = TestDataFactory.employeeRecordCreate(); 
        empList.add(employeeManager);
        insert empList;
        numberEmployeeId = Integer.ValueOf(employeeManager.EMPLOYEE_ID__c.removeStart(HRMS_Constants.AC_STRING_FOR_EMPLOYEEID_PREFIX_FORMAT))+1;
        Employee__c emp = TestDataFactory.employeeRecordCreate(); 
        emp.Employee_Manager__c  = empList[0].Id;
        emp.Name = 'Test Employee';
        emp.Employee_Manager__c = empList[0].Id;
        emp.AADHAR_Number__c = emp.AADHAR_Number__c.replace('1', '0');
        emp.PAN_Number__c = emp.PAN_Number__c.replace('1','0');
        emp.EMPLOYEE_ID__c  = employeeId+numberEmployeeId;
        emp.Date_of_Relieving__c = system.today();
        insert emp;
   }

    /**
    * @description : Method will execute from EmployeeBatch only Cover positive scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void testEmployeeBatch() {
        List<Employee__c>   empList  = [Select Id,Name ,Personal_Email_ID__c From Employee__c where Name = 'Test' ];
        empList[0].Personal_Email_ID__c ='abc12@gmail.com';
        update empList;
        List<Employee__c> childEmployeeList = [SELECT Employee_Manager__r.Personal_Email_ID__c FROM Employee__c Where Name = 'Test Employee'];
        Test.startTest();
        Database.executeBatch(new EmployeeBatch());
        Test.stopTest();
        System.assertEquals(childEmployeeList.Size(), 1, ' No email should be sent');
    }
         
    /**
    * @description : Method will execute from EmployeeBatch only Cover Negative Scenario 
    * @param : NA
    * @return : NA
    */   
    @isTest
    static void testEmployeeBatchNegative() {
        List<Employee__c> employeeList = [SELECT Employee_Manager__r.Personal_Email_ID__c FROM Employee__c Where Name = 'Test' AND Employee_Manager__r.Personal_Email_ID__c != Null];
        Test.startTest();
        Database.executeBatch(new EmployeeBatch());
        Test.stopTest();
        System.assertEquals(employeeList.size(), 0, 'Email should be sent');
    }
}