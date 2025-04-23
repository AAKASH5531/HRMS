/**
* @description : The TaskTriggerHandlerTest is used by the TaskTrigger
* @group : TaskTrigger
* @author : Akash Sahani - HRMS
* @created date : 07th Nov 2023
* @modified by: Akash Sahani
* @modified date: 25th Nov 2023
*/
@isTest
public class TaskTriggerHandlerTest {

    /**
    * @description : The method is executed from TaskTrigger to create test data.
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
    * @description : The method is executed from TaskTriggerHandler only to cover the positive scenario for fillBusinessDayFieldsBeforeInsert method.
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void testFillBusinessDayFieldsBeforeInsert_PositiveScenario() {
        List<Task> taskList = new List<Task>();
        String medicalAddition = 'Medical Addition';
        List<User> systemAdminUsers = [SELECT Id, LastName, ProfileId FROM User WHERE Email = 'sysadmin22@example.com'];
        if(systemAdminUsers[0] != null){
            System.runAs(systemAdminUsers[0]){
                Task testTaskForMedical = TestDataFactory.createTask(medicalAddition); 
                taskList.add(testTaskForMedical);
                test.startTest();
                insert taskList;
                test.stopTest();
                List<Task> tasks = [SELECT Subject, After_Three_Bussines_Day__c, After_Seven_Business_day__c FROM Task 
                             WHERE Subject =: medicalAddition];
                if (taskList[0].Subject == medicalAddition) {
                    System.assertEquals(CalculateBusinessDayWithHoliday.getBusinessDay(null,3), tasks[0].After_Three_Bussines_Day__c);
                    System.assertEquals(CalculateBusinessDayWithHoliday.getBusinessDay(null,7), tasks[0].After_Seven_Business_day__c);
                }
            }
        }
    }

    /**
    * @description : The method is executed from TaskTriggerHandler only to cover the negative scenario for fillBusinessDayFieldsBeforeInsert method.
    * @param : NA
    * @return : NA
    */
	@isTest
    private static void testFillBusinessDayFieldsBeforeInsert_NegativeScenario() {
        String otherTask = 'Other Task';
        List<Task> taskList = new List<Task>();
        List<User> directorUsers = [SELECT Id, LastName, ProfileId FROM User WHERE Email = 'Director22@example.com' LIMIT 1];
        if(directorUsers[0] != null){
            System.runAs(directorUsers[0]){
                Task taskForOther = TestDataFactory.createTask(otherTask);
                taskList.add(taskForOther);
                test.startTest();
                insert taskList;
                test.stopTest();
                List<Task> tasks = [SELECT Subject, After_Three_Bussines_Day__c, After_Seven_Business_day__c FROM Task 
                             WHERE Subject =: otherTask LIMIT 1];
                if (taskList[0].Subject == otherTask) {
                    System.assert(tasks[0].After_Three_Bussines_Day__c == null);
                    System.assert(tasks[0].After_Seven_Business_day__c == null);
                }
            }
        }
    }
        
}