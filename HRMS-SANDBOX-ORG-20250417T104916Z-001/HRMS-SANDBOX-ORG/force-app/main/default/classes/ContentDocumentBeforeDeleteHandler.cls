/**
* @description : The handler is used by the ContentDocumentTrigger
* @group : ContentDocumentTrigger
* @author : Aakash Mathur - HRMS
* @Created On : 10 November 2023
* @modified by : Aakash Mathur 
* @modified date : 27th Nov 2023
*/
public with sharing class ContentDocumentBeforeDeleteHandler extends TriggerHandlerBase{
    List<ContentDocument> newRecords;
    
    public ContentDocumentBeforeDeleteHandler() {
        
    }
    
    /**
    * @description : Method will execute from ContentDocumentTrigger only on Before Delete of ContentDocument Object
    * @author : Aakash Mathur - HRMS 
    * @param : List<sObject> oldList - Contains ContentDocument object mapping from Trigger.old
    * @return : void
    */
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('ContentDocumentBeforeDeleteHandler qualifyStartingRecords');
        newRecords = (List<ContentDocument>) oldList;
    }
    
    public override void start() {
        deleteContentDocument(newRecords);
    }
    
    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }

    /**
    * @description : Method will execute from ContentDocumentTrigge to delete the document from google drive
    * @param : List<String> fileId  Contains  fileId  of ContentDocument 
    * @return : NA
    */   
    @Future(callout=true)
    private static void deleteFileWithNamedCredential(List<String> fileIds) {
        Integer statusCode ;
        String getResponseBody;
        Map<String, String> headerParamMap = new Map<String, String>();
        //Here first you need to check the param list size then after that perform any operation further.
        for(String fileId : fileIds){
            HttpRequest request = new HttpRequest();
            List<Google_drive__mdt> googleDrive = [SELECT Id, Application__c, Content_Type__c, Endpoint__c,
                                                          Header__c, Request_Method__c, Bearer__c, MasterLabel 
                                                   FROM Google_drive__mdt  WHERE MasterLabel = 'Delete File From Google Drive'];// This is not the right way making the soql query inside the loop. Maybe it will hit the soql query limit as per salesofrce limitations.
            if(googleDrive.size()>0){
                headerParamMap.put('Content-length', googleDrive[0].Content_Type__c);
                HTTPCalloutServiceParamDAO serviceParam = new HTTPCalloutServiceParamDAO(googleDrive[0].Endpoint__c+fileId, googleDrive[0].Request_Method__c, googleDrive[0].Endpoint__c+fileId, '', null, headerParamMap, 12000);
                HTTPCalloutService calloutService = new HTTPCalloutService(serviceParam);
                HTTPResponse response  = calloutService.sendRequest();
                getResponseBody = response.getBody();
                statusCode = response.getStatusCode();
            }            
         }
    }

    /**
    * @description : Method will execute from ContentDocumentTrigge to make dynamic query
    * @param : List<String> fieldNameList - Contains  fieldName of ContentDocument object
    * @return : String
    */   
    private static String createDynamicQuery(List<String> fieldNameList, String folderName){
        String query = 'SELECT ID';
        for (String fieldApiName : fieldNameList) {
            query += ', ' + fieldApiName;
        }
        query += ' FROM Store_Google_Drive_Folder_ID__c WHERE Name ='+'\''+folderName+'\'';
        system.debug('query ->  '+query);
        return query;
    }  
    
    /**
    * @description : Method will execute from ContentDocumentTrigger only on Before Delete of ContentDocument Object
    * @author : Aakash Mathur - HRMS 
    * @param : List<sObject> oldList - Contains ContentDocument object mapping from Trigger.old
    * @return : NA
    */   
    private static void deleteContentDocument(List<ContentDocument> newRecords){ 
        Set<String> setOfContentDocId = new set<String>();
        Set<String> setOfLinkedEntityId = new Set<String>();
        Map<String, Set<String>>  mapOfEmpIdContentDocSet = new Map<String, Set<String>> (); 
        Map<String, String> idAndtitleOFContentDocument = new Map<String, String>();
        Map<String, String> idAndNameOfEmpDocument = new Map<String, String>();
        Map<String, List<String>> empDocumentNameAndListOfApiNameOfStoreFileObj = new Map<String, List<String>>();
        try{
            if(newRecords.size()>0){
                for(ContentDocument contentDoc : newRecords){
                    setOfContentDocId.add(contentDoc.Id);
                    idAndtitleOFContentDocument.put(contentDoc.Id, contentDoc.Title);
                } 
            }
            List<ContentDocumentLink> contentLinkList = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN: setOfContentDocId];  
            for(ContentDocumentLink cdl : contentLinkList){
                if(cdl.LinkedEntityId.getSObjectType() == Employee_Document__c.sObjectType){
                    setOfLinkedEntityId.add(cdl.LinkedEntityId);
                    Set<string> setOfcontentDocument = new Set<String>();
                    if(mapOfEmpIdContentDocSet.containsKey(cdl.LinkedEntityId)){
                        setOfcontentDocument = mapOfEmpIdContentDocSet.get(cdl.LinkedEntityId);
                    }
                    setOfcontentDocument.add(cdl.ContentDocumentId);
                    mapOfEmpIdContentDocSet.put(cdl.LinkedEntityId, setOfcontentDocument);
                }
            }
            for(Employee_Document__c empDoc : [SELECT Id, Name FROM Employee_Document__c WHERE ID IN: setOfLinkedEntityId]){
                idAndNameOfEmpDocument.put(empDoc.ID, empDoc.Name);
            }
            for(ContentDocumentLink cdl : contentLinkList){
                Set<String> getContentDocumentSet = new Set<String>();
                List<String> fileApiNameList = new List<String>();
                String folderName;
                if(idAndNameOfEmpDocument.containsKey(cdl.LinkedEntityId)){
                    folderName = idAndNameOfEmpDocument.get(cdl.LinkedEntityId);
                }
                if(mapOfEmpIdContentDocSet.containsKey(cdl.LinkedEntityId)){
                    getContentDocumentSet = mapOfEmpIdContentDocSet.get(cdl.LinkedEntityId);
                    for(String contentDocId : getContentDocumentSet){
                        if(idAndtitleOFContentDocument.containsKey(contentDocId)){
                            String fileName = idAndtitleOFContentDocument.get(contentDocId);
                            String fieldApiName = UpdateEmployeeDocument.removeIdAndExtensionOfFiles(fileName);
                            if(HRMS_Constants.FILE_NAME_AND_FIELD_MAPPING.containsKey(fieldApiName)){
                                fieldApiName = HRMS_Constants.FILE_NAME_AND_FIELD_MAPPING.get(fieldApiName);
                                fileApiNameList.add(fieldApiName);
                            }
                        }
                    }
                }
                String query = createDynamicQuery(fileApiNameList, folderName);
                List<String> fileIdList = new List<String>();
                for(Store_Google_Drive_Folder_ID__c storeGoogleFile : Database.query(query)){
                    for(String fieldName : fileApiNameList){
                        fileIdList.add(String.valueOf(storeGoogleFile.get(fieldName)));
                        storeGoogleFile.put(fieldName,'');
                    }
                }
                if(fileApiNameList.size()>0){
                    deleteFileWithNamedCredential(fileIdList);
                }       
            } 
        } catch(Exception ex){
            System.debug(ex.getMessage());
        }
    }
}