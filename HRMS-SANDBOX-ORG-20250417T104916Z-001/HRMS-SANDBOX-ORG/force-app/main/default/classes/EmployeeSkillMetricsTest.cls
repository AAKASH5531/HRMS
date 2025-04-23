/**
* @description : The EmployeeSkillMetricsTest is used by the EmployeeSkillMetrics
* @author : Aakash Mathur - HRMS
* @date  : 07/11/2023,
* @modified by : Aakash Mathur
* @modified date : 25/11/2023,
*/
@isTest
private class EmployeeSkillMetricsTest {
    
    
    /** 
* @description : Method will execute from TestDataFactory only Create Test record
* @param : NA
* @return : NA
*/
    @testSetup 
    private static void createRecord() {
        List<Employee__c> employeeList = new List<Employee__c>();
        List<Skills__c> skillList = new List<Skills__c> ();
        List<Employee_Skills__c> empSkillList = new List<Employee_Skills__c>(); 
        List<Project__c> projectList = new List<Project__c> ();
        List<Assigned_Project__c> assignedProjectList = new List<Assigned_Project__c>();
        List<Project_Skills__c> projectSkillList = new List<Project_Skills__c>();
        List<Employee_Skills_Package__c> employeeSkillsPackageList = new List<Employee_Skills_Package__c>(); 
        List<Skills_Package__c> skillPackageList = new List<Skills_Package__c>();
        Employee__c empRec = TestDataFactory.employeeRecordCreate();
        employeeList.add(empRec);
        if(!employeeList.isEmpty()){
            insert employeeList; 
        }
        Skills__c skill  =  TestDataFactory.createSkillRecord();
        skillList.add(skill);
        if(!skillList.isEmpty()){
            insert skillList;
        }
       Skills_Package__c skillPackage =  TestDataFactory.createProjectSkillsPackage();
        skillPackageList.add(skillPackage);
        if(!skillPackageList.isEmpty()){
            insert skillPackageList;
        }
        Employee_Skills__c empSkillRecord = TestDataFactory.createEmployeeSkillRecord(skillList[0].Id, employeeList[0].Id);
        empSkillList.add(empSkillRecord);
        if(!empSkillList.isEmpty()){
            insert empSkillList;
        }
        Project__c project =  TestDataFactory.createProject(); 
        projectList.add(project);
        if(!projectList.isEmpty()){
            insert projectList;
        } 
        Assigned_Project__c assignedProject  = TestDataFactory.createAssigenProject(empRec.Id, project.Id);
        assignedProject.Is_Billable__c = true;
        assignedProjectList.add(assignedProject);
        
        if(!assignedProjectList.isEmpty()){
            insert assignedProjectList;           
        }
        Project_Skills__c projectSkillsRecord = TestDataFactory.createProjectSkill(skillList[0].Id, projectList[0].Id);
        projectSkillList.add(projectSkillsRecord);
        if(!projectSkillList.isEmpty()){
            insert projectSkillList;
        }
       Employee_Skills_Package__c empSkillPackageRecord  =  TestDataFactory.createEmployeeSkillPackageRecord(skillPackageList[0].Id, employeeList[0].Id);
        employeeSkillsPackageList.add(empSkillPackageRecord);
        if(!employeeSkillsPackageList.isEmpty()){
            insert employeeSkillsPackageList;
        }
    }
    
    @isTest
    private static void getEmployeeInfPositiveTest(){
        List<Employee__c> employeeList = [SELECT Id, Total_Experience__c FROM Employee__c LIMIT 1];
        List<Project__c> projectList = [SELECT Id, Name FROM project__c LIMIT 1];
        Test.startTest();
        List<EmployeeSkillMetrics.Demo>  result = new List<EmployeeSkillMetrics.Demo>();
        if(!employeeList.isEmpty() && !projectList.isEmpty()){
           result =  EmployeeSkillMetrics.getEmployeeInf(employeeList[0].Total_Experience__c , projectList[0].Id);
            System.debug('===79=====result===============>'+result);
            System.assertEquals(result[0].empName, 'Test', ' Employee Not Match with skill');

        }
        
        Test.stopTest();
    }
    
     @isTest
    private static void getEmployeeInfNegativeTest(){
        List<Employee__c> employeeList = [SELECT Id, Name, Total_Experience__c FROM Employee__c LIMIT 1];
        employeeList[0].Name = 'Jack';
        update employeeList;
        employeeList[0].Total_Experience__c = null;
        update employeeList;
        List<Project__c> projectList = [SELECT Id, Name FROM project__c LIMIT 1];
        Test.startTest();
        List<EmployeeSkillMetrics.Demo>  result = new List<EmployeeSkillMetrics.Demo>();
        if(!employeeList.isEmpty() && !projectList.isEmpty()){
           result =  EmployeeSkillMetrics.getEmployeeInf(employeeList[0].Total_Experience__c , projectList[0].Name);
        }
        System.assertNotEquals(result[0].empName, 'Test', ' Employee Match with skill');

        Test.stopTest();
    }
    
      @isTest
    private static void employeeSkillsPackagePositiveTest(){
        List<Employee__c> employeeList = [SELECT Id, Total_Experience__c FROM Employee__c LIMIT 1];
        List<Project__c> projectList = [SELECT Id, Name FROM project__c LIMIT 1];
        Test.startTest();
        if(!employeeList.isEmpty() && !projectList.isEmpty()){
            EmployeeSkillMetrics.employeeSkillsPackage(employeeList[0].Total_Experience__c , projectList[0].Id);
        }
        Test.stopTest();
    }
    
      @isTest
    private static void getProjectNamePositiveTest(){
        List<Employee__c> employeeList = [SELECT Id, Total_Experience__c FROM Employee__c LIMIT 1];
        List<Project__c> projectList = [SELECT Id, Name FROM project__c LIMIT 1];
        Test.startTest();
        if(!employeeList.isEmpty() && !projectList.isEmpty()){
            EmployeeSkillMetrics.getProjectName();
        }
        
        Test.stopTest();
    }
    
      @isTest
    private static void getProjectNameNegativeTest(){
        List<Employee__c> employeeList = [SELECT Id, Total_Experience__c FROM Employee__c LIMIT 1];
        List<Project__c> projectList = [SELECT Id, Name FROM project__c LIMIT 1];
        Test.startTest();
       // delete projectList;
         EmployeeSkillMetrics.getProjectName();
         Test.stopTest();
    }
    
}