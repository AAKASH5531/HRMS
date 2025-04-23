/**
* @description : The UpdateEmployeeDocumentTest is used by the UpdateEmployeeDocument
* @author : Aakash Mathur - HRMS
* @date  : 07/11/2023,
* @modified by: Aakash Mathur
* @modified date:25/11/2023,
*/

@isTest
public class UpdateEmployeeDocumentTest {
          
   /** 
    * @description : Method will execute from TestDataFactory only Create Test record
    * @param : NA
    * @return : NA
    */ 
    @testSetup 
    public Static void createTesData(){
        List<Employee__c> employeeList = new List<Employee__c>();
        List<ContentVersion> cvList = new List<ContentVersion>();
        List<Employee_Document__c> empdocList  = new List<Employee_Document__c>();
        List<ContentDocumentLink> cdlList   = new List<ContentDocumentLink>();
        Employee__c empRec = TestDataFactory.employeeRecordCreate();
        employeeList.add(empRec);
        insert employeeList; // Make DML after null check
        for(Integer i = 0 ; i<2 ; i ++){
            ContentVersion cv = TestDataFactory.createContentVersion(); 
           cvList.add(cv);
        }
       insert cvList; // Make DML after null check
       List<ContentVersion> conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN : cvList];
        Employee_Document__c empdoc = TestDataFactory.employeeDocumentRecord(employeeList[0].Id);
        empdocList.add(empdoc);
        insert empdocList;  // Make DML after null check
        for( ContentVersion cvRec : conDocId ){
           ContentDocumentLink conLink =  TestDataFactory.ContentDocumentLink(cvRec.ContentDocumentId, empdocList[0].Id);
           cdlList.add(conLink); 
        }
        insert cdlList; // Make DML after null check
    }
    
    /*
    * @description : Method will execute from UpdateEmployeeDocument  Cover updateFileOnDrive Postive Scenario 
    * @param : NA
    * @return : NA
    */ 
    @isTest
    private static void updateFileOnDriveTest(){
        //Variable name will be more detailed
        List<ContentVersion> cvData = [SELECT Id, RecordTypeId, VersionData, PathOnClient, recordtype.developerName, Title FROM ContentVersion]; // Avoid Independent query.
        Map<Object, Object> mockUploadedFile = new Map<Object, Object>{'base64' => EncodingUtil.base64Encode(cvData[0].VersionData),'filename' => cvData[0].PathOnClient,'mimeType' => 'application/pdf'};
        Map<String, Object> mockCheckedFieldObject = new Map<String, Object>{'Employee_Docs__c' => true,'Company_Docs__c' => false};  
        List<Employee_Document__c> empdoc = [SELECT Id From Employee_Document__c]; // Avoid Independent query.
        Test.setMock(HttpCalloutMock.class, new UploadDocumentsOnGDriveMock());
        Test.startTest();
        //Variable name will be more detailed
        Boolean result = UpdateEmployeeDocument.calloutForUpload(TestDataFactory.base64, TestDataFactory.filename, TestDataFactory.folderId, TestDataFactory.mimeType, empdoc[0].Id,'Employee_Docs');
        Map<String,String> resultMap =   UpdateEmployeeDocument.updateRecordFiles(empdoc[0].Id, mockUploadedFile, 'Employee_Docs');
        Boolean resultTest = resultMap.get('title').contains('Employee_Docs');        
        Test.StopTest();
        System.assertEquals(result, true, 'The file is not updated successfully');
    }
        
    /*
    * @description : Method will execute from UpdateEmployeeDocument Cover updateFileOnDrive Negative Scenario 
    * @param : NA
    * @return : NA
    */   
    @isTest
    private static void updateFileOnDriveNegativeTest(){
        //Variable name will be more detailed
        List<ContentVersion> cvData = [SELECT Id, RecordTypeId, VersionData, PathOnClient, recordtype.developerName, Title FROM ContentVersion]; // Avoid Independent query.
        Map<Object, Object> mockUploadedFile = new Map<Object, Object>{'base64' => EncodingUtil.base64Encode(cvData[0].VersionData),'filename' => cvData[0].PathOnClient,'mimeType' => 'application/pdf'};
        Map<String, Object> mockCheckedFieldObject = new Map<String, Object>{'Employee_Docs__c' => true,'Company_Docs__c' => false};   
        List<Employee_Document__c> empdocList = [SELECT Id From Employee_Document__c]; // Avoid Independent query.
        Test.setMock(HttpCalloutMock.class, new GoogleCalendarMock());
        Test.startTest();
        UpdateEmployeeDocument.getFieldLabelName();
        //Variable name will be more detailed
        Boolean result = UpdateEmployeeDocument.calloutForUpload(TestDataFactory.base64, TestDataFactory.filename, TestDataFactory.folderId, TestDataFactory.mimeType, empdocList[0].Id,'Employee_Docs');
        Map<String,String> resultMap =   UpdateEmployeeDocument.updateRecordFiles(empdocList[0].Id, mockUploadedFile, 'Company_Docs__c');
        Boolean resultTest = resultMap.get('title').contains('Employee_Docs');
        Test.StopTest();
        System.assertEquals(resultTest, false, 'The file is not updated successfully');
    }

    /*
    * @description : Create a mock class to simulate the callout to Google Calendar API
    * @param : NA
    * @author :Aakash Mathur - HRMS
    * @return : HTTPResponse
    */
    public class GoogleCalendarMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse(); //Variable name will be more detailed
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id": "test-event-id", "status": "confirmed"}');
            res.setStatusCode(400);
            return res;
        }
    }
}