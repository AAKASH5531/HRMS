/**
* @description : EmployeeIdCardTest is responsible to test EmployeeIdCard class
* @author : Aakash Mathur - HRMS
* @Created Date  : 1th Oct 2023
* @modified by : Aakash Mathur 
* @modified date : 27th Nov 2023
*/
@IsTest
private class EmployeeIdCardTest {

    /** 
    * @description : Method will execute from TestDataFactory only Create Test record
    * @param : NA
    * @author : Aakash Mathur - HRMS
    * @return : NA
    */
    @testSetup 
    private static void insertRecordTest(){
        List<Employee__c> employeeList = new List<Employee__c>();
        List<ContentVersion> cvList = new List<ContentVersion>(); // Variable name need to littile more meaningful.
        List<Employee_Document__c> empdocList  = new List<Employee_Document__c>();
        List<ContentDocumentLink> cdlList   = new List<ContentDocumentLink>(); // Variable name need to littile more meaningful.
        Employee__c parentEmp = TestDataFactory.employeeRecordCreate();
        employeeList.add(parentEmp);
        insert employeeList; // Without null check don't make any DML.
        ContentVersion cv = TestDataFactory.createContentVersion(); 
        cvList.add(cv);
        insert cvList; // Without null check don't make any DML.
        List<ContentVersion> conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id];
        Employee_Document__c empdocRec = TestDataFactory.employeeDocumentRecord(parentEmp.Id);
        empdocList.add(empdocRec);
        insert empdocList; // Without null check don't make any DML.
        ContentDocumentLink conLink =  TestDataFactory.ContentDocumentLink(conDocId[0].ContentDocumentId, empdocList[0].Id);
        cdlList.add(conLink);
        insert cdlList; // Without null check don't make any DML.
    }
   
    /**
    * @description : Method will execute from EmployeeIdCard  Cover getEmployeeInfo Postive Scenario 
    * @param : NA
    * @author :Aakash Mathur - HRMS
    * @return : NA
    */   
    @IsTest
    private static void getEmployeeInfoTest(){
        List<Employee__c> employeeList = [SELECT Id, Name, Date_of_Joining__c FROM Employee__c LIMIT 1]; // This is not the right way of writing independent query.
        List<Employee_Document__c> empDocList = [SELECT Id FROM Employee_Document__c LIMIT 1];  // This is not the right way of writing independent query.
        List<ContentVersion> contVersionList = [SELECT Id, ContentDocumentId FROM ContentVersion ]; // This is not the right way of writing independent query.
        ContentDocumentLink cdl = new ContentDocumentLink(); // Variable name need to littile more meaningful.
        cdl.ContentDocumentId = contVersionList[0].ContentDocumentId;
        cdl.LinkedEntityId = empDocList[0].Id;
        insert cdl;
        String joiningDate;
        List <String> splitDate = String.valueOf(date.today()).split('-');
        if (!splitDate.isEmpty()) {
            joiningDate = splitDate[2] + '/' + splitDate[1] + '/' + splitDate[0];
        }
        Test.startTest();
        List<EmployeeIdCard.GetEmployeeDto> getEmployeeDto = EmployeeIdCard.getEmployeeInfo(employeeList[0].Id);
        Test.stopTest();
        System.assertEquals( getEmployeeDto[0].joiningDate, joiningDate, 'joining Date is not match');
    }
        
    /**
    * @description : Method will execute from EmployeeIdCard  Cover getEmployeeInfo Negative Scenario 
    * @param : NA
    * @return : NA
    */     
    @IsTest
    private static void getEmployeeInfoNegativeTest(){
        Test.startTest();
        List<EmployeeIdCard.GetEmployeeDto> getEmployeeDto = EmployeeIdCard.getEmployeeInfo(null);
        Test.stopTest();
        System.assertEquals(getEmployeeDto, null, 'joining Date is match' );
    }
}