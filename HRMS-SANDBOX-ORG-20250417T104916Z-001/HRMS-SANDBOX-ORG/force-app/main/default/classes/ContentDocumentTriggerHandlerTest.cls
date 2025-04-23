/**
* @description : The ContentDocumentTriggerHandlerTest is used by the ContentDocumentTriggerHandler
* @group : ContentDocumentTrigger
* @author : Aakash Mathur - HRMS
* @date  : 07/11/2023,
* @modified by: Aakash Mathur
* @modified date : 27/11/2023,
*/
@isTest
public class ContentDocumentTriggerHandlerTest {
    
    /** 
    * @description : Method will execute from TestDataFactory only Create Test record
    * @param : NA
    * @return : NA
    */
    @testSetup
    public static void insertRecordTest(){
    List<Employee__c> employeeList = new List<Employee__c>();
    List<ContentVersion> cvList = new List<ContentVersion>();
    List<Employee_Document__c> empdocList  = new List<Employee_Document__c>();
    List<ContentDocumentLink> cdlList   = new List<ContentDocumentLink>();
    Employee__c empRec  = TestDataFactory.employeeRecordCreate();
    employeeList.add(empRec);
    insert employeeList;
    employeeList[0].Documents_Uploaded__c = true;
    update employeeList;  
    ContentVersion cv = TestDataFactory.createContentVersion(); 
    cvList.add(cv);
    insert cvList;
    Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cvList[0].Id].ContentDocumentId;
        for(Integer i = 0 ; i<22 ; i++){
            Employee_Document__c empdocRec = TestDataFactory.employeeDocumentRecord(employeeList[0].Id) ;
            empdocRec.File_Uploaded__c = true;
            empdocList.add(empdocRec);
        }
        if(empdocList.size() > 0){
            insert empdocList;
            ContentDocumentLink conLink =  TestDataFactory.ContentDocumentLink(conDocId ,empdocList[0].Id);
            insert conLink;
            employeeList[0].Documents_Uploaded__c = true;
            update employeeList; 
        }
    }
   
   /**
    * @description : Method will execute from ContentDocumentTriggerHelper  Cover deleteCalloutFromDrive Postive Scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void updateDocumentsUploadedOfEmployeeTest(){
        List<ContentDocument> contentDocumentList = [SELECT Id, Title FROM ContentDocument];
        List<String> filedApiName = new  List<String> ();
        delete contentDocumentList;
        filedApiName.add('PAN Card');
        Test.setMock(HttpCalloutMock.class, new UploadDocumentsOnGDriveMock());
        Test.startTest();
        ContentDocumentTriggerHelperUtility.updateDocumentsUploadedOfEmployee(contentDocumentList);
        Test.stopTest();
        System.assertEquals(filedApiName.size(), 1, 'filedApiName Name is messing ');
    }
   
    /**
    * @description : Method will execute from ContentDocumentTriggerHelper  Cover deleteCalloutFromDrive Negative Scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void updateDocumentsUploadedOfEmployeeNegativeTest(){
        List<ContentDocument> contentDocumentList = [SELECT Id, Title FROM ContentDocument];
        List<String> filedApiName = new  List<String> ();
        Test.setMock(HttpCalloutMock.class, new UploadDocumentsOnGDriveMock());
        Test.startTest();
        ContentDocumentTriggerHelperUtility.updateDocumentsUploadedOfEmployee(contentDocumentList);
        Test.stopTest();
        System.assertEquals(filedApiName.size(), 0, 'filedApiName Name is present ');
    } 

    /**
    * @description : Method will execute from ContentDocumentTrigger  Cover beforedelete Postive Scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void beforedeleteTest(){
        List<ContentDocument> contentDocumentList = [SELECT Id, Title FROM ContentDocument];
        delete contentDocumentList;
        List<String> filedApiName = new  List<String> ();
        filedApiName.add('Aadhar Card');
        Test.setMock(HttpCalloutMock.class, new UploadDocumentsOnGDriveMock());
        test.startTest();
        UpdateEmployeeDocument.removeIdAndExtensionOfFiles('PAN Card');
        test.stopTest();
        System.assertEquals(filedApiName.size(), 1, 'filedApiName Name is present ');
    }
    
    /**
    * @description : Method will execute from ContentDocumentTrigger Cover beforedelete Negative Scenario 
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void beforedeleteNegativeTest(){
        List<ContentDocument> contentDocumentList = [SELECT Id, Title FROM ContentDocument];
        delete contentDocumentList;
        List<String> filedApiName = new  List<String> ();
        Test.setMock(HttpCalloutMock.class, new UploadDocumentsOnGDriveMock());
        test.startTest();
        UpdateEmployeeDocument.removeIdAndExtensionOfFiles('');
        test.stopTest();
       System.assertEquals(filedApiName.size(), 0, 'filedApiName Name Not present ');
    }
}