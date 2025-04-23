/**
* @description : The handler is used by the lightning web components UploadDocumentsOnGDrive
* @author : Aakash Mathur - HRMS
* @date  : 1th Oct 2023
* @modified by: Aakash Mathur 
* @modified date: 28th Nov 2023
*/

public class UploadDocumentsOnGDrive {
    public static List<String> recordTypeName = new List<String>();
   
    /** 
    * @description: this method is use in lightning web components UploadDocumentsOnGDrive to get record Id of Employee Document
    * @param : String recordId - Id of the Employee Document record 
    * @ return :String  uploaded or not uploaded
    */ 

    // Debug logs need to remove form this class and all the othere classes.
    @AuraEnabled
    public static String uploadFileOnDrive(String recordId) {
        Set<Id> contentDocumentIds = new Set<Id>();
        String folderId; // This may be create null error so at the time of variable declaraction atleast assing blank value into the string.
        String companyDocFolderID; // This may be create null error so at the time of variable declaraction atleast assing blank value into the string.
        String employeeDocFolderID;  // This may be create null error so at the time of variable declaraction atleast assing blank value into the string. 
        try{
            List<Employee_Document__c> empDocDetail = [SELECT Employee__c, Employee__r.Google_Drive_Parent_Folder_ID__c, Employee_Docs__c,
                                                              Company_Docs__c, RecordTypeId, Employee__r.Company_Docs_FolderID__c, 
                                                              Employee__r.Employee_Docs_FolderId__c FROM Employee_Document__c WHERE ID =:recordId];
         
            System.debug('---!empDocDetail.isEmpty()-----------------'+!empDocDetail.isEmpty());
            
             System.debug('-------------!String.isBlank(empDocDetail[0].Employee_Docs__c)-------'+!String.isBlank(empDocDetail[0].Employee_Docs__c));
             System.debug('-----------------!String.isBlank(empDocDetail[0].Company_Docs__c)---'+!String.isBlank(empDocDetail[0].Company_Docs__c));
             System.debug('--------empDocDetail.size)(------------'+empDocDetail.size());
            if(!empDocDetail.isEmpty() && !String.isBlank(empDocDetail[0].Employee_Docs__c) && !String.isBlank(empDocDetail[0].Company_Docs__c)){
                return 'not uploaded';
            }
            List<ContentDocumentLink> conLinkList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:recordId];
            if(conLinkList.size()>0){
                for(ContentDocumentLink conDoclink : conLinkList) {
                    contentDocumentIds.add(conDoclink.ContentDocumentId);
                }
            }
            List<Contentversion> contVersionList = [SELECT Id, RecordTypeId, Recordtype.Developername, ContentDocumentId FROM Contentversion WHERE ContentDocumentId IN : contentDocumentIds];
            if(contVersionList.size() > 0){
                for(Contentversion cv : contVersionList){
                    recordTypeName.add(cv.recordtype.developername);
                }
            }
            Map<String, String> recordTypeIdWithFolderId = createFolderOnDrive(recordId, empDocDetail[0].Employee__r.Google_Drive_Parent_Folder_ID__c);
            if(!contentDocumentIds.isEmpty()) {
                List<ContentVersion> cvList = [SELECT RecordType.DeveloperName, VersionData, RecordTypeId,
                                                      PathOnClient, Title, FileType, ContentSize FROM ContentVersion 
                                               WHERE ContentDocumentId IN : contentDocumentIds];
                // Without checking the list size don't use it blindly.
                for(ContentVersion cv : cvList){
                    String mimeType;
                    Blob csvFileBody = cv.VersionData;
                    String base64 = EncodingUtil.base64Encode(csvFileBody);
                    if(cv.RecordType.DeveloperName == 'Employee_Docs' && String.valueof(cv.Title).contains('_Employee_Docs')){
                        
                        employeeDocFolderID = recordTypeIdWithFolderId.get(cv.recordTypeId);
                        System.debug('==================>'+employeeDocFolderID);
                    }
                    else{
                        companyDocFolderID = recordTypeIdWithFolderId.get(cv.recordTypeId);
                    }
                    if(empDocDetail[0].Employee__r.Employee_Docs_FolderId__c != null && empDocDetail[0].Employee__r.Company_Docs_FolderID__c != null){
                        if(cv.RecordType.DeveloperName == 'Employee_Docs' ){
                            system.debug('In Employee Doc ===========');
                            calloutForUpload(base64, cv.Title, empDocDetail[0].Employee__r.Employee_Docs_FolderId__c, cv.FileType, recordId);
                        }
                        if(cv.RecordType.DeveloperName == 'Company_Docs' ){
                            system.debug('In Company Doc ===========');
                            calloutForUpload(base64, cv.Title, empDocDetail[0].Employee__r.Company_Docs_FolderID__c, cv.FileType, recordId);
                        }
                    }else{
                        folderId = recordTypeIdWithFolderId.get(cv.recordTypeId);
                        calloutForUpload(base64, cv.Title, folderId, cv.FileType, recordId);
                    }
                }
            } 
            System.debug('-----String.isBlank(recordTypeIdWithFolderId.get----------------'+!String.isBlank(recordTypeIdWithFolderId.get('parentFolder')));
            Employee_Document__c forUpdateDocDetail = new Employee_Document__c();
            if (!String.isBlank(recordTypeIdWithFolderId.get('parentFolder'))) {
                if(empDocDetail[0].Employee__r.Company_Docs_FolderID__c == null    && empDocDetail[0].Employee__r.Employee_Docs_FolderId__c == null){
                 Employee__c empUpdate = new Employee__c();
                 empUpdate.Id = empDocDetail[0].Employee__c;
                 empUpdate.Company_Docs_FolderID__c = companyDocFolderID;
                 empUpdate.Employee_Docs_FolderId__c =  employeeDocFolderID ;
                 empUpdate.Google_Drive_Parent_Folder_ID__c = recordTypeIdWithFolderId.get('parentFolder');
                      if(empUpdate != null){
                        System.debug('----empUpdate-95---'+empUpdate);
                        update empUpdate; // Null check is neccessary before making the DML
                        System.debug('empUpdate=======>'+empUpdate);
                       }
                }
                System.debug('-------------IN IF------------');
                
                System.debug('recordId-----78---->'+recordId);
                forUpdateDocDetail.Id = recordId;
                forUpdateDocDetail.emp__c = employeeDocFolderID;
                forUpdateDocDetail.com__c = companyDocFolderID;
                
                if(forUpdateDocDetail != null){
                   update forUpdateDocDetail;
                    System.debug('-------------IN IF-forUpdateDocDetail-----------'+forUpdateDocDetail);
                     System.debug('-------------IN IF-forUpdateDocDetail--Id---------'+forUpdateDocDetail.id);
                }
              
                
            }    
          
             if((recordTypeName.contains('Company_Docs') && String.isBlank(empDocDetail[0].Company_Docs__c)) || (recordTypeName.contains('Employee_Docs') && String.isBlank(empDocDetail[0].Employee_Docs__c))){
                System.debug('---------in if toast---------------');
                return 'uploaded';
            }else{
                return 'not uploaded';
            } 
            
            
        } 
        catch(Exception ex){
            System.debug('--Line Number------110---------------'+ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    /** 
    * @description : this method is responsible for creating parent folder on google drive
    * @param : String parentFolder,recordId - Contains parentFolder and recordId from UploadDocumentsOnGDrive
    * @return : Map<String, String>  contins parentFolder and parentFolderId    // Like description statement return also need to more detailed into all the clesses accept this.
    */ 

    @TestVisible
    private static Map<String, String> createFolderOnDrive(String recordId, String parentFolder) {
        System.debug('=====136======parentFolder======>'+parentFolder);
        String parentFolderId; // This may be create null error so at the time of variable declaraction atleast assing blank value into the string.
        Map<String, String> driveFolderNameWithId = new Map<String, String>();
        // Before using the param need to null check for the recordId
        try{
            List<Employee_Document__c> empList  = [SELECT Id, Employee_Docs__c, Company_Docs__c,  Employee__r.EMPLOYEE_ID__c, Employee__r.Name, Name, Employee__r.Employee_Docs_FolderId__c, Employee__r.Company_Docs_FolderID__c FROM Employee_Document__c WHERE Id =:recordId];
            String folderName = empList[0].Employee__r.EMPLOYEE_ID__c+'_'+empList[0].Employee__r.Name;  
            List<ContentDocumentLink> conLinkList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:recordId];
            Set<Id> contentDocumentIds = new Set<Id>();
            if(conLinkList.size() > 0){
                for(ContentDocumentLink conDocLink : conLinkList) {
                    contentDocumentIds.add(conDocLink.ContentDocumentId);
                }   
            }
            List<Contentversion> cvList =  [SELECT Id, Recordtype.Developername, ContentDocumentId FROM Contentversion WHERE ContentDocumentId IN : contentDocumentIds];
            if(String.isBlank(parentFolder)){  
                system.debug('Parent folder null ========> ');
                parentFolderId = createSubFolder(folderName, null);
            }else{
                system.debug('Parent folder exist ========> ');
                parentFolderId = parentFolder; 
            }
            String folderId ; // Avoid declaraction variable into meddile of the code any where. They need to declare at just after the method
            if(!String.isBlank(parentFolderId) && cvList.size() == 2 ){
                Integer i = 0;
                for(Contentversion con : cvList){
                    System.debug('empList[0].Employee__r.Employee_Docs_FolderId__c =========>'+empList[0].Employee__r.Employee_Docs_FolderId__c );
                    if(empList[0].Employee__r.Employee_Docs_FolderId__c  == null && empList[0].Employee__r.Company_Docs_FolderID__c == null ){
                       System.debug('con.RecordType.developerName====143===>'+con.RecordType.developerName);
                        /* if(i==1){
									folderId = createSubFolder('Company_Docs', parentFolderId);
								}
								if(i== 2){
									folderId = createSubFolder('Employee_Docs', parentFolderId);
								}*/

                        
                        folderId = createSubFolder(con.RecordType.developerName, parentFolderId);
                    }
                   System.debug('con.RecordType.developerName====174===>'+con.RecordType.developerName);

                    driveFolderNameWithId.put(con.recordTypeId, folderId);  
                }  
            }
           
            driveFolderNameWithId.put('parentFolder', parentFolderId);  
             System.debug('driveFolderNameWithId====139====>'+driveFolderNameWithId);
            return driveFolderNameWithId;
        }
        catch(DMLException ex) {
           System.debug(ex.getMessage());
        }
        return null;
    }
        
    /**
    * @description: this method is responsible for creating Sub Folder on google drive
    * @param : String folderName, parentFolderID- Contains folderName and parentFolderID from UploadDocumentsOnGDrive 
    * @ return  String folder Id
    */ 
    
    @TestVisible
    private static String createSubFolder(String folderName, String parentFolderId){
        String body;
        Integer statusCode ;
        String getResponseBody;
        Map<String, String> headerParamMap = new Map<String, String>();
        HttpRequest req = new HttpRequest(); // Variable name should be more meaningful.
        system.debug('folderName-==========> '+folderName);
        system.debug('parentFolderId-==========> '+parentFolderId);
        try{
            List<Google_drive__mdt> googleDrive = [SELECT Id, Application__c, Endpoint__c, Header__c, Request_Method__c, Bearer__c, MasterLabel FROM Google_drive__mdt  WHERE MasterLabel = 'Create Sub Folder'];
            if(parentFolderId != null){ 
                body = '{"name" : "'+ folderName +'","mimeType" : "application/vnd.google-apps.folder", "parents":["' + parentFolderId + '"]}';
            }else{
                body = '{"name" : "'+ folderName +'","mimeType" : "application/vnd.google-apps.folder"}'; 
            }
            headerParamMap.put('Authorization', googleDrive[0].Bearer__c+UserInfo.getSessionId());
            headerParamMap.put('content-type','application/json');
            if(googleDrive.size()>0){
                System.debug('body==170======>'+body);
                HTTPCalloutServiceParamDAO serviceParam = new HTTPCalloutServiceParamDAO(googleDrive[0].Endpoint__c, googleDrive[0].Request_Method__c, body, '', null, headerParamMap, 12000);
                HTTPCalloutService calloutService = new HTTPCalloutService(serviceParam);
                HTTPResponse response  = calloutService.sendRequest();
                getResponseBody = response.getBody();
                statusCode = response.getStatusCode();
                system.debug('for folder ==============> '+response.getStatusCode());
                System.debug('=====response.getBody()========178==========>'+response.getBody());
            }
            if (statusCode == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(getResponseBody);
                System.debug('-------------- (String) responseMap.get---->'+ (String) responseMap.get('Id'));
                return (String) responseMap.get('id');
            }
        } 
        catch(DMLException ex ) {
            return ex.getMessage();
        }
        return null;
    }

    /** 
    * @description : this method is responsible for Upload file on google drive
    * @param : String fileType, fileName , folderId, fileType, recordId- Contains from UploadDocumentsOnGDrive 
    * @return: NA
    */ 

    @future(callout=true)
    @TestVisible
    private static void calloutForUpload(String base64, String fileName , String folderId, String fileType, String recordId){
        system.debug('folder --------------> '+folderId);
        Integer statusCode ;
        String getResponseBody;
        String mimeType; 
        try { // First need to do null check on the param then use it.
            String folderName = [SELECT Name FROM Employee_Document__c WHERE ID =:recordId].Name;
            Map<String, String> headerParamMap = new Map<String, String>();
            if(HRMS_Constants.EXTENSION_TO_TYPE_MAP.containsKey(fileType.toLowerCase())){
                mimeType = HRMS_Constants.EXTENSION_TO_TYPE_MAP.get(fileType.toLowerCase());
            }
            fileType = mimeType;
            String boundary = '----------9889464542212';
            String delimiter = '\r\n--' + boundary + '\r\n';
            String close_delim = '\r\n--' + boundary + '--';
            String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{"title" : "' + fileName  + '", ' + ' "mimeType" : "' + mimeType + '",' + '"parents": [{"id":"'+ folderId + '"}]}' + delimiter + 'Content-Type: ' + fileType + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + base64 + close_delim;
            List<Google_drive__mdt> googleDrive = [SELECT Id, Application__c, Endpoint__c, Header__c, Request_Method__c, Bearer__c, MasterLabel FROM Google_drive__mdt  WHERE MasterLabel = 'Upload File on Google Drive'];
            if(googleDrive.size()>0){
                headerParamMap.put('Content-length', String.valueOf(body.length()));
                headerParamMap.put('content-type', 'multipart/mixed; boundary="' + boundary + '"');
                HTTPCalloutServiceParamDAO serviceParam = new HTTPCalloutServiceParamDAO(googleDrive[0].Endpoint__c, googleDrive[0].Request_Method__c, body, '', null, headerParamMap, 12000);
                HTTPCalloutService calloutService = new HTTPCalloutService(serviceParam);
                HTTPResponse response  = calloutService.sendRequest();
                getResponseBody = response.getBody();
                statusCode = response.getStatusCode();
                System.debug('Status: =======================>   ' + response.getStatusCode());
                System.debug('Response: =======================>   ' + response.getBody());
            }
            if(statusCode == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(getResponseBody);
                String fileNameWithoutExtension = UpdateEmployeeDocument.removeIdAndExtensionOfFiles(fileName );
                String fileId = (String) responseMap.get('id');
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
            }
        } 
        catch(DMLException ex) {
             System.debug(ex.getMessage());
        }
    }      
}