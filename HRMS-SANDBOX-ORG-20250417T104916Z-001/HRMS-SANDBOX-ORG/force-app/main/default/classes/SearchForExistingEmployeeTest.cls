/**
* @description : The SearchForExistingEmployeeTest is used by the SearchForExistingEmploye
* @group : SearchForExistingEmploye
* @author : Aakash Mathur - HRMS
* @date  : 07/11/2023,
* @modified by : Aakash Mathur
* @modified date : 27/11/2023,
*/

@isTest
private class SearchForExistingEmployeeTest{
      
  /** 
  * @description : Method will execute from TestDataFactory only Create Test record
  * @param : NA
  * @return : NA
  */
  @testSetup 
  public static void searchForExistingEmployee() {
    List<Employee__c> empList = new  List<Employee__c>();
    Employee__c employeeManager = TestDataFactory.employeeRecordCreate(); 
    empList.add(employeeManager);
    insert empList; // This not the right way of making DML without Null check.
    empList[0].Date_of_Relieving__c = system.today();
    empList[0].Employee_Activity_Status__c = 'On Notice';
    update empList;
   
  }
    
  /**
  * @description : Method will execute from searchForExistingRecord  Cover search For Existing Record Postive Scenario 
  * @param : NA
  * @return : NA
  */ 
  @isTest
  private static void searchForExistingRecordTest(){
    List<Employee__c> listOfEmployee = [SELECT Id, Name, Employee_Activity_Status__c, PAN_Number__c, AADHAR_Number__c FROM Employee__c WHERE Name = 'Test' LIMIT 1];
    if(!listOfEmployee.isEmpty()){
        listOfEmployee[0].Employee_Activity_Status__c = 'Inactive';
        update listOfEmployee;
    }
    Test.startTest();
    List<Employee__c> empList = SearchForExistingEmployee.searchForExistingEmployee(listOfEmployee[0].AADHAR_Number__c);
    Test.stopTest();
    System.assertEquals(empList[0].AADHAR_Number__c, listOfEmployee[0].AADHAR_Number__c, 'Existing Employee Not Found');
  }
  
  /**
  * @description : Method will execute from searchForExistingRecord to Cover search For Existing Record Cover Negative Scenario 
  * @param : NA
  * @return : NA
  */  
  @isTest
  private static void searchForExistingRecordNegativeTest(){
    List<Employee__c> listOfEmployee = [SELECT Id, Name, PAN_Number__c, AADHAR_Number__c FROM Employee__c WHERE Name = 'Test'];
    Test.startTest();
    List<Employee__c> empList = SearchForExistingEmployee.searchForExistingEmployee('');
    Test.stopTest();
    System.assertEquals(empList, null, 'Existing Employee Found');
  }   
}