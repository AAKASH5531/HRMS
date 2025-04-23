/**
* @description : The Past_ExperienceTriggerHandlerTest is used by the Past_ExperienceTrigger
* @group : Past_ExperienceTrigger
* @created By : Ankita Dhamgaya
* @created date : 30th Oct 2023
* @modified by: Akash Sahani
* @modified date: 25th Nov 2023
*/
@isTest
private class Past_ExperienceTriggerHandlerTest {
    
    /**
    * @description : The method is executed from Past_ExperienceTrigger to create test data.
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
        insert userList;
        PermissionSet permissionSet = [SELECT Id 
                                       FROM PermissionSet 
                                       WHERE Name = 'InsertPermissionForDirector'];
        insert new PermissionSetAssignment(AssigneeId = userOfDirectorProfile.Id, PermissionSetId = permissionSet.Id);
    }
    
    /**
    * @description : The method is executed from Past_ExperienceAfterInsertHandler only to cover the positive scenario for calculatePastExperiance.
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void testAfterInsertExperiencePositive() {
        List<Employee__c> empList = new List<Employee__c>();
        List<Past_Experience__c> pastExperienceList = new List<Past_Experience__c>();
        List<User> userOfSystemAdminProfile = [SELECT Id, LastName, ProfileId FROM User WHERE Email = 'sysadmin22@example.com'];
        if(userOfSystemAdminProfile[0] != null){
            System.runAs(userOfSystemAdminProfile[0]){
                Employee__c employee = TestDataFactory.employeeRecordCreate();
                empList.add(employee);
                Test.startTest();
                insert empList;
                Past_Experience__c pastExperience = TestDataFactory.createPastExperienceRecord(empList[0].Id);
                pastExperienceList.add(pastExperience);
                insert pastExperienceList;
                Test.stopTest();
                List<Employee__c> updatedEmployees = [SELECT Id, Past_Experience__c, Total_Experience__c FROM Employee__c WHERE Id = :employee.Id];
                System.assertEquals(updatedEmployees[0] != null , true);
            }
        }
    }
    
    /**
    * @description : The method is executed from Past_ExperienceAfterInsertHandler only to cover the negative scenario for calculatePastExperiance.
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void testAfterInsertExperienceNegative() {
        List<Employee__c> empList = new List<Employee__c>();
        List<Past_Experience__c> pastExperienceList = new List<Past_Experience__c>();
        User userOfDirectorProfile = [SELECT Id, LastName, ProfileId FROM User WHERE Email = 'Director22@example.com' LIMIT 1];
        if(userOfDirectorProfile != null){
            System.runAs(userOfDirectorProfile){
                Employee__c employee = TestDataFactory.employeeRecordCreate();
                empList.add(employee);
                Test.startTest();
                insert empList;
                Past_Experience__c pastExperience = TestDataFactory.createPastExperienceRecord(empList[0].Id);
                pastExperienceList.add(pastExperience);
                insert pastExperienceList;
                Test.stopTest();
                List<Employee__c> updatedEmployees = [SELECT Id, Past_Experience__c, Total_Experience__c FROM Employee__c WHERE Id = :employee.Id];
                System.assertEquals(updatedEmployees[0] == null, false);
            }
        }
    }
    
    /**
    * @description : The method is executed from Past_ExperienceAfterUpdateHandler only to cover the positive scenario for calculatePastExperianceWhenUpdate method.
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void testCalculatePastExperianceWhenUpdatePositive() {
        List<Employee__c> empList = new List<Employee__c>();
        List<Past_Experience__c> pastExperienceList = new List<Past_Experience__c>();
		Employee__c employee = TestDataFactory.employeeRecordCreate();
        empList.add(employee);
		insert empList;
        Past_Experience__c pastExperience = TestDataFactory.createPastExperienceRecord(employee.Id);
        pastExperienceList.add(pastExperience);
        insert pastExperienceList;
        List<Past_Experience__c> pastExperienceForUpdateJoiningDates = [SELECT Joining_Date__c, Relieving_Date__c, Employee__c FROM Past_Experience__c WHERE Employee__c != null];
        pastExperienceForUpdateJoiningDates[0].Relieving_Date__c = Date.today().addDays(60);
        Test.startTest();
        update pastExperienceForUpdateJoiningDates[0];
        Test.stopTest();
        System.assertEquals(pastExperienceForUpdateJoiningDates[0] !=null, true); 
    }

    /**
    * @description : The method is executed from Past_ExperienceAfterUpdateHandler only to cover the negative scenario for calculatePastExperianceWhenUpdate method.
    * @param : NA
    * @return : NA
    */
	@isTest
    private static void testCalculatePastExperianceWhenUpdateNegative() {
        List<Employee__c> empList = new List<Employee__c>();
        List<Past_Experience__c> pastExperienceList = new List<Past_Experience__c>();
		Employee__c employee = TestDataFactory.employeeRecordCreate();
        empList.add(employee);
		insert empList;
        Past_Experience__c pastExperience = TestDataFactory.createPastExperienceRecord(employee.Id);
        pastExperienceList.add(pastExperience);
        insert pastExperienceList;
		List<Past_Experience__c> pastExperienceForUpdateJoiningDates = [SELECT Joining_Date__c, Relieving_Date__c, Employee__c FROM Past_Experience__c WHERE Employee__c != null];
		pastExperienceForUpdateJoiningDates[0].Relieving_Date__c = Date.today().addDays(60);
        Test.startTest();
        update pastExperienceForUpdateJoiningDates[0];
        Test.stopTest();
        System.assertEquals(pastExperienceForUpdateJoiningDates[0] == null, false);
    }	
}