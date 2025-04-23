/**
* @description :EventTriggerHelperUtility is used by the EventTrigger
* @author : Aakash Mathur - HRMS
* @date  : 12th Oct 2023
* @modified by: Aakash Mathur 
* @modified date: 15th Nov 2023
*/
public class EventTriggerHelperUtility {
        
    /**
    * @description this method is call After Event is Insert // First letter should be capital.
    * @param : List<Event> newEventList - new List of Event
    * @ return List<Event> newEventList // Make it more detailed.
    */ 
    public static List<Event> eventOnGoogleCalendar(List<Event> newEventList, Boolean isUpdate) {
        String request = createJsonForEvent(newEventList);
        if(isUpdate && SchemaUtility.checkRecursive &&  newEventList.size() > 0 ){
            eventOnGoogleCalendarCallout(request, newEventList[0].Id, newEventList[0].Event_Id__c);
        }
        if(!isUpdate && newEventList.size() > 0 ){
            eventOnGoogleCalendarCallout(request, newEventList[0].Id, ''); 
        }
       return newEventList;
    }
    
    /** 
    * @description: this method is responsible for creating Json for the Event
    * @param : List<Event> newEventList - new List of Event
    * @ return: String   // Explain it in brief
    */    
    private static String createJsonForEvent(List<Event> newEventList){
        GoogleCalendarIntegrationDTO  googleCalendarDto =  new GoogleCalendarIntegrationDTO();
        Set<Id> eventId = new Set<Id>();
        List<EventRelation> eventRelationListToInsert =  new List<EventRelation>();
        if(!newEventList.isEmpty()){
           for(Event ev : newEventList){
            eventId.add(ev.Id);
        }   // Code should be formated.
        }
        GoogleCalendarIntegrationDTO.Start start = new GoogleCalendarIntegrationDTO.Start(); // Variable Name needs bit more clear.
        GoogleCalendarIntegrationDTO.Tram_end  tram_end = new  GoogleCalendarIntegrationDTO.Tram_end();
        List<GoogleCalendarIntegrationDTO.Attendees> attendeesList = new  List<GoogleCalendarIntegrationDTO.Attendees>();
        List<EventRelation> eventRelationList = [SELECT Id, Relation.Email, Relation.Name, 
                                                        RelationId FROM EventRelation Where eventId  IN : eventId AND Relation.Email != null];
        for(Event eventRec : newEventList){
            for(EventRelation evRelation : eventRelationList ){
                GoogleCalendarIntegrationDTO.Attendees attendees = new GoogleCalendarIntegrationDTO.Attendees();
                attendees.email = evRelation.Relation.Email;
                attendees.displayName = evRelation.Relation.Name;
                attendeesList.add(attendees);
            }
            start.tram_dateTime = eventRec.StartDateTime;
            start.timeZone = String.valueOf(UserInfo.getTimeZone());
            tram_end.timeZone = String.valueOf(UserInfo.getTimeZone());
            tram_end.tram_dateTime = eventRec.EndDateTime;
            googleCalendarDto.summary = eventRec.Subject;
            googleCalendarDto.start = start;
            googleCalendarDto.tram_end = tram_end;
            googleCalendarDto.attendees = attendeesList;
        }
        String googleCalendarString = JSON.serialize(googleCalendarDto) ;
        return googleCalendarString.remove('tram_');
    }
        
    /**
    * @description this method is usein API Callout to create or update the Event on Google Calendar
    * @param : String request, String recordId, String eventId - contains request recordId and eventId.   
    * @ return NA
    */  
    @future(callout=true)
    private static void eventOnGoogleCalendarCallout(String request, String recordId, String eventId){
        String getResponseBody;
        Integer statusCode;
        Map<String, String> headerParamMap = new Map<String, String>();
        List<Google_Calendar__mdt> googleCalendar = [SELECT Id, Application__c, Endpoint__c, Header__c,
                                                            Request_Method__c, Bearer__c, MasterLabel FROM Google_Calendar__mdt
                                                     WHERE MasterLabel = 'Google Calendar Create Event'];
        headerParamMap.put('Authorization', googleCalendar[0].Bearer__c);
        headerParamMap.put('content-type', googleCalendar[0].Header__c);
        HttpRequest req = new HttpRequest();
        if(String.isBlank(eventId)  && googleCalendar.size()>0){
            HTTPCalloutServiceParamDAO serviceParam = new HTTPCalloutServiceParamDAO(googleCalendar[0].Endpoint__c, googleCalendar[0].Request_Method__c, request ,'', null, headerParamMap, 12000);
            HTTPCalloutService calloutService = new HTTPCalloutService(serviceParam);
            HTTPResponse response  = calloutService.sendRequest();
            getResponseBody = response.getBody();
            statusCode = response.getStatusCode();
        }
        else if(!String.isBlank(eventId)){
            HTTPCalloutServiceParamDAO serviceParam = new HTTPCalloutServiceParamDAO(googleCalendar[0].Endpoint__c+eventId+'/', 'PATCH', request, '', null, headerParamMap, 12000);
            HTTPCalloutService calloutService = new HTTPCalloutService(serviceParam);
            HTTPResponse response  = calloutService.sendRequest();
            getResponseBody = response.getBody();
            statusCode = response.getStatusCode();
        }
        if(statusCode == 200) {
            errorHandling(request, req.getBody());
            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(request);
            String eventIds = (String)responseMap.get('id');
            System.enqueueJob(new QueueableGoogleCalendarCallout(eventIds, recordId));
        }else {
            errorHandling(request, req.getBody());
        }
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
}