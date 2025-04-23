/**
* @description : The EmployeeTableTest is used by the EmployeeTable
* @author : Aakash Mathur - HRMS
* @date  : 22/11/2023,
* @modified by: Aakash Mathur
* @modified date : 28/11/2023,
*/
@isTest
private class EmployeeTableTest {
   /*
    * @description : Method will execute from TestDataFactory only Create Employee record
    * @param : NA
    * @author : Aakash Mathur-HRMS
    * @return : NA
    */
    @testSetup static void createTestData(){ 
        List<Employee__c> empList = new List<Employee__c>();
        List<Project__c> projectList = new List<Project__c> ();
        List<Assigned_Project__c> assignedProjectList = new List<Assigned_Project__c>();
        Employee__c empRec = TestDataFactory.employeeRecordCreate();
        empList.add(empRec);
        insert empList;
        Project__c project =  TestDataFactory.createProject(); 
        projectList.add(project);
        insert projectList ;
        Assigned_Project__c assignedProject  = TestDataFactory.createAssigenProject(empRec.Id, project.Id);
        assignedProjectList.add(assignedProject);
        insert assignedProjectList;
    }
    
   /*
    * @description : Method will execute from EmployeeTable Cover getEmployeeList Postive Scenario. 
    * @param : NA
    * @return : NA
    */    
    @IsTest
    private static void getEmployeeListTest(){
        test.startTest();
        EmployeeTable.EmployeeInfoMainDto op = new  EmployeeTable.EmployeeInfoMainDto();
        EmployeeTable.EmployeeInfoMainDto  result = new  EmployeeTable.EmployeeInfoMainDto();
        result =  EmployeeTable.getEmployeeList();
        test.stopTest();
        System.assertEquals(result.ListOfAllProject[0],  'HRMS', 'Project name is not found');
    }
        
   /*
    * @description : Method will execute from EmployeeTable  Cover getEmployeeList Negative Scenario 
    * @param : NA
    * @return : NA
    */
    @IsTest
    private static void getEmployeeListNegativeTest(){
        test.startTest();
        List<Project__c> projectRecordList = [SELECT Id, Name FROM Project__c WHERE Name = 'HRMS'];
        projectRecordList[0].Name = 'ABCD';
        update projectRecordList;
        EmployeeTable.EmployeeInfoMainDto op = new  EmployeeTable.EmployeeInfoMainDto();
        EmployeeTable.EmployeeInfoMainDto  result = new  EmployeeTable.EmployeeInfoMainDto();
        result =  EmployeeTable.getEmployeeList();
        test.stopTest();
        System.assertNotEquals(result.ListOfAllProject[0],  'HRMS', 'Project name is found' );
    }  
}