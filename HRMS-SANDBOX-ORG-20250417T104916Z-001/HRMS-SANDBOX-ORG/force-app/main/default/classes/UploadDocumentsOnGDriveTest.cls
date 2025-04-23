/**
* @description : UploadDocumentsOnGDriveTest is responsible to test  UploadDocumentsOnGDrive class
* @author : Aakash Mathur - HRMS
* @date  : 1th Oct 2023
* @modified by: Aakash Mathur 
* @modified date : 24th Nov 2023
*/
@isTest
private class UploadDocumentsOnGDriveTest {        
    
    /** 
    * @description : Method will execute from UploadDocumentsOnGDrive Cover uploadFileOnDrive Postive Scenario 
    * @param : NA
    * @return : NA
    */
   @isTest
    private static void uploadFileOnDriveTest(){
        List<Employee__c> employeeList = new List<Employee__c>();
        List<ContentVersion> cvList = new List<ContentVersion>();
        List<Employee_Document__c> empdocList  = new List<Employee_Document__c>();
        List<ContentDocumentLink> cdlList   = new List<ContentDocumentLink>(); // variable name should be more clear
        Employee__c parentEmp = TestDataFactory.employeeRecordCreate(); 
        parentEmp.Company_Docs_FolderID__c = '';
        parentEmp.Employee_Docs_FolderId__c = '';
        parentEmp.Google_Drive_Parent_Folder_ID__c = '1m7Hoq9UBQwYNjbHFoDGWJiiySAISMOLO';
        employeeList.add(parentEmp);
        insert employeeList; // Don't make DML without null check.
        for(Integer i = 0 ; i<2 ; i++){
          ContentVersion cv = TestDataFactory.createContentVersion(); 
          cvList.add(cv);
        }
        insert cvList; // Don't make DML without null check.
        List<ContentVersion> conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN : cvList];
        Employee_Document__c empdocRec = TestDataFactory.employeeDocumentRecord(employeeList[0].Id);
        empdocList.add(empdocRec);
        insert empdocList;  // Don't make DML without null check.
        for( ContentVersion cv : conDocId ){
           ContentDocumentLink conLink =  TestDataFactory.ContentDocumentLink(cv.ContentDocumentId, empdocList[0].Id);
           cdlList.add(conLink); 
        }
        insert cdlList; // Don't make DML without null check.
        Test.setMock(HttpCalloutMock.class, new UploadDocumentsOnGDriveMock());
        Test.startTest();
        String result = UploadDocumentsOnGDrive.uploadFileOnDrive(empdocList[0].Id);
        Test.StopTest();
        System.assertEquals(result, 'not uploaded', 'The file is not updated successfully');
    }
   
   /**
    * @description : Method will execute from UploadDocumentsOnGDrive Cover uploadFile On Drive Negative Scenario 
    * @param : NA
    * @return : NA
    */ 
    @isTest
        private static void uploadFileOnDriveTestNegative(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new UploadDocumentsOnGDriveMock());
        String response = UploadDocumentsOnGDrive.createSubFolder(TestDataFactory.fileName,TestDataFactory.folderId);
        Test.StopTest(); 
        System.assertEquals(response, null, 'The file is not updated successfully');
    }
}