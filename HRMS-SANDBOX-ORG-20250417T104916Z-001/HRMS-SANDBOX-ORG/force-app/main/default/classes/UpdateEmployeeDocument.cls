/**
* @description : The handler is used by the lightning web components UpdateEmployeeDocument
* @author : Aakash Mathur - HRMS
* @cerated date  : 26th Oct 2023
* @modified by: Aakash Mathur 
* @modified date: 25th Nov 2023
*/
public with sharing class UpdateEmployeeDocument {
        
   /**
    * @description : this method is responsible for uploading on google drive.
    * @param : String base64, String filename, String folderId, String mimeType, String recordId, String recordType - Contains base64,filename,folderId,mimeType,recordId and recordType of file
    * @return {Boolean} - returns true is status code is 200 else return false
    */
    
    
    // Remove all the debug logs and code should be formated
    @AuraEnabled
    public static Boolean calloutForUpload(String base64, String filename, String folderId, String mimeType, String recordId, String recordType){
        System.debug('filename---18-in-->'+filename);
        //System.debug('folderName---155--->'+folderName);
        System.debug('filename---20--in->'+filename);
        System.debug('folderId---21-in-->'+folderId);
        Boolean isUpload = false;
        String folderName;
        Integer statusCode;
        String getResponseBody;
        Map<String, String> headerParamMap = new Map<String, String>();
        try{
            List<ContentDocumentLink> conLinkList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:recordId];
            Set<Id> contentDocumentIds = new Set<Id>();
            for(ContentDocumentLink link : conLinkList) {
                contentDocumentIds.add(link.ContentDocumentId);
            }  
            if(filename.contains(recordType)){
                    folderName = recordType; 
                }
            String boundary = '----------9889464542212';
            String delimiter= '\r\n--' + boundary + '\r\n';
            String close_delim = '\r\n--' + boundary + '--';
            String body= delimiter + 'Content-Type: application/json\r\n\r\n' + '{"title" : "' + filename + '", ' + ' "mimeType" : "' + mimeType + '",' + '"parents": [{"id":"'+ FolderId + '"}]}' + delimiter + 'Content-Type: ' + mimeType + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + base64 + close_delim;
            List<Google_drive__mdt> googleDrive = [SELECT Id, Application__c, Endpoint__c, Header__c, 
                                                        Request_Method__c, Bearer__c, MasterLabel
                                                FROM Google_drive__mdt  WHERE MasterLabel = 'Upload File on Google Drive'];
            if(googleDrive.size()>0){
                headerParamMap.put('Content-length', String.valueOf(body.length()));
                headerParamMap.put('content-type', 'multipart/mixed; boundary="' + boundary + '"');
                HTTPCalloutServiceParamDAO serviceParam = new HTTPCalloutServiceParamDAO(googleDrive[0].Endpoint__c, googleDrive[0].Request_Method__c, body, '', null, headerParamMap, 12000);
                HTTPCalloutService calloutService = new HTTPCalloutService(serviceParam);
                HTTPResponse response  = calloutService.sendRequest();
                getResponseBody = response.getBody();
                System.debug('response===50====>'+response.getBody());
                statusCode = response.getStatusCode();
            }
            if (statusCode == 200) {
                isUpload = true;
                errorHandling(getResponseBody, body);
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(getResponseBody);
                System.debug('responseMap===57==========>'+responseMap);
                String fileId = (String) responseMap.get('id');
                Integer lastDotIndex = filename.lastIndexOf('.');
                String fileNameWithoutExtension = removeIdAndExtensionOfFiles(filename);
                if(HRMS_Constants.FILE_NAME_AND_FIELD_MAPPING.containsKey(fileNameWithoutExtension)){
                    folderName = folderName ; 
                }
                String documentName = (String) responseMap.get('title');
                Employee_Document__c employeeDoc = new  Employee_Document__c();
                employeeDoc.Is_Sync_With_Google_Drive__c = true;
                employeeDoc.Id = recordId;
                System.debug('fileId----250---->'+fileId);
                if(!String.isBlank(documentName)  && documentName.contains('_Company_Docs') ){
                    employeeDoc.Company_Docs__c = fileId; 
                }
                if((!String.isBlank(documentName) ) && (documentName.contains('_Employee_Docs'))){
                    employeeDoc.Employee_Docs__c = fileId;     
                }
                if(employeeDoc != null){
                    update employeeDoc;
                }
                return isUpload;
            }else{
                errorHandling(getResponseBody, body);
                return isUpload;
            }
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
   /** 
    * @description this method is responsible for uploading on google drive.
    * @param : String recordId, Object uploadedFile, String recordType - contains recordId, uploadedFile, recordType of file
    * @return : {Map<String, String>} 
    */  
    @AuraEnabled
    public static Map<String, String> updateRecordFiles(String recordId, Object uploadedFile, String recordType){
        try{
            String folderName;
            String folderId;
            Set<Id> contentDocumentIds = new Set<Id>();
            List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
            List<SObject> filesForDelete = new List<SObject>();
            List<ContentVersion> deleteFileSets = new List<ContentVersion>();
            Set<String> contentVersionSets = new Set<String>();
            List<Employee_Document__c> getEmpNameAndFolderId = [SELECT Id,com__c, emp__c, Employee__r.Employee_Docs_FolderId__c, Employee__r.Company_Docs_FolderID__c,
                                                                       Name, Company_Docs__c, Employee_Docs__c, Employee__r.EMPLOYEE_ID__c, Employee__r.Google_Drive_Parent_Folder_ID__c,
                                                                       RecordTypeId FROM Employee_Document__c WHERE Id  =:recordId];
            List<ContentDocumentLink> conLinkList = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =:recordId];
            for(ContentDocumentLink link :conLinkList) {
                contentDocumentIds.add(link.ContentDocumentId);
            }  
            Map<Object,Object> mapOfFiles = (Map<Object, Object>)uploadedFile;
             if(getEmpNameAndFolderId.size()>0){
                if(recordType.contains('Employee_Docs')){  
                    folderName = recordType;
                    folderId = getEmpNameAndFolderId[0].Employee__r.Employee_Docs_FolderId__c;
                }else{
                    folderId = getEmpNameAndFolderId[0].Employee__r.Company_Docs_FolderID__c;   
                }
            }
            String versionData = (String)mapOfFiles.get('base64');
            String fileName = (String)mapOfFiles.get('filename');
            String title = getEmpNameAndFolderId[0].Employee__r.EMPLOYEE_ID__c +'_'+(String)mapOfFiles.get('filename')+'_'+recordType;
            String mimeType = (String)mapOfFiles.get('mimeType');
            ContentVersion cv = insertContentVersion(EncodingUtil.base64Decode((String)mapOfFiles.get('base64')), title, fileName, recordId, recordType );
            for(ContentDocumentLink link : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: recordId]) {
                contentDocumentIds.add(link.ContentDocumentId);
            }
            List<ContentVersion> uploadedCvList = [SELECT Title, RecordTypeId, PathOnClient, ContentDocumentId
                                                   FROM ContentVersion WHERE contentDocumentId IN : contentDocumentIds];
            Set<String> existContentDocumentId = new Set<String>();
            for(ContentVersion uploadedCv : uploadedCvList){
                String existFile = uploadedCv.Title;
                if(existFile.contains(recordType)){
                    existContentDocumentId.add(uploadedCv.ContentDocumentId);
                }
            }
            if(existContentDocumentId.size()>0){
                ContentDocument relatedDocuments = [SELECT Id FROM ContentDocument WHERE Id =:existContentDocumentId  LIMIT 1];
                delete relatedDocuments;
            }
            insert cv; // Make DML after null check
            for(ContentVersion cvIterator : [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id]){
                ContentDocumentLink cdl = insertContentDocumentLink(cvIterator.ContentDocumentId, recordId);
                cdlList.add(cdl);
            }
            if(!cdlList.isEmpty()){
                insert cdlList;
            }
            string fileId; // Variable should be declared at the begning of the method
            if(title.contains('_Employee_Docs')){
                fileId = getEmpNameAndFolderId[0].Employee_Docs__c; 
            }
            else{
                fileId = getEmpNameAndFolderId[0].Company_Docs__c;  
            }
            System.debug('-folderName---------'+folderName);
             System.debug('----title------'+title);
             System.debug('folderId----------'+folderId);
             System.debug('------fileId----'+fileId);
            deleteFileWithNamedCredential(folderName, title, folderId,fileId);
            Map<String, String> fileDetailMap = new Map<String, String>();
            fileDetailMap.put('title', title);
            fileDetailMap.put('folderId', folderId);
            fileDetailMap.put('mimeType', mimeType);
            fileDetailMap.put('recordId', recordId);
            return fileDetailMap;
        } catch(DMLException ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    /**
    * @description : method is used to delete the file from google drive
    * @param : String folderName, String filename, String folderId, String fileId - Contains folderName, filename, folderId, fileId of file
    * @return : NA
    */   
    @Future(callout=true)
    private static void deleteFileWithNamedCredential(String folderName, String filename, String folderId, String fileId) {
        System.debug('fileId---155--->'+fileId);
        System.debug('folderName---155--->'+folderName);
        System.debug('filename---155--->'+filename);
        System.debug('folderId---155--->'+folderId);
        Integer statusCode ;
        String getResponseBody;
        Map<String, String> headerParamMap = new Map<String, String>();
        List<Google_drive__mdt> googleDrive = [SELECT Id, Application__c, Content_Type__c, Endpoint__c, Header__c,
                                                      Request_Method__c, Bearer__c, MasterLabel FROM Google_drive__mdt 
                                                WHERE MasterLabel = 'Delete File From Google Drive'];
        if(googleDrive.size()>0){
            headerParamMap.put('Content-length',googleDrive[0].Content_Type__c);
            HTTPCalloutServiceParamDAO serviceParam = new HTTPCalloutServiceParamDAO(googleDrive[0].Endpoint__c+fileId, googleDrive[0].Request_Method__c, googleDrive[0].Endpoint__c+fileId, '', null, headerParamMap, 12000);
            HTTPCalloutService calloutService = new HTTPCalloutService(serviceParam);
            HTTPResponse response  = calloutService.sendRequest();
            getResponseBody = response.getBody();
            statusCode = response.getStatusCode();
        }
        if (statusCode == 204) {
            errorHandling(getResponseBody, googleDrive[0].Endpoint__c+fileId);
            
        } else {
            errorHandling(getResponseBody, googleDrive[0].Endpoint__c+fileId);
            
        }       
    }
    
    
    /**
    * @description : method is usedin Lightning web component to get Field Label Name
    *  @param : NA 
    * @return : List<FieldLabelForCombobox> // Need to be more detailed
    */ 
    @AuraEnabled
    public static List<FieldLabelForCombobox> getFieldLabelName(){
        List<FieldLabelForCombobox> fieldLabelList = new List<FieldLabelForCombobox>();
        List<EmployeeDocument__mdt> mdtList = [SELECT Document_Label__c, Order__c, DeveloperName FROM EmployeeDocument__mdt ORDER BY Order__c];
      try{
            if(mdtList.size()>0){
                for(EmployeeDocument__mdt empDetail : mdtList){
                    FieldLabelForCombobox fieldLabel = new FieldLabelForCombobox();
                    fieldLabel.Label = empDetail.Document_Label__c;
                    fieldLabel.Value = empDetail.DeveloperName+'__c';
                    fieldLabelList.add(fieldLabel);
                }
                 return fieldLabelList;
            }
        }
        catch(Exception ex){
        throw new AuraHandledException(ex.getMessage());
        }
        return null;
    }
        
    /**
    * @description : method is used to  remove Id And Extension Of Files
    * @param : String fileName - Contains fileName
    * @return : String // Need to be more detailed
    */     
    public static String removeIdAndExtensionOfFiles(String fileName){
        String fileNameWithoutExtension;
        Pattern regexPattern = Pattern.compile('_(.*?)\\.');
        try{// Param need to do null check 
            Matcher matcher = regexPattern.matcher(filename);
            if (matcher.find()) {
                fileNameWithoutExtension = matcher.group(1);
                return fileNameWithoutExtension;
            } 
        }
        catch(DMLException ex) {
            System.debug(ex.getMessage());
            return ex.getMessage();
         }
         return null;
    }
    
    /**
    * @description : method is used insert Content Version
    * @param : String versionData, String title, String pathOnclient, String recordType, String recordId - Contains versionData,title,pathOnclient,recordType of file and recordId of Employee Document object
    * @return : ContentVersion
    */ 
    private static ContentVersion insertContentVersion(blob versionData, String title, String pathOnclient, String recordId, String recordType){
        try{ // Param need to do null check 
            Employee_Document__c  employeeId = [ SELECT Employee__r.EMPLOYEE_ID__c FROM Employee_Document__c WHERE Id =:recordId];
            ContentVersion cv = new ContentVersion(); // Variable name should be more clear
            cv.versionData = versionData;
            cv.Title = title;
           if(title.contains('_Employee_Docs')){
              cv.RecordTypeId = SchemaUtility.getRecordTypeName('ContentVersion','Employee Docs'); 
           }else{
             cv.RecordTypeId = SchemaUtility.getRecordTypeName('ContentVersion','Company Docs');
           }
            cv.PathOnClient = pathOnclient;
            return cv;
        }
        catch(DMLException ex) {
           System.debug(ex.getMessage());
        }
        return null;
    }

    /** 
    * @description : method is used insert Http Log for errorHandling
    * @param : String getResponseBody, String requestBody -  Contains getResponseBody  and requestBody 
    * @return : NA
    */ 
    private static void errorHandling(String getResponseBody, String requestBody ){
        Http_Log__c httpLog = new Http_Log__c();
        httpLog.Status__c = HRMS_Constants.ERROR_STATUS ;
        httpLog.Response__c = getResponseBody;
        httpLog.Request__c = requestBody;
        httpLog.Event__c = HRMS_Constants.GOOGLE_DRIVE_DELETE_EVENT ;
        httpLog.Name =  HRMS_Constants.GOOGLE_DRIVE_DELETE_EVENT ;
        if(httpLog != null){
            insert httpLog;
        }
    }
       
    /** 
    * @description : method is used insert ContentDocument Link
    * @param : String ContentDocumentId,String recordId -  Contains ContentDocumentId  and recordId of Employee Document Object
    * @return : ContentDocumentLink
    */  
    private static ContentDocumentLink insertContentDocumentLink(String ContentDocumentId, String recordId){
        ContentDocumentLink cdl = new ContentDocumentLink(); // Variable name should be more clear
        cdl.ContentDocumentId = ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        return cdl;
    }

    public class FieldLabelForCombobox{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
    }  
}