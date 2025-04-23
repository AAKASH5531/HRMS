/**
* @description : The handler is used by the lightning web components UploadDocumentStatus
* @author : Aakash Mathur - HRMS
* @date  : 7th Oct 2023
* @modified by: Aakash Mathur 
* @modified date: 28th Nov 2023
*/
public with sharing class UploadDocumentStatus {
    
    /**  
    * @description : this method is use in lightning web components UploedDocumentStatus to get record Id of object
    * @param : String recordId - Id of the record
    * @ return : List<FileInformation> fileInformationList // make it more detailed
    */     
    @AuraEnabled
    public static List<FileInformation> getSObjectRecordId(Id recordId){
        List<FileInformation> fileInformationList = new  List<FileInformation>();
        String emplyeeObject = 'Employee__c';
        String employeeDocObj = 'Employee_Document__c';
        SObjectType emplyeeObjectName = ((SObject) Type.forName(emplyeeObject).newInstance()).getSObjectType();
        SObjectType emplyeeDocumentObjectName = ((SObject) Type.forName(employeeDocObj).newInstance()).getSObjectType();
        if(recordId.getsObjecttype() == emplyeeDocumentObjectName){
            fileInformationList = documentStatusOnEmpDoc(recordId,employeeDocObj);
        }
        if(recordId.getsObjecttype() == emplyeeObjectName){
            fileInformationList = documentStatusOnEmployee(recordId,emplyeeObject);
        }
        return fileInformationList;
    }   
        
    /** 
    * @description : this method is use in lightning web components UploedDocumentStatus to get documentStatus of Employee
    * @param : String recordId - Id of the record
    * @param : String emplyeeObject - object name
    * @ return List<FileInformation> fileInformationList
    */   
    public Static List<FileInformation> documentStatusOnEmployee(Id recordId,String emplyeeObject){
        // ------ variables -------
        List<FileInformation> fileInformationList = new  List<FileInformation>();
        Map<String, Set<String>> empDocIdAndDocumentIdMap = new Map<String, Set<String>>();
        Map<String, ContentVersion> contentDocumentIdAndContentVersion= new Map<String, ContentVersion> ();
        Set<String> setOfEmpDocId = new Set<String>();
        Set<String> setOfContentDocumentId = new Set<String>();
        Map<String, String> contentDocumentIdAndEmpDocId = new Map<String, String>();
        Map<String, Employee_Document__c> empDocIdAndEmployeeDocument = new Map<String, Employee_Document__c>();
        List<LabelFieldWrapper> labelValueList = new List<LabelFieldWrapper>();
        
        List<Employee_Document__c> employeeDocList = [SELECT Id, Name, File_Uploaded__c, Is_Sync_With_Google_Drive__c,
                                                      Employee__c FROM Employee_Document__c WHERE Employee__c =:recordId ];
        // Null check is necessary thing on the query result (employeeDocList).
        for(Employee_Document__c empdoc : employeeDocList){
            empDocIdAndEmployeeDocument.put(empdoc.Id, empdoc);
            setOfEmpDocId.add(empdoc.Id);
        }        
        List<ContentDocumentLink> cdlList = [SELECT Id, LinkedEntityId, ContentDocumentId
                                             FROM ContentDocumentLink WHERE LinkedEntityId IN : setOfEmpDocId]; // Variable name should more meaningful.
        if(cdlList.size()>0){
            for(ContentDocumentLink cdl : cdlList){
                contentDocumentIdAndEmpDocId.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
                setOfContentDocumentId.add(cdl.ContentDocumentId);
                Set<String> innerSetOfContentDocument = new Set<String>();
                if(empDocIdAndDocumentIdMap.containsKey(cdl.LinkedEntityId)){
                    innerSetOfContentDocument = empDocIdAndDocumentIdMap.get(cdl.LinkedEntityId);
                }
                innerSetOfContentDocument.add(cdl.ContentDocumentId);
                empDocIdAndDocumentIdMap.put(cdl.LinkedEntityId, innerSetOfContentDocument);
            }  
        }
        List<ContentVersion> cvList =  [SELECT Id, Title, ContentDocumentId FROM contentversion WHERE 
                                        ContentDocumentId IN : setOfContentDocumentId]; // Variable name should more meaningful.
        if(cvList.size()>0){
            for(ContentVersion cv : cvList){
                contentDocumentIdAndContentVersion.put(cv.ContentDocumentId, cv);
            }
        }
        if(!empDocIdAndEmployeeDocument.isEmpty()){
            for(String empDocRec : empDocIdAndEmployeeDocument.KeySet()){
                FileInformation fileInformation = new FileInformation();
                Set<String> setOfContentDocument = new Set<String>();
                if(empDocIdAndDocumentIdMap.containsKey(empDocRec)){
                    Employee_Document__c emp = empDocIdAndEmployeeDocument.get(empDocRec);
                    setOfContentDocument = empDocIdAndDocumentIdMap.get(empDocRec);
                    LabelFieldWrapper labelValue = new LabelFieldWrapper();
                    List<ContentVersion> contentVersionList = new List<ContentVersion>(); 
                    for(String contentDocumentId : setOfContentDocument){
                        if(contentDocumentIdAndContentVersion.containsKey(contentDocumentId)){
                            ContentVersion cv = contentDocumentIdAndContentVersion.get(contentDocumentId);
                            contentVersionList.add(cv);
                            Integer i = 0;
                            fileInformation = fillWrapper(emp, contentVersionList, fileInformation, labelValue, i, emplyeeObject);
                        }
                    }
                    fileInformationList.add(fileInformation);
                }
                else{
                    List<ContentVersion> contentVersionList = new List<ContentVersion>();
                    LabelFieldWrapper labelValue = new LabelFieldWrapper();
                    Employee_Document__c emps = empDocIdAndEmployeeDocument.get(empDocRec);
                    fileInformation = fillWrapper(emps, contentVersionList, fileInformation, labelValue, null, emplyeeObject);
                    fileInformationList.add(fileInformation);
                }
            }
        }
        else{
             for(Employee_Document__c empdocRec : employeeDocList){
                 List<ContentVersion> contentVersionList = new List<ContentVersion>();
                    FileInformation fileInformation = new FileInformation();
                    LabelFieldWrapper labelValue = new LabelFieldWrapper();
                    fileInformation = fillWrapper(empdocRec, contentVersionList, fileInformation, labelValue, null, emplyeeObject);
                    fileInformationList.add(fileInformation);
                }
        }
        return fileInformationList;
    }
    
    /** 
    * @description : this method is use in lightning web components UploedDocumentStatus to get documentStatus of Employee Document
    * @param : Id recordId, String employeeDocObj - Contains recordId of Employee Document Object and Object name
    * @ return : List<FileInformation> fileInformationList // Make it more detailed explaniation.
    */
    public static List<FileInformation> documentStatusOnEmpDoc(Id recordId,String employeeDocObj){
        List<LabelFieldWrapper> labelValueList = new List<LabelFieldWrapper>();
        List<FileInformation> fileInformationList = new  List<FileInformation>();
        Set<Id> ContentDocumentId = new Set<Id>();
        Set<Id> empDocID = new Set<Id>();
        List<Employee_Document__c> employeeDocList = [SELECT Id, Name, File_Uploaded__c, Is_Sync_With_Google_Drive__c, 
                                                      Employee__c FROM Employee_Document__c WHERE Id =:recordId ];
        // Null check is necessary thing on the query result (employeeDocList).
        for(Employee_Document__c empdoc : employeeDocList){
            empDocID.add(empdoc.Id);
        } 
        List<ContentDocumentLink> contLink = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink
                                              WHERE LinkedEntityId IN : empDocID];
        // Null check is necessary thing on the query result (employeeDocList).
        for(ContentDocumentLink condoc : contLink){
            ContentDocumentId.add(condoc.ContentDocumentId);
        }
        List<contentversion> cvList =  [SELECT Id, Title, ContentDocumentId FROM contentversion 
                                        WHERE ContentDocumentId IN:ContentDocumentId ]; // Variable name should more meaningful.
        for(Employee_Document__c empDoc : employeeDocList){
            FileInformation fileInformation = new FileInformation();
            integer i= 0;
            LabelFieldWrapper labelValue = new LabelFieldWrapper();
            if(cvList.size()>0){
                 fileInformation = fillWrapper(empDoc, cvList, fileInformation, labelValue, i, employeeDocObj);
                 fileInformationList.add(fileInformation);
            }
            else{
                 fileInformation = fillWrapper(empDoc, cvList, fileInformation, labelValue, null, employeeDocObj);
                 fileInformationList.add(fileInformation);
            }
        }
        return fileInformationList;
    }
    
    /** 
    * @description : this method is used to fill Wrapper 
    * @param : Employee_Document__c empDoc, List<contentversion> cvList, FileInformation fileInformation,LabelFieldWrapper labelValue, Integer i, String employeeDocOb - Contains empDoc, cvList, fileInformation, labelValue, i, and objectName 
    * @ return : FileInformation
    */
    private Static FileInformation fillWrapper(Employee_Document__c empDoc, List<contentversion> cvList, FileInformation fileInformation,LabelFieldWrapper labelValue, Integer i, String objectName){
        System.debug('-----cvList.size()--------------------'+cvList.size());
        if(cvList.size() > 0 && cvList != null){
            for(contentversion cv : cvList){ 
                i++;
                if(cv.Title.contains('_Company_Docs')){
                    labelValue.isCompanyDocumentStatus = true;
                }
                if(cv.Title.contains('_Employee_Docs')){
                    labelValue.isEmployeeDocumentStatus = true;
                }
                if(i>2){
                    labelValue.isExtraDocumentUploaded = true ; 
                }else{
                    labelValue.isExtraDocumentUploaded = false;
                }
                fileInformation.LabelFieldWrapper  = labelValue;
                fileInformation.labelName = empDoc.Name;
                fileInformation.objectName = objectName;
            }
        }
        else{
            labelValue.isCompanyDocumentStatus = false ;
            labelValue.isEmployeeDocumentStatus = false ;
            labelValue.isExtraDocumentUploaded = false ; 
            labelValue.isExtraDocumentUploaded = false;
            fileInformation.LabelFieldWrapper  = labelValue;
            fileInformation.labelName = empDoc.Name;
            fileInformation.objectName = objectName;
       }
       System.debug('fileInformation---183------->'+fileInformation);
        return  fileInformation;
    } 
    
    public class  FileInformation {
        @AuraEnabled
        public String labelName;
        @AuraEnabled
        public String objectName;
        @AuraEnabled
        public LabelFieldWrapper labelFieldWrapper;
    } 
    
    public class LabelFieldWrapper{
        @AuraEnabled
        public Boolean isEmployeeDocumentStatus;  
        @AuraEnabled
        public Boolean isCompanyDocumentStatus;  
        @AuraEnabled
        public Boolean isExtraDocumentUploaded;  
    }  
}