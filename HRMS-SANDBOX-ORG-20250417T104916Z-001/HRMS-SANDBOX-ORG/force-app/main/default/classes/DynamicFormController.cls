/**
* @description : The handler is used by the lightning web components surveyForm
* @group : dynamicForm ,surveyForm
* @author : Rishabh Singh - HRMS
* @date  : 26th Oct 2023
* @modified by: Rishabh Singh
* @modified date: 02th Nov 2023
*/
public without sharing class DynamicFormController {

    /**
    * @description : Method will execute from DynamicForm only show the active survey on UI
    * @param : NA
    * @return : List of surveyList
    */
    @AuraEnabled(cacheable = true)
    public Static List<Options> getSurveyRecord(){
        try{
                List<Options> optionsList = new  List<Options>();
                List<Form__c> surveyList = [SELECT Id, Name, IsActive__c From Form__c WHERE IsActive__c = true AND IS_Raise_a_Request__c = false];
                if(!surveyList.isEmpty()){
                    for(Form__c form : surveyList){
                        Options options = new Options();
                        options.label = form.Name;
                        options.value = form.Id;
                        optionsList.add(options);
                    }
                    return optionsList;
                }
        }
        catch(Exception ex){
             throw new AuraHandledException(ex.getMessage());
        }  
        return null;
    }
        
    /**
    * @description : Method will execute from surveyForm only show Valdation on UI
    * @param : String recordId - Contains recordId from  Survey Response 
    * @return : Boolean Value -(true or false)
    */
    @AuraEnabled
    public static Boolean isFormIsCreated(String recordId ){
        try{
            List<Response__c> responseList = [SELECT Form_Response__c FROM Response__c WHERE Form_Response__c =:recordId];

            if(responseList.size() > 0){
                return true;
            }
            else{
                return false;
            }  
        }
        catch(Exception ex){
             throw new AuraHandledException(ex.getMessage());
        }  
        
    }

    /**
    * @description : Method will execute from surveyForm only show Valdation on UI
    * @param : String recordId - Contains recordId from  Survey Response 
    * @return : List of List<SurveyDetails> 
    */
    @AuraEnabled
    public static List<SurveyDetails> createValidation(String recordId ){
        try{
            List<Form_Response__c> surveyList = [SELECT Id, Form__r.Id, Form__r.Start_Date__c, Form__r.End_Date__c,
                                                Form__r.Name FROM Form_Response__c WHERE Id =:recordId];
            
            List<SurveyDetails> surveyLists = new List<SurveyDetails>();
            if(!surveyList.isEmpty()){
                Datetime currentDateTime = System.now();
                boolean isStartDate = currentDateTime > surveyList[0].Form__r.Start_Date__c;
                boolean isEndDate = currentDateTime < surveyList[0].Form__r.End_Date__c;
                SurveyDetails obj = new SurveyDetails();
                if(!isStartDate){
                    obj.outOfDate = 'Start Date';
                }
                if(!isEndDate){
                    obj.outOfDate = 'End Date';
                }
                if(isStartDate && isEndDate){
                    obj.isFormStatus = true;
                    obj.outOfDate = '';
                    obj.surveyStartDate = surveyList[0].Form__r.Start_Date__c;
                    obj.surveyEndDate = surveyList[0].Form__r.End_Date__c;
                }else{
                    obj.isFormStatus = false;
                    obj.surveyStartDate = surveyList[0].Form__r.Start_Date__c;
                    obj.surveyEndDate = surveyList[0].Form__r.End_Date__c;
                }
                surveyLists.add(obj);
            }
            return surveyLists;
        }
        catch(Exception ex){
             throw new AuraHandledException(ex.getMessage());
        }  
    }

    /**
    * @description : Method will execute from surveyForm only show form on UI
    * @param : String recordId , String url - Contains recordId from  Survey Response and Contains url from form 
    * @return : List of List<Questions> 
    */
    @AuraEnabled
    public static List<Questions> dynamicForm(String recordId, String url){
        try{
            String surveyId;
            if (recordId != null && url == system.Label.FormRecordId){
                surveyId = recordId;
            }
            if(recordId != null && url == system.Label.FormResponse){
                
                List<Form_Response__c> surveyList = [SELECT Id, Form__r.Id FROM Form_Response__c WHERE Id = :recordId];
                surveyId = surveyList[0].Form__r.Id;
            }
            if(recordId != null && url == ''){
                surveyId = recordId;
            }
            if((recordId == 'Comp-off Request' || recordId == 'Add Skills') && url == ''){
                List<Form__c> surveyList = [SELECT Id, Name FROM Form__c WHERE Name = :recordId];
                surveyId = surveyList[0].Id;
            }
            Set<Id> surveyQuestionId = new Set<Id>();
            List<Form_Question__c> surveyQuestionList = [SELECT Id, Form__r.Id, Form__r.Name, Question__c, Order__c From Form_Question__c 
                                                        WHERE Form__r.Id =:surveyId AND Question__r.IsActive__c = true 
                                                        ORDER BY Order__c ASC];
            for(Form_Question__c surQuestion : surveyQuestionList){
                surveyQuestionId.add(surQuestion.Question__c);
            }
            List<Questions>  questionList = new List<Questions>();
            for(Question__c surveyQuestionObj : [SELECT Id, Name, Types__c, Required__c, (SELECT Id,Name FROM Choice__r)
                                                 FROM Question__c WHERE Id IN: surveyQuestionId ORDER BY Order__c ASC]){
                List<Options> OptionsList = new List<Options>();
                Questions surveyQuestion = new Questions();
                surveyQuestion.surveyName = surveyQuestionList[0].Form__r.Name;
                surveyQuestion.questionName = surveyQuestionObj.Name;
                if(surveyQuestionObj.Types__c == 'Picklist' && surveyQuestionObj.Name != 'Add Additional Skills'){
                    surveyQuestion.pickVal = true;
                }
                if(surveyQuestionObj.Types__c == 'Multiselect'){
                    surveyQuestion.multiPickVal = true;
                }
                if(surveyQuestionObj.Types__c == 'Picklist' && surveyQuestionObj.Name == 'Add Additional Skills'){
                    surveyQuestion.addSkill = true;
                }
                 if(surveyQuestionObj.Types__c == 'Long Text' ){
                    surveyQuestion.isLongText = true;
                }
                surveyQuestion.questionType = surveyQuestionObj.Types__c;
                surveyQuestion.requiredQuestion = surveyQuestionObj.Required__c;
                questionList.add(surveyQuestion);
                for(Choice__c choiceObj : surveyQuestionObj.Choice__r){
                    Options optionWrapper = new Options ();
                    optionWrapper.label = choiceObj.Name;
                    optionWrapper.value = choiceObj.Name;
                    OptionsList.add(optionWrapper);
                }
                surveyQuestion.questionOptions = OptionsList;

                List<Employee__c> employeeList = [SELECT Id FROM Employee__c WHERE User_Associated__c =: UserInfo.getUserId()];
                if(!employeeList.isEmpty()){
                List<Comp_Off_Request__c> compList = [SELECT Id, Name, Date_Of_Comp_off_Request__c, Comp_Off_Leave_Status__c  
                                                                FROM Comp_Off_Request__c WHERE Comp_Off_Leave_Status__c ='Valid'
                                                                AND Employee_Name__c =:employeeList[0].Id ORDER BY Date_Of_Comp_off_Request__c ASC];
                    List<DateofComp> dateofCompList = new List<DateofComp>();
                    for(Comp_Off_Request__c comp : compList){
                        DateofComp dateofComp = new DateofComp();
                        dateofComp.label = comp.Date_Of_Comp_off_Request__c;
                        dateofComp.value = comp.Id;
                        dateofCompList.add(dateofComp);
                    }
                
                    surveyQuestion.dateOfCompoffRequest = dateofCompList;
                }
                List<Skills__c> skillList = [SELECT Id, NAME FROM Skills__c ];
                List<AddSkills> skillValueList = new List<AddSkills>();
                for(Skills__c skill : skillList){
                    AddSkills addSkill = new AddSkills();
                    addSkill.label = skill.NAME;
                    addSkill.value = skill.Id;
                    skillValueList.add(addSkill);
                }
                surveyQuestion.addSkills = skillValueList;

            }
            return  questionList ; 
        }
        catch(Exception ex){
             throw new AuraHandledException(ex.getMessage());
        }  
        
    }
    
    /**
    * @description : Method will execute from DynamicForm only create Survey_Response__c object record
    * @param : String surveyName ,  String surveyId ,  String employeeId - Contains surveyName , surveyId , employeeId from surveyForm js 
    * @return : NA
    */
    @AuraEnabled
    public Static Boolean createSurveyResponse(String surveyName , String surveyId, String employeeId){
        try{
            Form_Response__c  surveyResponse = new Form_Response__c();
            surveyResponse.Name = surveyName;
            surveyResponse.Employee__c = employeeId;
            surveyResponse.Form__C = surveyId;
            surveyResponse.Start_Date__c = System.now();
            surveyResponse.Status__c = 'Inprogress';
            surveyResponse.Is_Sent_Form__c = true;
            if(surveyResponse != null){
                insert surveyResponse;
                return true;
            }
            else{
                return false;
            }
        }
        catch(Exception ex){
             throw new AuraHandledException(ex.getMessage());
        }  
       
    }

    /**
    * @description : Method will execute from surveyForm only get url from Community page
    * @param : NA
    * @return : baseUrl of Community page
    */
    @AuraEnabled(cacheable=true)
    public static String getOrgBaseUrl(){
        try{
            String baseUrl = Network.getLoginUrl( Network.getNetworkId() );
            return baseUrl;
        }
        catch(Exception ex){
             throw new AuraHandledException(ex.getMessage());
        }  
    }

    /**
    * @description : Method will execute from surveyForm only Save response object record
    * @param : String wrapLists ,String recordId ,String base64,String filename - Contains wrapLists , recordId , base64, filename from surveyForm js 
    * @return : NA
    */
    @AuraEnabled
    public static void saveRecord(String wrapLists, String recordId, String showFormType, String base64, String filename ){
        try{
            List<Response__c> storeResponseList = new List<Response__c>();
            List<WrapList> wrapList = (List<WrapList>)JSON.deserialize(wrapLists, List<WrapList>.class);
            map<String,Id> mapOfQuesId = new map<String,Id>();
            map<Id, Id> mapOfsurQuesId = new map<Id, Id>();
            if(recordId != null){
                List<Form_Response__c> surveyList = [SELECT Id, Form__r.Id, Employee__r.Id 
                                                    FROM Form_Response__c WHERE Id =:recordId];
                if(!surveyList.isEmpty()){                                               
                    List<Form_Question__c> surveyQuestionList = [SELECT Id, Form__r.Id, Question__r.Id, Question__r.Name
                                                                FROM Form_Question__c WHERE Form__r.Id =: surveyList[0].Form__r.Id];
                    if(!surveyQuestionList.isEmpty()){
                        for(Form_Question__c obj : surveyQuestionList){
                            mapOfQuesId.put(obj.Question__r.Name, obj.Question__r.Id);
                            mapOfsurQuesId.put(obj.Question__r.Id, obj.Id);
                        }
                    }
                    for(WrapList wrap : wrapList){
                        if(wrap.value != ''){
                        Response__c  response = createResponse(wrap.value, surveyList[0].Employee__r.Id, surveyList[0].Id, mapOfQuesId.get(wrap.label), mapOfsurQuesId.get(mapOfQuesId.get(wrap.label)), System.now());
                        storeResponseList.add(response);
                        }
                    }
                }

                if(showFormType != null){
                    List<Form__c> formList;
                    if((showFormType == 'Comp-off Request' ||showFormType == 'Add Skills')){
                    formList = [SELECT Id, Name FROM Form__c WHERE Name = :showFormType];
                    }
                    else{
                    formList = [SELECT Id, Name FROM Form__c WHERE Id = :showFormType];
                    }
                    List<Employee__c> employeeList = [SELECT Id From Employee__c WHERE User_Associated__c =: UserInfo.getUserId()];
                    Form_Response__c  surveyResponse = new Form_Response__c();
                    if(!formList.isEmpty()){
                        surveyResponse.Name = formList[0].Name;
                        surveyResponse.Employee__c = employeeList[0].Id;
                        surveyResponse.Form__C = formList[0].Id;
                    }
                    surveyResponse.Start_Date__c = System.now();
                    surveyResponse.Status__c = 'Inprogress';
                if(surveyResponse != null){
                    insert surveyResponse;
                }
                List<Form_Question__c> formQuestionList = [SELECT Id, Form__r.Id, Question__r.Id, Question__r.Name
                                                        FROM Form_Question__c Where Form__r.Id =: formList[0].Id];
                    if(!formQuestionList.isEmpty()){
                        for(Form_Question__c obj : formQuestionList){
                            mapOfQuesId.put(obj.Question__r.Name, obj.Question__r.Id);
                            mapOfsurQuesId.put(obj.Question__r.Id, obj.Id);
                        }
                    }                                            
                    for(WrapList wrap : wrapList){
                        if(wrap.value != ''){
                            Response__c  response = createResponse(wrap.value, employeeList[0].Id, surveyResponse.Id, mapOfQuesId.get(wrap.label), mapOfsurQuesId.get(mapOfQuesId.get(wrap.label)), System.now() );
                            storeResponseList.add(response);
                        }
                    }
                }
                    if(!storeResponseList.isEmpty()){
                        insert storeResponseList;
                    }
                    List<Response__c>  responseList = [SELECT Id, Form_Response__c, Form_Response__r.Name FROM Response__c 
                                                    WHERE Id IN: storeResponseList];
                    List<Form_Response__c> formResponseList = new List<Form_Response__c>();                                         
                    if(!responseList.isEmpty()){
                        Form_Response__c formResponse = new Form_Response__c();
                        formResponse.Id = responseList[0].Form_Response__c ;
                        formResponse.Status__c = 'Completed' ;
                        formResponse.End_Date__c = System.now();
                        formResponseList.add(formResponse);
                    }
                    if(!formResponseList.isEmpty()){
                        update formResponseList;
                    }

                    if(responseList[0].Form_Response__r.Name == 'Comp-off Request'){
                        List<Employee__c> employeeList = [SELECT Id From Employee__c WHERE User_Associated__c =: UserInfo.getUserId()];
                            Comp_Off_Request__c comp = new Comp_Off_Request__c();
                            comp.Employee_Name__c = employeeList[0].Id;
                            comp.Date_Of_Comp_off_Request__c = Date.today();
                            comp.Comp_Off_Leave_Status__c = 'Invalid';
                            if(comp !=null){
                                insert comp;
                            }
                    }
                    List<Response__c>  resList = [SELECT Id, Question__r.Types__c FROM Response__c WHERE 
                                                            Question__r.Types__c ='file' AND Id IN: storeResponseList];
                    if(!resList.isEmpty()){
                        for(Response__c res : resList){
                            if(base64 != '' && filename != ''){
                                ContentVersion cv = createContentVersion(base64, filename);
                                ContentDocumentLink cdl = createContentLink(cv.Id, res.Id);
                            }
                        }
                    }
            }
        }catch(Exception ex){
             throw new AuraHandledException(ex.getMessage());
        }  
    }

    /**
    * @description : Method will execute from saveRecord only create Response__c object record
    * @param : String responseMessage ,  Id employeeId,  Id formResponse, Id question,  Id formQuestion, Datetime responseDate 
    * @return : Response__c -response
    */
    private static Response__c createResponse(String responseMessage, Id employeeId, Id formResponse, Id question, Id formQuestion, Datetime responseDate ){
        Response__c  response = new Response__c();
        response.Response_Message__c = responseMessage;
        response.Employee__c = employeeId;
        response.Form_Response__c = formResponse;
        response.Question__c = question;
        response.Form_Question__c = formQuestion;
        response.Response_Date__c = responseDate;
        return response;
    }

    /**
    * @description : Method will execute from saverecord method only create ContentVersion object record
    * @param : String base64, String filename - Contains base64 filename from saverecord method
    * @return : ContentVersion object record
    */
     @TestVisible Private static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        if(cv != null){
            insert cv;
        }
        return cv;
    }

    /**
    * @description : Method will execute from saverecord method only create ContentDocumentLink object record
    * @param : String contentVersionId, String recordIds - Contains contentVersionId from ContentVersion method
    * @return :  ContentDocumentLink object record
    */
     @TestVisible private static ContentDocumentLink createContentLink(String contentVersionId, String recordIds ) {
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersionId
        ].ContentDocumentId;
        cdl.LinkedEntityId = recordIds;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        if(cdl != null){
            insert cdl;
        }
        return cdl;   
    }   
    
    public Class SurveyDetails{
        @AuraEnabled
        public Boolean isFormStatus;
        @AuraEnabled
        public DateTime surveyStartDate;
        @AuraEnabled
        public DateTime surveyEndDate;
        @AuraEnabled   
        public String outOfDate;
    }
    
    public Class Questions{
        @AuraEnabled
        public String surveyName;
        @AuraEnabled
        public DateTime surveyStartDate;
        @AuraEnabled
        public DateTime surveyEndDate;
        @AuraEnabled
        Public String questionName;
        @AuraEnabled
        public String questionType;
        @AuraEnabled
        public Boolean requiredQuestion;
        @AuraEnabled
        public Boolean pickVal;
         @AuraEnabled
        public Boolean multiPickVal;
        @AuraEnabled
        public Boolean addSkill;
        @AuraEnabled
        public Boolean isLongText;
        @AuraEnabled
        public Boolean otherSkill;
        @AuraEnabled
        public List<Options> questionOptions;
         @AuraEnabled
        public List<DateofComp> dateOfCompoffRequest;
        @AuraEnabled
        public List<AddSkills> addSkills;
    }
    
    public class Options{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
    }

    public class DateofComp{
        @AuraEnabled
        public Date label;
        @AuraEnabled
        public String value;
    }
     public class AddSkills{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
    }
    
    public class WrapList {
        public String label;
        public String value;
    } 
}