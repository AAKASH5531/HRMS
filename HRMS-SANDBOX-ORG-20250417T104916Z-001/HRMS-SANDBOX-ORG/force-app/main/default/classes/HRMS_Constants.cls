/**
* @description : Constant Class
* @author : Akash Sahani - HRMS
* @created date  : 25th Nov 2023
* @modified by: Akash Sahani
* @modified date: 25th Nov 2023
*/
public class HRMS_Constants {

    public static final String AC_STRING_FOR_EMPLOYEEID_PREFIX_FORMAT = 'AC';
    public static final String REHIRE_FIELDNAME = 'ReHire__c';
    public static final String CONTENT_VERSION_API = 'ContentVersion';
    public static final String SUCCESS_STATUS = 'Success';
    public static final String ERROR_STATUS = 'Error';
    public static final String GOOGLE_DRIVE_UPDATE_EVENT = 'GoogleDriveUpdate';
    public static final String GOOGLE_DRIVE_DELETE_EVENT = 'GoogleDriveDelete';
    public static final String GOOGLE_CALENDAR  = 'GoogleCalendarEvent';
    public static final String TIME_ZONE = 'America/Los_Angeles';
    public static final Map<String, String> EXTENSION_TO_TYPE_MAP = new Map<String, String>{'pdf' => 'application/pdf', 'csv'=> 'text/csv', 'jpg' => 'image/png', 'jpeg' => 'image/png', 'png' => 'image/png', 'zip'=> 'application/zip', 'xlsx'=> 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'xls'=> 'application/vnd.ms-excel', 'txt'=> 'text/plain'};
    public static final Map<String, String> FILE_NAME_AND_FIELD_MAPPING  = new Map<String, String>{'Aadhar Card'=> 'Aadhar_Card__c', 'PAN Card'=>'PAN_Card__c', 
                                                                                        'Additional Certifications'=>'Additional_Certifications__c', 'Diploma Certificate'=>'Diploma_Certificate__c',
                                                                                        'Diploma Marksheet'=>'Diploma_Marksheet__c', 'Driving License Or Passport'=>'Driving_License_Passport__c',
                                                                                        'Employee Image'=>'Employee_Image__c', 'Graduation Degree'=>'Graduation_Degree__c',
                                                                                        'Graduation Marksheets'=>'Graduation_Marksheets__c', 'High School Certificate'=>'High_School_Certificate__c',
                                                                                        'High School Marksheet'=>'High_School_Marksheet__c', 'In Hand Offer (If any)'=>'In_Hand_Offer_If_any__c',
                                                                                        'Increment Letters (Past or Current)'=>'Increment_Letters_Past_Current__c', 'Intermediate Certificate'=>'Intermediate_Certificate__c',
                                                                                        'Intermediate Marksheet'=>'Intermediate_Marksheet__c', 'Offer Letters (Past or Current)'=>'Offer_Letters_Past_Current__c',
                                                                                        'Post Graduation Degree'=>'Post_Graduation_Degree__c', 'Post Graduation Marksheets'=>'Post_Graduation_Marksheets__c',
                                                                                        'Relieving Letters (Past or Current)'=>'Relieving_Letters_Past_Current__c', 'Salary Slips (Last 3 Months)'=>'Salary_Slips_Last_3_Months__c',
                                                                                        'Training Or Internship Letters'=>'Training_Internship_Letters__c', 'Voter ID'=>'Voter_ID__c'};
                                                                                            
}