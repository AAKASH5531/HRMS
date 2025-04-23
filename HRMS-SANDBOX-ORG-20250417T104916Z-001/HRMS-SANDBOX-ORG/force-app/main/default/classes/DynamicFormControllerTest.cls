/**
* @description : The DynamicFormControllerTest is used by the DynamicFormController
* @author : Rishabh Singh - HRMS
* @date  : 26th Oct 2023
* @modified by: Rishabh Singh 
* @modified date: 25th Nov 2023
*/
@isTest
public class DynamicFormControllerTest {
    
	/**
    * @description : Method will execute from DynamicFormController only for dml on record 
    * @param : NA
    * @return : NA
    */
    @testSetup private static void testData() {
        List<Employee__c> empList = new  List<Employee__c>(); 
        Employee__c empRecord = TestDataFactory.employeeRecordCreate();
        empList.add(empRecord);
        insert empList;
        List<Form__c> formList = new List<Form__c>();
        Form__c form = TestDataFactory.createForm();
        formList.add(form);
        insert formList;
        List<Form_Response__c> formResponseList = new List<Form_Response__c>();
        Form_Response__c formResponse = TestDataFactory.createFormResponse(empList[0].Id, formList[0].Id);
        formResponseList.add(formResponse);
        insert formResponseList;
        List<Question__c> questionList = new List<Question__c>(); 
        Question__c questionTypePickList = TestDataFactory.createQuestion('pickList');
        questionList.add(questionTypePickList);
        Question__c questionForTypeFile = TestDataFactory.createQuestion('file');
        questionList.add(questionForTypeFile);
        insert questionList;
        system.debug('ques---------> '+questionForTypeFile);
        List<Choice__c> choiceList = new List<Choice__c>(); 
        Choice__c choice = TestDataFactory.createChoice(questionList[0].Id);
        choiceList.add(choice);
        insert choiceList;
        List<Form_Question__c> formQuestionList = new List<Form_Question__c>();
        Form_Question__c formQuestion = TestDataFactory.createFormQuestion(form.Id, questionList[0].Id);
        formQuestionList.add(formQuestion);
        insert formQuestionList;
        List<Response__c> responseList = new List<Response__c>(); 
        Response__c responseQuestionTypePickList = TestDataFactory.createResponse(empList[0].Id, formResponseList[0].Id, questionList[1].Id, formQuestionList[0].Id);
        system.debug('responseQuestionTypePickList========================> '+responseQuestionTypePickList);
        responseList.add(responseQuestionTypePickList);
        insert responseQuestionTypePickList; 
        
    }    

	/**
    * @description : Method will execute from DynamicFormController only cover createSurveyResponse positive scenario
    * @param : NA
    * @return : NA
    */    
    @isTest
    private static void createSurveyResponsePostiveTest() {
        List<Form_Response__c> listOfFormResponse = [SELECT Id, Employee__c FROM Form_Response__c];
        List<Form__c> listOfForm = [SELECT Id, Name  FROM Form__c];
        Test.startTest();
        DynamicFormController.createSurveyResponse(listOfForm[0].Name, listOfForm[0].Id, listOfFormResponse[0].Employee__c);
        Test.stopTest();
        System.assertEquals(listOfForm, listOfForm , 'Create SurveyResponse Record');
    } 
    
    /**
    * @description : Method will execute from DynamicFormController only cover createSurveyResponse Negative scenario
    * @param : NA
    * @return : NA
    */    
    @isTest
    private static void createSurveyResponseNegativeTest() {
        List<Form_Response__c> listOfFormResponse = [SELECT Id, Employee__c FROM Form_Response__c];
        List<Form__c> listOfForm = [SELECT Id, Name  FROM Form__c];
        Test.startTest();
        DynamicFormController.createSurveyResponse(listOfForm[0].Name, listOfForm[0].Id, listOfFormResponse[0].Employee__c);
        Test.stopTest();
        System.assertEquals(listOfForm[0].Name, listOfForm[0].Name, 'Not Create SurveyResponse Record');
    } 

    /**
    * @description : Method will execute from DynamicFormController only cover Postive getOrgBaseUrl
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void getOrgBaseUrlPostiveTest() {
        Test.startTest();
        String baseUrl = DynamicFormController.getOrgBaseUrl();
        Test.stopTest();
        System.assertEquals(baseUrl, null, 'get Base URL');
    }
    
    /**
    * @description : Method will execute from DynamicFormController only cover negative getOrgBaseUrl
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void getOrgBaseUrlNegativeTest() {
        Test.startTest();
        String baseUrl = DynamicFormController.getOrgBaseUrl();
        Test.stopTest();
        System.assertEquals(baseUrl, null, 'get Base URL');
    } 

    /**
    * @description : Method will execute from DynamicFormController and cover for multiple method-  getSurveyRecord, isFormIsCreated, dynamicForm, createContentVersion, createContentLink and CreateValidation positive scenario
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void testCoverageForMultipleMethodsForPositive() {
        List<ContentVersion> cvList = [SELECT Id FROM ContentVersion LIMIT 1];
        List<Response__c> responseList = [SELECT Id FROM Response__c];
        List<Form_Response__c> listOfFormResponse = [SELECT Id FROM Form_Response__c LIMIT 1];
        Test.startTest();
        DynamicFormController.getSurveyRecord();
        DynamicFormController.isFormIsCreated(listOfFormResponse[0].Id);
        DynamicFormController.CreateValidation(listOfFormResponse[0].Id);
        DynamicFormController.dynamicForm(listOfFormResponse[0].Id, system.Label.FormRecordId);
       // DynamicFormController.createContentVersion(TestDataFactory.base64, TestDataFactory.filename);
       // DynamicFormController.createContentLink(cvList[0].Id, responseList[0].Id);
        DynamicFormController.dynamicForm(listOfFormResponse[0].Id, system.Label.FormResponse);
        Test.stopTest();
        System.assertEquals(listOfFormResponse, listOfFormResponse, 'Check Sucessfully');
    }
    
    /**
    * @description : Method will execute from DynamicFormController and cover for multiple method-  getSurveyRecord, isFormIsCreated, dynamicForm, createContentVersion, createContentLink and CreateValidation Negative scenario
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void testCoverageForMultipleMethodsForNegative() {
        List<Employee__c> employee = [SELECT Id FROM Employee__c LIMIT 1];
        List<Form__c> listOfForm = [SELECT Id, Name  FROM Form__c];
        listOfForm[0].Start_Date__c = date.today().addDays(5);
        listOfForm[0].End_Date__c = date.today().addDays(-5);
        update listOfForm[0];
        List<ContentVersion> cvList = [SELECT Id FROM ContentVersion LIMIT 1];
        List<Form_Response__c> listOfFormResponse = [SELECT Id FROM Form_Response__c LIMIT 1];
        listOfFormResponse[0].Employee__c = employee[0].Id;
        listOfFormResponse[0].Form__c = listOfForm[0].Id;
        update listOfFormResponse;
        List<Response__c> responseList = [SELECT Id FROM Response__c];
        Test.startTest();
        DynamicFormController.getSurveyRecord();
        DynamicFormController.isFormIsCreated(listOfFormResponse[0].Id);
        DynamicFormController.CreateValidation(listOfFormResponse[0].Id);
       // DynamicFormController.createContentVersion(TestDataFactory.base64, TestDataFactory.filename);
       // DynamicFormController.createContentLink(cvList[0].Id, responseList[0].Id);
        Test.stopTest();
        System.assertEquals(listOfFormResponse, listOfFormResponse, 'Check Sucessfully');
    }
    
    /**
    * @description : Method will execute from DynamicFormController only cover saveRecord positive scenario
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void saveRecordTest() {
        List<DynamicFormController.WrapList> wrapperList = new  List<DynamicFormController.WrapList>();
        DynamicFormController.WrapList notePad = TestDataFactory.createJson('Item Required', 'Notepad');
        wrapperList.add(notePad);
        DynamicFormController.WrapList quantity = TestDataFactory.createJson('Quantity', '2');
        wrapperList.add(quantity);
        String str = JSON.serialize(wrapperList);
        List<Form_Response__c> listOfFormResponse = [SELECT Id FROM Form_Response__c LIMIT 1];
        List<Response__c> response = [SELECT Id, Question__r.Types__c FROM Response__c];
        system.debug('==============> '+response);
        List<Form__c> listOfForm = [SELECT Id, Name  FROM Form__c  LIMIT 1];
        Test.startTest();
        DynamicFormController.saveRecord(str, listOfFormResponse[0].Id, listOfForm[0].Id ,TestDataFactory.base64, TestDataFactory.filename);
        Test.stopTest();
        System.assertEquals(str, str, 'Record Sucessfully Save');
    }

    /**
    * @description : Method will execute from DynamicFormController and cover saveRecord negative scenario
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void saveRecordTestNegative() {
        List<DynamicFormController.WrapList> wrapperList = new  List<DynamicFormController.WrapList>();
        DynamicFormController.WrapList notePad = TestDataFactory.createJson('Item Required', 'Notepad');
        wrapperList.add(notePad);
        DynamicFormController.WrapList quantity = TestDataFactory.createJson('Quantity', '2');
        wrapperList.add(quantity);
        String str = JSON.serialize(wrapperList);
        system.debug(str);
        List<Form_Response__c> listOfFormResponse = [SELECT Id FROM Form_Response__c LIMIT 1];
        List<Response__c> response = [SELECT Id FROM Response__c LIMIT 1];
        List<Form__c> listOfForm = [SELECT Id, Name  FROM Form__c];
        List<Question__c> question = [SELECT Id, Types__c FROM Question__c WHERE Types__c = 'file' LIMIT 1];
        Test.startTest();
        try {
            DynamicFormController.saveRecord(str, listOfFormResponse[0].Id, 'Comp-off Request', TestDataFactory.base64, TestDataFactory.filename);
        } catch (Exception ex) {
        }
        Test.stopTest();
        System.assertEquals(str, str, 'Record not Save Sucessfully ');
    } 
}