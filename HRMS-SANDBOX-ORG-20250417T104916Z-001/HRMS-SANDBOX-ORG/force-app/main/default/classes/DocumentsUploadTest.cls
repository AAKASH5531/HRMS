/**
* @description : The DocumentsUploadTest is used by the DocumentsUpload
* @author : Aakash Mathur - HRMS
* @date  : 07/11/2023,
* @modified by : Aakash Mathur
* @modified date : 25/11/2023,
*/
 @isTest 
 private class DocumentsUploadTest {
    
    /** 
    * @description : Method will execute from TestDataFactory only Create Test record
    * @param : NA
    * @return : NA
    */
    @testSetup 
    private static void createDocumentsUploade() {
    List<Employee__c> employeeList = new List<Employee__c>();
    List<ContentVersion> cvList = new List<ContentVersion>();
    List<Employee_Document__c> empDocList = new List<Employee_Document__c> ();
    List<ContentDocumentLink> conDocList =  new List<ContentDocumentLink>();
    Employee__c empRec = TestDataFactory.employeeRecordCreate();
    employeeList.add(empRec);
    insert employeeList; // Don't make DML without any check point
    ContentVersion cv = TestDataFactory.createContentVersion(); 
    cvList.add(cv);
    insert cvList;// Don't make DML without any check point
    Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
    Employee_Document__c empdoc = TestDataFactory.employeeDocumentRecord(employeeList[0].Id) ;
    empDocList.add(empdoc);
    insert empDocList;  // Don't make DML without any check point
    ContentDocumentLink conLink =  TestDataFactory.ContentDocumentLink(conDocId, empDocList[0].Id);
    conDocList.add(conLink);
    insert conDocList;  // Don't make DML without any check point
    }
  
     /**
    * @description : Method will execute from DocumentsUpload  Cover saveFiles Postive Scenario 
    * @param : NA
    * @return : NA
    */    
     @IsTest
    private static void saveFilesTest(){
        List<ContentVersion> contentVersionRec = [SELECT Id, Title, VersionData FROM ContentVersion]; // Avoid alone query without any condition also include LIMIT.
        List<Employee_Document__c> empdoc = [SELECT Id FROM Employee_Document__c]; // Avoid alone query without any condition also include LIMIT.
        Test.startTest();
        String cdlId = DocumentsUpload.saveFiles(TestDataFactory.base64, contentVersionRec[0].Title, empdoc[0].Id);   // variable name should be meaningful.
        List<ContentDocumentLink> cdl = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE Id = :cdlId];  // variable name should be meaningful.
        DocumentsUpload.saveNonAttestedFile(TestDataFactory.base64, contentVersionRec[0].Title, empdoc[0].Id);
        Test.stopTest();
        System.assertEquals(empdoc[0].Id, cdl[0].LinkedEntityId, 'The linked entity id should match the employee document id');
    }
    
    /**
    * @description : Method will execute from DocumentsUpload Cover saveFiles Negative Scenario 
    * @param : NA
    * @return : NA
    */
     @IsTest
    private static void saveFilesNegativeTest(){
        List<ContentVersion> contentVersionRec = [SELECT Id, Title, VersionData FROM ContentVersion ]; // Avoid alone query without any condition also include LIMIT.
        List<Employee_Document__c> empdoc = [SELECT Id FROM Employee_Document__c ]; // Avoid alone query without any condition also include LIMIT.
        Test.startTest();
        String cdlId = DocumentsUpload.saveFiles(TestDataFactory.base64, contentVersionRec[0].Title, empdoc[0].Id); 
        ContentDocumentLink cdl = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE Id  =:cdlId];  // variable name should be meaningful.
        DocumentsUpload.saveNonAttestedFile(TestDataFactory.base64, contentVersionRec[0].Title, empdoc[0].Id);
        Test.stopTest();
        System.assertNotEquals(null, cdlId, 'The content document link id should not be null');
    }
}