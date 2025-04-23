/**
* @description :GoogleCalendarIntegrationDTO is the DTO of GoogleCalendarIntegration
* @author : Aakash Mathur - HRMS
* @date  : 1th Oct 2023
* @modified by: Aakash Mathur 
* @modified date: 15th Nov 2023
*/
public class GoogleCalendarIntegrationDTO {
    public List<Attendees> attendees;
    public String summary;	    //Meeting with Client
    public String description; //Discuss project
    public Start start;
    public Tram_end tram_end;
    public class Attendees {
        public String displayName;	//lllllll
        public String email;	    //abc@gmail.com
    }
    
    public class Start {
        public DateTime tram_dateTime;//2023-10-06T10:00:00Z
        public String timeZone;	    //America/Los_Angeles
    }
    
    public class Tram_end {
        public DateTime tram_dateTime;//2023-10-06T11:00:00Z
        public String timeZone;	    //America/Los_Angeles
    }
}