/**
* @description : EventTriggerHelperUtilityTest is responsible to test  EventTriggerHelperUtility class
* @author : Aakash Mathur - HRMS
* @date  : 17th Oct 2023
* @modified by: Aakash Mathur 
* @modified date: 27th Nov 2023
*/
@isTest 
private class EventTriggerHelperUtilityTest {
    
  /**
  * @description : Method will execute from EventTriggerHelperUtility  Cover after Insert Event On Google Calendar Postive Scenario 
  * @param : NA
  * @return : NA
  */
    @isTest
    private static void testAfterInsertCreateEventOnGoogleCalendar() {
        List<Employee__c> employeeList = new List<Employee__c>();
        List<ContentVersion> cvList = new List<ContentVersion>();
        List<Event> eventList  = new List<Event>();
        Employee__c employeeRec = TestDataFactory.employeeRecordCreate();
        employeeList.add(employeeRec);
        insert employeeList; // Without null check don't make any DML.
        Event eventRec =  TestDataFactory.createEvent();
        eventList.add(eventRec);
        insert eventList; // Without null check don't make any DML.
        Test.setMock(HttpCalloutMock.class, new UploadDocumentsOnGDriveMock());
        Test.startTest();
        List<Event> testEvents = [SELECT Id, Event_Id__c, Description, Subject, Type, StartDateTime, EndDateTime, Location FROM Event ]; //Independent query is not the right way of writting soql. 
        List<Event> resultEvents = EventTriggerHelperUtility.eventOnGoogleCalendar(testEvents, true);
        Test.stopTest();
        System.assertEquals(1, resultEvents.size(), 'The result list should have two events');
    }
    
    /*
    * @description : Method will execute from EventTriggerHelperUtility  Cover after Insert Event On Google Calendar Negative Scenario 
    * @param : NA
    * @author :Aakash Mathur - HRMS
    * @return : NA
    */
     @isTest
    private static void afterInsertCreateEventOnGoogleCalendarNegativeTest() {
        List<Event> eventList  = new List<Event>();
        Test.setMock(HttpCalloutMock.class, new GoogleCalendarMock());
        Test.startTest();
        List<Event> resultEvents = EventTriggerHelperUtility.eventOnGoogleCalendar(eventList, false);
        Test.stopTest();
        System.assertEquals(resultEvents.size(),0 , 'The result list should have one events');
    }
    
    /*
    * @description : Create a mock class to simulate the callout to Google Calendar API
    * @param : NA
    * @author :Aakash Mathur - HRMS
    * @return : HTTPResponse
    */
    public class GoogleCalendarMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id": "test-event-id", "status": "confirmed"}');
            res.setStatusCode(400);
            return res;
        }
    }
  }