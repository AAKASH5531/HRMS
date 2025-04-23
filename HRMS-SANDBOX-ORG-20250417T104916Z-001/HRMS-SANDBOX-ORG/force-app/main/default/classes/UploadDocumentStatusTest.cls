/**
* @description : The UploadDocumentStatusTest is used by the UploadDocumentStatus
* @group : UploadDocumentStatus
* @author : Aakash Mathur - HRMS
* @date  : 07/11/2023,
* @modified by: Aakash Mathur
* @modified date:07/11/2023,
*/
@isTest
public class UploadDocumentStatusTest {
        
    /**
    * @description : Method will execute from UploadDocumentStatus to create test Data
    * @param : NA
    * @author : Aakash Mathur - HRMS
    * @return : NA
    */
     @testSetup public static void insertRecordTest(){
        List<Employee__c> employeeList = new List<Employee__c>();
        List<ContentVersion> cvList = new List<ContentVersion>();
        List<Employee_Document__c> empdocList  = new List<Employee_Document__c>();
        List<ContentDocumentLink> cdlList   = new List<ContentDocumentLink>();
        Employee__c empRec = TestDataFactory.employeeRecordCreate();
        employeeList.add(empRec);
        insert employeeList;
        ContentVersion cv = TestDataFactory.createContentVersion();
        cvList.add(cv);
        insert cvList;
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cvList[0].Id].ContentDocumentId;
        Employee_Document__c empdocRec = TestDataFactory.employeeDocumentRecord(employeeList[0].Id) ;
        empdocList.add(empdocRec);
        insert empdocList;
        ContentDocumentLink conLink =  TestDataFactory.ContentDocumentLink(conDocId, empdocList[0].Id);
        cdlList.add(conLink);
        insert cdlList ;
    }
        
    /**
    * @description : Method will execute from UploadDocumentStatus  Cover uploadDocumentStatusTest Positive Scenario 
    * @param : NA
    * @author : Aakash Mathur - HRMS
    * @return : NA
    */

    @isTest
    private static void getSObjectRecordIdTest(){
        List<UploadDocumentStatus.FileInformation> fileInformationList = new  List<UploadDocumentStatus.FileInformation>();
        List<Employee__c> empList = [SELECT Id, Name FROM Employee__c];
        Test.setMock(HttpCalloutMock.class, new UploadDocumentsOnGDriveMock());
        test.startTest();
        fileInformationList = UploadDocumentStatus.getSObjectRecordId(empList[0].Id);
        test.stopTest();
        System.assertEquals( fileInformationList[0].objectName, 'Employee__c', 'filedApiName Name is present ');
    }
   
    /**
    * @description : Method will execute from uploadDocumentStatus Cover uploadDocumentStatus Negative Scenario 
    * @param : NA
    * @author : Aakash Mathur - HRMS
    * @return : NA
    */   

    @isTest
    private static void getSObjectRecordIdNegativeTest(){
        List<Employee_Document__c> empDocList = [SELECT Id, Name FROM Employee_Document__c];
        List<UploadDocumentStatus.FileInformation> fileInformationList = new  List<UploadDocumentStatus.FileInformation>();
        test.startTest();
        fileInformationList = UploadDocumentStatus.getSObjectRecordId(empDocList[0].Id);
        test.stopTest();
        System.assertEquals( fileInformationList[0].objectName, 'Employee_Document__c', 'filedApiName Name is present ');
    } 
}