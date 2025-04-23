/**
* @description : The handler is used by the lightning web components UploadDocuments
* @author : Aakash Mathur - HRMS
* @date  : 26th Oct 2023
* @modified by: Aakash Mathur 
* @modified date: 25th Nov 2023
*/
public class DocumentsUpload {
        
    /** 
    * @description this method is responsible for saving Attested files
    * @author : Aakash Mathur - HRMS
    * @param : String base64, String fileName, String recordId - contains base64,fileName and recordId of document
    * @return String - returns the created ContentDocumentLink Id 
    */
    
    // saveFiles and saveNonAttestedFile both method are doing similar thing can you please make it into a single method.
    @AuraEnabled
    public static String saveFiles(String base64, String fileName, String recordId) {
          // updateEmployeeDoc(recordId);
        Boolean nonAttested = false; 
        Boolean attested = true;  
       try{ 
           ContentVersion cv = createContentVersion(base64, fileName, recordId, nonAttested, attested);  // variable name should be meaningful.
            ContentDocumentLink cdl = createContentLink(cv.Id, recordId);  // variable name should be meaningful.
            if (cv == null || cdl == null) { 
                return null;
            }
            updateEmployeeDoc(recordId);
            return cdl.Id;
       }
       catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        } 
    }
        
    /** 
    * @description : this method is responsible for saving NonAttestedFile.
    * @param : String base64, String docName, String recordId - contains base64,docName and recordId of document
    * @return : String  ContentDocumentLink Id
    */   
    @AuraEnabled
    public static String saveNonAttestedFile(String base65, String docName, String recordId) {
        Boolean nonAttested = true;
        Boolean attested = false;
        try{
            ContentVersion cv = createContentVersion(base65, docName, recordId, nonAttested, attested);
            ContentDocumentLink cdl = createContentLink(cv.Id, recordId);  // variable name should be meaningful.
            if (cv == null || cdl == null) { 
                return null;
            }
            return cdl.Id;
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        } 
    }
    
   /**
    * @description : Creates a content version from a given file's base64 and name
    * @param : String base64, String fileName , String recordId ,Boolean attested ,Boolean nonAttested- contains base64,fileName , recordId of document and attested ,nonAttested ContentDocument
    * @return : ContentVersion - returns the newly created ContentVersion, or null
    */
    private static ContentVersion createContentVersion(String base64, String fileName, String recordId, Boolean nonAttested, Boolean attested) {
        ContentVersion cv = new ContentVersion();  // variable name should be meaningful.
        try{
            List<Employee_Document__c>  employeeId = [ SELECT Employee__r.EMPLOYEE_ID__c FROM Employee_Document__c WHERE Id =:recordId LIMIT 1];
            cv.VersionData = EncodingUtil.base64Decode(base64);
            if(!nonAttested && attested){
                cv.RecordTypeId = SchemaUtility.getRecordTypeName('ContentVersion','Company Docs');
                cv.Title = employeeId[0].Employee__r.EMPLOYEE_ID__c +'_'+fileName +'_Company_Docs';
            }
            if(nonAttested && !attested){
                cv.RecordTypeId = SchemaUtility.getRecordTypeName('ContentVersion','Employee Docs');
                cv.Title = employeeId[0].Employee__r.EMPLOYEE_ID__c +'_'+fileName +'_Employee_Docs';
            }
            cv.PathOnClient = fileName ;
            if(cv != null){
                insert cv;
            }
            return cv;
        }catch(DMLException ex) {
            System.debug(ex);
            return null;
        }
    }
     
    /**
    * @desc Creates a content link for a given ContentVersion and record
    * @param : String contentVersionId , String recordId - contains contentVersionId and recordId of document
    * @return : ContentDocumentLink - returns the newly created ContentDocumentLink, or null
    */
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        ContentDocumentLink cdl = new ContentDocumentLink();  // variable name should be meaningful.
        if((contentVersionId == null) || (recordId == null)) { 
            return null;
        }
        try {
            cdl.ContentDocumentId = [SELECT ContentDocumentId  FROM ContentVersion  WHERE Id =:contentVersionId].ContentDocumentId;
            cdl.LinkedEntityId = recordId;
            cdl.ShareType = 'V';
            if(cdl != null){
                insert cdl;
            }
           updateEmployeeDoc(recordId);
            return cdl;
        } catch(DMLException ex) {
            System.debug(ex);
            return null;
        }
    }
    
    /**
    * @desc this method is responsibale to update Employee Document when both file is uploded 
    * @author : Aakash Mathur - HRMS
    * @param : String recordId - Employee Document record Id string 
    *@return : NA
    */
      @AuraEnabled
    public static void updateEmployeeDoc(String recordId){
        try{
            System.debug('updateEmployeeDoc--------call sucessfull--------------'+recordId);
            List<ContentDocumentLink> conLinkList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:recordId];
            Set<Id> contentDocumentIds = new Set<Id>();
            if(conLinkList.size()>0){
                for(ContentDocumentLink link : conLinkList) {
                    contentDocumentIds.add(link.ContentDocumentId);
                } 
            }
            List<Contentversion> cont =  [SELECT Id, ContentDocumentId FROM Contentversion WHERE ContentDocumentId IN : contentDocumentIds ];  // variable name should be meaningful. 
            if(cont.Size()>= 2){
                Employee_Document__c employeeDoc = new Employee_Document__c();
                employeeDoc.File_Uploaded__c = true;
                employeeDoc.Id = recordId;
                if(employeeDoc != null){
                    update employeeDoc;
                }
            }
        }
        catch(Exception e){
            System.debug('Error--'+e.getMessage());
        }     
    }
}