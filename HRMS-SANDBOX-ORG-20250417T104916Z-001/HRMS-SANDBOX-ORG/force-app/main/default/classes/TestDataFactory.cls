// Add the proper class level comment like neeed to class who is crated this class and where can we use it all the stuffs.
// Variable name should be more detailed and meaningful. Don't use like cdl , cv ect.
// Don't just use the object API name into return statement make it detailed statement.
public class TestDataFactory {
    Public Static  String base64 = 'JVBERi0xLjQKJcfsj6IKNSAwIG9iago8PC9MZW5ndGggNiAwIFIvRmlsdGVyIC9GbGF0ZURlY29kZT4+CnN0cmVhbQp4nJ2b23IVN/LdXzG1D7vnbOUMo9tISiWpLdXWxIJFIMSnHwDf45KUWqyOaUrEwMAplbmRzdHJlYW0KZW5kb2JqCjYgMCBvYmoKMTQ1CmVuZG9iago3IDAgb2JqCjw8L1R5cGUgL1hPYmplY3QvU3VidHlwZSAvSW1hZ2UvV2lkdGggMjAwL0hlaWdodCAyMDAvQml0c1BlckNvbXBvbmVudCA4L0NvbG9yU3BhY2UgWy9JbmRleGVkIC9EZXZpY2VSR0IgMjU1IDggMCBSXSAvRmlsdGVyIC9GbGF0ZURlY29kZS9MZW5ndGggNyAwIFI+PgpzdHJlYW0KeJztwTEBAAAAwqD+WAADmAIAXaCf8wplbmRzdHJlYW0KZW5kb2JqCjggMCBvYmoKPDwvTGVuZ3RoIDkgMCBSL0ZpbHRlciAvRmxhdGVEZWNvZGU+PgpzdHJlYW0KeJwr5HIKUnXILy1SslIwMLIwtFVIzs8FAHy6E3MKZW5kc3RyZWFtCmVuZG9iago5IDAgb2JqCjIyCmVuZG9iagoxMCAwIG9iago8PC9UeXBlIC9QYWdlL01lZGlhQm94IFswIDAgMjAwIDIwMF0vUmVzb3VyY2VzIDIgMCBSL0NvbnRlbnRzIDQgMCBSL1BhcmVudCAzIDAgUj4+CmVuZG9iagoxMSAwIG9iago8PC9DcmVhdGlvbkRhdGUgKEQ6MjAyMzA0MTgwODI1MzArMDAnMDAnKS9Nb2REYXRlIChEOjIwMjMwNDE4MDgyNTMwKzAwJzAwJykvUHJvZHVjZXIgKFBERi1YY2hhbmdlIFBERiBWZXJzaW9uIDQuMC4xIC0gd3d3LnBkZi14Y2hhbmdlLmNvbSk+PgplbmRvYmoKMSAwIG9iago8PC9UeXBlIC9DYXRhbG9nL1BhZ2VzIDMgMCBSPj4KZW5kb2JqCjMgMCBvYmoKPDwvVHlwZSAvUGFnZXMKL0tpZHMgWzEwIDAgUl0KL0NvdW50IDEKPj4KZW5kb2JqCjIgMCBvYmoKPDwKL1Byb2NTZXQgWy9QREYgL1RleHQgL0ltYWdlQiAvSW1hZ2VDIC9JbWFnZUldCi9YT2JqZWN0IDw8Ci9JbWFnZSA3IDAgUgo+Pgo+PgplbmRvYmoKeHJlZgowIDEyCjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDAxNSAwMDAwMCBuIAowMDAwMDAwMDc3IDAwMDAwIG4gCjAwMDAwMDAxNjggMDAwMDAgbiAKMDAwMDAwMDE5MyAwMDAwMCBuIAowMDAwMDAwMzIyIDAwMDAwIG4gCjAwMDAwMDAzOTcgMDAwMDAgbiAKMDAwMDAwNDQ3NiAwMDAwMCBuIAowMDAwMDA0NTAxIDAwMDAwIG4gCjAwMDAwMDQ1MjYgMDAwMDAgbiAKMDAwMDAwNDYwMSAwMDAwMCBuIAowMDAwMDA0NzIyIDAwMDAwIG4gCnRyYWlsZXIKPDwKL1NpemUgMTIKL1Jvb3QgMSAwIFIKL0luZm8gMTEgMCBSCi9JRCBbPDcyM0QxNkE5ODc5NkE5ODc5NkE5ODc5NkE5ODc5NkE+IDw3MjNEMTZBOTg3OTZBOTg3OTZBOTg3OTZBOTg3OTZBPj5dCj4+CnN0YXJ0eHJlZgo0ODc1CiUlRU9GCg==';
    Public Static  String folderId = '1a2b3c4d5e6f7g8h9i0j';
    Public Static  String mimeType = 'application/pdf';
    Public Static  String filename = '_Aadhar Card.pdf';
    
    /**
    * @description : The method is used to create an employee record.
    * @param : NA
    * @return : employee record - (Employee__c)
    */
    public Static Employee__c employeeRecordCreate(){
        Employee__c  employee = new Employee__c();
        employee.Name = 'Test';
        employee.AADHAR_Number__c = '956523158112';
        employee.PAN_Number__c = 'ABRDE1237Y';
        employee.Employee_Activity_Status__c = 'Active';
        employee.Gender__c = 'male';
        employee.Contact_Number__c = '123456789';
        employee.D_O_B_Original__c = Date.today();
        employee.EMPLOYEE_ID__c = 'AC0001';
        employee.D_O_B_As_per_Aadhar__c = Date.today();
        employee.Personal_Email_ID__c = 'test@gamil.com';
        employee.Date_of_Joining__c = Date.today();
        employee.Salutation__c = 'Mr.';
        employee.Marital_Status__c = 'Married';
        employee.Designation__c = 'salesforce Trainee';
        employee.ReHire__c = true;
        employee.Total_Experience__c = 7;
        employee.User_Associated__c = UserInfo.getUserId();
        return employee;
    }
    
    /**
    * @description : The method is used to create an Employee Document record with the child of the employee.
    * @param : Id employeeId - contains employee id
    * @return : Employee Document record - (Employee_Document__c)
    */
    public Static Employee_Document__c employeeDocumentRecord(Id employeeId){        
        Employee_Document__c empDoc = new Employee_Document__c();
        empDoc.Name = 'Aadhar Card';
        empDoc.Employee_Docs__c = '1w_tmpzUwMebFwKibc8mbEVhbyO7KNpN0';
        empDoc.Company_Docs__c = '1OLJnP0qcy0P8SbcfdbRgWQMVZ21wgPoi';
        empDoc.Employee__c = employeeId;
        return empDoc;
        
    }
    
    /**
    * @description : The method is used to create a Past Experience record with the child of the employee.
    * @param : Id employee - contains employee manager id
    * @return : pastExperience record - (Past_Experience__c)
    */
    public Static Past_Experience__c  createPastExperienceRecord (Id employee){
        Past_Experience__c pastExperience = new Past_Experience__c();
        pastExperience.Employee__c = employee;
        pastExperience.Designation__c = 'Salesforce Developer';
        Date currentDate = Date.today();
        Date todayDate = Date.today();
        Date afterThirteeDay = Date.today().addDays(30);
        pastExperience.Joining_Date__c = todayDate;
        pastExperience.Relieving_Date__c = afterThirteeDay;
        return pastExperience;
    }
    
    /**
    * @description : The method is used to create a ContentVersion.
    * @param : NA
    * @return : ContentVersion - (ContentVersion)
    */
    public Static ContentVersion createContentVersion(){
        ContentVersion cv = new ContentVersion();
        cv.Title = '_Aadhar Card.pdf';
        cv.PathOnClient = 'Aadhar_Card.pdf';
        cv.IsMajorVersion = true;
        cv.VersionData = EncodingUtil.base64Decode(base64);
        return cv;
    }   
    
    /**
    * @description : The method is used to create a user with the given profile name.
    * @param : String profileName - contains profile name
    * @return : user record - (User)
    */
    public static User createUserWithProfile(String profileName, String lastName, String userName, String email) {
        Profile profile = [SELECT Id FROM Profile WHERE Name =: profileName LIMIT 1];
        User user = new User(
            Alias = 'sysAdmin',
            Email = email, 
            EmailEncodingKey = 'UTF-8',
            LastName = lastName,
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = userName 
        );
        
        return user;
    }
    
    /**
    * @description : The method is used to create an Employee Document record with ContentDocumentId and Employee Id.
    * @param : Id conDocId, Id empDoc - contains ContentDocumentId and Employee Id
    * @return : ContentDocumentLink record - (ContentDocumentLink)
    */
    public Static ContentDocumentLink ContentDocumentLink(Id conDocId, Id empDoc){
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = empDoc;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        return cdl; 
    } 
    
    /**
    * @description : The method is used to create Form. 
    * @param : NA
    * @return : Form - (Form__c)
    */
    Public Static Form__c createForm(){
        Form__c form = new Form__c();
        form.Name = 'test';
        form.IsActive__c = true;
        form.Start_Date__c = date.today().addDays(-5);
        form.End_Date__c = Date.today().addDays(5);
        return form;
    }
    
    /**
    * @description : The method is used to create a FormResponse record with Employee Id and form Id.
    * @param : Id employee, Id form - contains Employee Id and form id
    * @return : formResponse record - (Form_Response__c)
    */
    public Static Form_Response__c createFormResponse(Id employee, Id form){
        Form_Response__c formResponse = new  Form_Response__c();
        formResponse.Name = 'Comp-off Request';
        formResponse.Employee__c = employee;
        formResponse.Form__c = form;
        return formResponse;
    }
    
    /**
    * @description : The method is used to create Question
    * @param : NA
    * @return : question - (Question__c)
    */
    public Static Question__c createQuestion(String questionType){
        Question__c question = new Question__c();
        question.Name = 'Test';
        question.IsActive__c = true;
        question.Types__c = questionType;
        return question;
    }
    
    /**
    * @description : The method is used to create a Choice record with a question.
    * @param : String questionId, contains question id
    * @return : formResponse record - (Form_Response__c)
    */
    public static Choice__c createChoice(String questionId){
        Choice__c choice = new Choice__c();
        choice.Name = 'Test';
        choice.Question__c = questionId;
        return choice;
    }
    
    /**
    * @description : The method is used to create a FormQuestion record for a form with a question.
    * @param : Id form , Id question, contains form id and question id
    * @return : Form Question - (Form_Question__c)
    */
    public static Form_Question__c createFormQuestion(Id form, Id question){
        Form_Question__c formQuestion =new Form_Question__c();
        formQuestion.Name = 'Test';
        formQuestion.Form__c = form;
        formQuestion.Question__c = question;
        return formQuestion;
        
    }

	/**
    * @description : The method is used to create a Response record for a form with Response, FormResponse, Question, and FormQuestion.
    * @param : Id employee ,Id formResponse, Id question, Id formQuestion, contains employee id, formResponse id, question and formQuestion
    * @return : Response - (Response__c)
    */    
    public static Response__c createResponse(Id employee, Id formResponse, Id question, Id formQuestion){
        Response__c  response = new Response__c();
        response.Response_Message__c = 'test';
        response.Employee__c = employee;
        response.Form_Response__c = formResponse;
        response.Question__c = question;
        response.Form_Question__c = formQuestion;
        response.Response_Date__c = System.now();
        return response;
        
    }
        
    /**
    * @description : The method is used to create a CompOffRequest record for a form with an employee.
    * @param : Id form , Id question, contains form id and question id
    * @return : Comp Off Request - (Comp_Off_Request__c)
    */
    public static Comp_Off_Request__c createCompOffRequest(Id employee, String compOffLeaveStatus, Date dateOfCompOffRequest){
        Comp_Off_Request__c compOffRequest = new Comp_Off_Request__c(
            Employee_Name__c = employee, 
            Comp_Off_Leave_Status__c = compOffLeaveStatus,
            Update_Approval_Status__c = 'Approved',
            Date_Of_Comp_off_Request__c = dateOfCompOffRequest 
        );
        return compOffRequest;
    }  
    
    /**
    * @description : The method is used to create Events
    * @param : NA
    * @return : Event
    */
    public static Event createEvent(){
        Event objEvent = new Event();
        objEvent.Type = 'Email';
        objEvent.Subject = 'Test';
        objEvent.Description = 'Testing'; 
        objEvent.StartDateTime = System.now(); 
        objEvent.EndDateTime = System.now().addMinutes(60);
        objEvent.Location = 'Sample';
        objEvent.Event_Id__c = '565666444646446';
        return objEvent ;
    }
    
    /**
    * @description : The method is used to create Task
    * @param : NA
    * @return : Task
    */
    public static Task createTask(String subject){
        Task task = new Task();
        task.Subject = subject;
        return task;
    } 
    
    /**
    * @description : The method is used to create Project
    * @param : NA
    * @return : Project - (Project__c)
    */
    public static Project__c createProject(){
        Project__c project = new Project__c();
        project.Name = 'HRMS';
        return project;
    }
    
    /**
    * @description : The method is used to create an Assign Project record for a form with EmployeeId and ProjectId.
    * @param : Id employeeId and Id projectId, contains form employeeId and projectId
    * @return : AssigenProject - (Assigned_Project__c)
    */
    public static Assigned_Project__c createAssigenProject(Id employeeId, Id projectId){
        Assigned_Project__c assignedProject = new Assigned_Project__c();
        assignedProject.Percentage_Consuming__c = 55;
        assignedProject.Is_Shadow__c = true;
        assignedProject.Assigned_Project__c = employeeId;
        assignedProject.Shadow_Of__c = employeeId;
        assignedProject.Project__c = projectId;
        return assignedProject;
    } 
    
    /**
    * @description : The method is used to create JSON
    * @param : NA
    * @return : wrapper - (DynamicFormController.WrapList)
    */
    public static DynamicFormController.WrapList createJson(String label, String value){
        DynamicFormController.WrapList wrapperForRequired = new DynamicFormController.WrapList();
        wrapperForRequired.label = label;
        wrapperForRequired.value = value;
        return wrapperForRequired;
    }
   
       /**
    * @description : The method is used to create Project_Skills__c 
    * @param : NA
    * @return : Project_Skills__c
    */
    public static Project_Skills__c createProjectSkill(String skillId, String projectId){
        Project_Skills__c  projectSkillRecord = new Project_Skills__c();
        projectSkillRecord.Name = 'ABC';
        projectSkillRecord.Skills__c = skillId;
        projectSkillRecord.Project__c = projectId;
        return projectSkillRecord;
    }
    
        /**
    * @description : The method is used to create Skills__c 
    * @param : NA
    * @return : Skills__c
    */
    public static Skills__c createSkillRecord(){
        Skills__c skill = new Skills__c();
        skill.Name = 'ABC';
        return skill;
    } 
    
      /**
    * @description : The method is used to create Employee_Skills__c 
    * @param : NA
    * @return : Employee_Skills__c
    */
    public static Employee_Skills__c createEmployeeSkillRecord(String skillId, String employeeSkillId){
        Employee_Skills__c employeeSkills = new Employee_Skills__c();
        employeeSkills.Skills__c = skillId;
        employeeSkills.Employee__c = employeeSkillId;
        return employeeSkills;
    } 
    
   /**
    * @description : The method is used to create Employee_Skills_Package__c 
    * @param : NA
    * @return : Employee_Skills_Package__c
    */
     public static Employee_Skills_Package__c createEmployeeSkillPackageRecord(String skillPackageId, String employeeId){
        Employee_Skills_Package__c employeeSkillPackage = new Employee_Skills_Package__c();
        employeeSkillPackage.Skills_Package__c = skillPackageId;
        employeeSkillPackage.Employee__c = employeeId;
        return employeeSkillPackage;
    } 
    
   /**
    * @description : The method is used to create Project_Skills_Package__c 
    * @param : NA
    * @return : Project_Skills_Package__c
    */
     public static Project_Skills_Package__c createProjectSkillsPackage(String skillsPackageId, String projectId){
        Project_Skills_Package__c projectSkillsPackage = new Project_Skills_Package__c();
        projectSkillsPackage.Skills_Package__c = skillsPackageId;
         projectSkillsPackage.Name = 'ABC';
        projectSkillsPackage.Project__c = projectId;
        return projectSkillsPackage;
    } 
    
         /**
    * @description : The method is used to create Skills_Package__c 
    * @param : NA
    * @return : Skills_Package__c
    */
     public static Skills_Package__c createProjectSkillsPackage(){
        Skills_Package__c skillsPackageRecord = new Skills_Package__c();
        skillsPackageRecord.Name = 'ABC';
        return skillsPackageRecord;
    }
    
}