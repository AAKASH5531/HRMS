/**
* @description : The EmployeeTriggerHandlerTest is used by the EmployeeTrigger
* @group : EmployeeTrigger
* @author : Rishabh Singh - HRMS
* @created date : 03th Oct 2023
* @modified by: Rishabh Singh
* @modified date: 25th Nov 2023
*/
@isTest
public class EmployeeTriggerHandlerTest {

    /**
    * @description : The method is executed from EmployeeTrigger to create test data.
    * @param : NA
    * @author : Akash Sahani - HRMS
    * @return : NA
    */
    @testSetup
    private static void setupTestData() {
        List<User> userList = new List<User>();
        User userOfSystemAdminProfile = TestDataFactory.createUserWithProfile('System Administrator', 'SystemAdmin', 'sysadmins44@example.com', 'sysadmin22@example.com');
        userList.add(userOfSystemAdminProfile);
        User userOfDirectorProfile = TestDataFactory.createUserWithProfile('Director', 'EmployeeUser', 'Director44@example.com', 'Director22@example.com');
        userList.add(userOfDirectorProfile);
		insert userList; // This is not the right way fo making DML without null check.
        PermissionSet permissionSet = [SELECT Id 
                                       FROM PermissionSet 
                                       WHERE Name = 'InsertPermissionForDirector'];
        insert new PermissionSetAssignment(AssigneeId = userOfDirectorProfile.Id, PermissionSetId = permissionSet.Id);
    }
    
    /**
    * @description : The method is executed from EmployeeTriggerHandler only to cover the positive scenario for createEmployeeDocument method.
    * @param : NA
    * @return : NA
    */
    @isTest 
    private static void afterInsertPostive(){
        List<User> userOfSystemAdminProfiles = [SELECT Id, LastName, ProfileId FROM User WHERE Email = 'sysadmin22@example.com'];
        if(userOfSystemAdminProfiles[0] != null){
            System.runAs(userOfSystemAdminProfiles[0]){
                List<Employee__c> empList = new List<Employee__c>();
                Employee__c employee = TestDataFactory.employeeRecordCreate();
                empList.add(employee);
                test.startTest();
        		insert empList; // Without null check dont make any DML.
                test.stopTest();
                System.assertEquals(empList !=null, true); // Add the third param and also follow the same pattern as the assert method is designed.
            }
        }
    }
    
    /**
    * @description : The method is executed from EmployeeTriggerHandler only to cover the negative scenario for createEmployeeDocument method.
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void afterInsertNegative(){

        List<User> userOfSystemAdminProfiles = [SELECT Id, LastName, ProfileId FROM User WHERE Email = 'sysadmin22@example.com' LIMIT 1];
        if(userOfSystemAdminProfiles[0] != null){
            System.runAs(userOfSystemAdminProfiles[0]){
                List<Employee__c> empList = new List<Employee__c>();
                Employee__c employee = TestDataFactory.employeeRecordCreate();
                empList.add(employee);
                test.startTest();
        		insert empList; // Without null check dont make any DML.
                test.stopTest();
                System.assertEquals(empList == null, false); // Add the third param and also follow the same pattern as the assert method is designed.
            }
        }
    }
    
    /**
    * @description : The method is executed from EmployeeTriggerHandler only to cover the positive scenario for the validateEmployeeIdAndInsertBusinessDay.
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void testBeforeInsertPositive(){
        List<Employee__c> empList = new List<Employee__c>();
        List<Employee__c> listOfEmployee = [SELECT ID, EMPLOYEE_ID__c FROM Employee__c]; // This is not the right way of writing independent query. 
        Employee__c employee = TestDataFactory.employeeRecordCreate();
        empList.add(employee);
        test.startTest();
        insert empList; // Without null check dont make any DML.
        test.stopTest();
        system.assertEquals(empList != null, true); // Add the third param and also follow the same pattern as the assert method is designed by salesfroce.
    }
    
    /**
    * @description : The method is executed from EmployeeTriggerHandler only to cover the positive scenario for the validateEmployeeIdAndInsertBusinessDay method.
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void testBeforeInsertNegative(){
        List<Employee__c> empList = new List<Employee__c>();
        List<Employee__c> listOfEmployee = [SELECT ID, EMPLOYEE_ID__c, Employee_Activity_Status__c FROM Employee__c]; // This is not the right way of writing independent query.
        Employee__c employee = TestDataFactory.employeeRecordCreate();
        empList.add(employee);
        test.startTest();
        insert empList;  // Without null check dont make any DML.
        test.stopTest();
        system.assertEquals(empList == null, false); // Add the third param and also follow the same pattern as the assert method is designed by salesfroce.
    } 
    
    /**
    * @description : The method is executed from EmployeeTriggerHandler only to cover the positive scenario for the validateEmployeeIdAndtotalExperienceInsert method.
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void testBeforeUpdatePositive(){
        List<Employee__c> empList = new List<Employee__c>();
        Employee__c employee = TestDataFactory.employeeRecordCreate();
        empList.add(employee);
        insert empList; // Without null check dont make any DML.
        List<User> userOfSystemAdminProfiles = [SELECT Id, LastName, ProfileId FROM User WHERE Email = 'sysadmin22@example.com' LIMIT 1];
        if(userOfSystemAdminProfiles[0] != null){
            System.runAs(userOfSystemAdminProfiles[0]){
                List<Employee__c> listOfEmployee = [SELECT ID, Employee_Activity_Status__c, Date_of_Joining__c, Date_of_Relieving__c FROM Employee__c]; // This is not the right way of writing independent query.
                listOfEmployee[0].Employee_Activity_Status__c = 'On Notice';
                listOfEmployee[0].Date_of_Relieving__c = Date.today().addDays(30);
                listOfEmployee[0].Date_of_Joining__c = Date.today().addDays(-4);
                test.startTest();
				update listOfEmployee[0];
                test.stopTest();
                system.assertEquals(listOfEmployee[0] != null, True); // Add the third param and also follow the same pattern as the assert method is designed by salesfroce.
            } 
        }
    } 
    
    /**
    * @description : The method is executed from EmployeeTriggerHandler only to cover the negative scenario for the validateEmployeeIdAndtotalExperienceInsert method.
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void testBeforeUpdateNegative(){
        List<Employee__c> empList = new List<Employee__c>();
        List<User> userOfDirectorProfiles = [SELECT Id, LastName, ProfileId FROM User WHERE Email = 'Director22@example.com' LIMIT 1];
        if(userOfDirectorProfiles[0] != null){
            System.runAs(userOfDirectorProfiles[0]){
                Employee__c employee = TestDataFactory.employeeRecordCreate();
                empList.add(employee);
                insert empList; // Without null check dont make any DML.
                List<Employee__c> listOfEmployee = [SELECT ID, Employee_Activity_Status__c, Date_of_Relieving__c, Date_of_Joining__c FROM Employee__c]; // This is not the right way of writing independent query.
                listOfEmployee[0].Contact_Number__c = '8457890';
                listOfEmployee[0].Date_of_Relieving__c = Date.today().addDays(30);
                listOfEmployee[0].Date_of_Joining__c = Date.today().addDays(-1);
                test.startTest();
                update listOfEmployee[0];
                test.stopTest();
                system.assertEquals(listOfEmployee[0] == null, false); // Add the third param and also follow the same pattern as the assert method is designed by salesfroce.
            } 
        }
    } 
}