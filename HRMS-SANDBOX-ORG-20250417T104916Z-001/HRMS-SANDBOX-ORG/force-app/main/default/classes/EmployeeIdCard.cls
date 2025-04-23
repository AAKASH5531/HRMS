/** 
* Description : Employee Id Card is used by the lightning web components EmployeeInformation
* @author : Aakash Mathur - HRMS 
* Created Date : 16/03/2023
* @modified by : Aakash Mathur - HRMS 
* Last Modified Date : 25/11/2023
*/
public class EmployeeIdCard {
    
    /**
    * @description : this method is responsible for geting Employee Information. // First letter should be capital.
    * @param : String recordId - Id of Employee object record
    * @return : List <GetEmployeeDto> getEmployeeDtoList // Make it more detailed explanation.
    */
    @AuraEnabled
    public static List <GetEmployeeDto> getEmployeeInfo(String employeeRecordId) {
        System.debug('-employeeRecordId---17-----'+employeeRecordId); // Debug log should be not there into the class.
        List <GetEmployeeDto> getEmployeeDtoList = new List <GetEmployeeDto>();
        List <ContentDocumentLink> contentDocLinkList = new List <ContentDocumentLink>();
        GetEmployeeDto employeeInfo = new GetEmployeeDto();
        List <Id> contDoclinkIdList = new List <Id>();
        try {
            if(employeeRecordId != null) {
                List<Employee__c> employeeList = [SELECT Id, Salutation__c, Contact_Number__c, Middle_Name__c, Personal_Email_ID__c, Designation__c,
                                                   Date_of_Joining__c, Gender__c, EMPLOYEE_ID__c, RecordTypeId, AADHAR_Number__c, Last_Name__c,
                                                   Name, Employee_Status__c, Employee_Activity_Status__c FROM Employee__c WHERE Id =:employeeRecordId];
                if (employeeList.size() > 0) {
                    employeeInfo.employeeId = employeeList[0].EMPLOYEE_ID__c;
                    employeeInfo.salutation = employeeList[0].Salutation__c;
                    employeeInfo.firstName = employeeList[0].Name;
                    employeeInfo.middleName = employeeList[0].Middle_Name__c;
                    employeeInfo.lastName = employeeList[0].Last_Name__c;
                    employeeInfo.gender = employeeList[0].Gender__c;
                    employeeInfo.designation = employeeList[0].Designation__c;
                    employeeInfo.employeeActivityStatus = employeeList[0].Employee_Activity_Status__c;
                    if (employeeList[0].Date_of_Joining__c != null) {
                        List<String> splitDate = String.valueOf(employeeList[0].Date_of_Joining__c).split('-');
                        if (!splitDate.isEmpty()) {
                            employeeInfo.joiningDate = splitDate[2] + '/' + splitDate[1] + '/' + splitDate[0];
                        }
                    }
                    employeeInfo.email = employeeList[0].Personal_Email_ID__c;
                    employeeInfo.contactNumber = employeeList[0].Contact_Number__c;
                }
                List<Employee_Document__c> empDocList = [SELECT Id, Name, Employee__c FROM Employee_Document__c WHERE Employee__c =:employeeRecordId AND Name = 'Employee Image'];
                System.debug('empDocList======45===>'+empDocList); // Debug log should be not there into the class.
                if (empDocList.size() > 0) {
                    contentDocLinkList = [SELECT Id, LinkedEntityId, ContentDocumentId, IsDeleted,
                                          SystemModstamp, ShareType, Visibility FROM ContentDocumentLink 
                                          WHERE LinkedEntityId  =:empDocList[0].Id LIMIT 1];
                }
                System.debug('==52======>'+contentDocLinkList); // Debug log should be not there into the class.
                if (contentDocLinkList.size() > 0) {
                    for (ContentDocumentLink contDoclink: contentDocLinkList) {
                        contDoclinkIdList.add(contDoclink.ContentDocumentId);
                    }
                   String imageName = '%'+ employeeList[0].EMPLOYEE_ID__c + '_' + 'Employee Image'+ '%';
                     //String imageName = '%'+ employeeList[0].EMPLOYEE_ID__c + '_' + 'Employee Image'+'.png_Company_Docs' +'%';
                    System.debug('imageName------>'+imageName); // Debug log should be not there into the class.
                    List <ContentVersion> contentVersionList = [SELECT Id, PathOnClient, ContentDocumentId,
                                                                IsLatest, ContentUrl FROM ContentVersion
                                                                WHERE ContentDocumentId =: contDoclinkIdList AND Title LIKE: imageName LIMIT 1];
                    SYstem.debug('---------------------->contentVersionList'+contentVersionList); // Debug log should be not there into the class.
                    if (contentVersionList.size() > 0) {
                        employeeInfo.contentVersion = URL.getSalesforceBaseUrl().toExternalForm() + '/sfc/servlet.shepherd/version/download/' + contentVersionList[0].Id;
                    }
                }
                getEmployeeDtoList.add(employeeInfo);
                System.debug('getEmployeeDtoList===========>'+getEmployeeDtoList); // Debug log should be not there into the class.
                return getEmployeeDtoList;
            }
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        } 
        return null;  
    }
    
    public class GetEmployeeDto {
        @AuraEnabled
        public String employeeId;
        @AuraEnabled
        public String firstName;
        @AuraEnabled
        public String lastName;
        @AuraEnabled
        public String middleName;
        @AuraEnabled
        public String salutation;
        @AuraEnabled
        public String gender;
        @AuraEnabled
        public String designation;
        @AuraEnabled
        public String joiningDate;
        @AuraEnabled
        public String email;
        @AuraEnabled
        public String contentVersion;
        @AuraEnabled
        public String contactNumber;
        @AuraEnabled
        public String employeeActivityStatus;
    }
}