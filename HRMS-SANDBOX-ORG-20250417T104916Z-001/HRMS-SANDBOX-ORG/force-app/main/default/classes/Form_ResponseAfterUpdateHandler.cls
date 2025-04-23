/**
* @description : The Form_ResponseAfterUpdateHandler is used by the FormResponseTrigger
* @group : FormResponseTrigger
* @author : Rishabh Singh - HRMS
* @created date : 30th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 01th Dec 2023
*/

public with sharing class Form_ResponseAfterUpdateHandler extends TriggerHandlerBase{
    List<Form_Response__c> newRecords;
    Map<Id, Form_Response__c> oldMapRecord; 
    List<Comp_Off_Request__c> compOffRequestList;
    List<Skills__c> skillsList;
    List<Attendance__c> attendanceList;

    public Form_ResponseAfterUpdateHandler() {
        compOffRequestList = new List<Comp_Off_Request__c>();
        skillsList = new List<Skills__c>();
        attendanceList = new List<Attendance__c>();

    }

    /**
    * @description : The method is executed from FormResponseTrigger only on AfterUpdate of the Form_Response__c object.
    * @param : List<SObject> newList, Map<Id, sObject> oldMap - Contains Employee object mapping from Trigger.new ,Trigger.oldMap
    * @return : NA
    */
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<Id, sObject> newMap, Map<Id, sObject> oldMap) {
        Diagnostics.push('Form_ResponseAfterUpdateHandler qualifyStartingRecords');
        newRecords = (List<Form_Response__c>) newList;
        oldMapRecord = (Map<Id, Form_Response__c>) oldMap;

    }

    /**
    * @description : The method is executed from FormResponseTrigger only in the Form_ResponseAfterUpdateHandler.
    * @param : NA
    * @return : NA
    */
    public override void start() {
        Set<Id> setOfResponseId = new Set<Id>();
        for(Form_Response__c responseRecord : newRecords){
            if(responseRecord.Approval_Status__c == 'Approved' && responseRecord.Approval_Status__c != oldMapRecord.get(responseRecord.Id).Approval_Status__c ){
                setOfResponseId.add(responseRecord.Id);
            }
        }
        compOffRequestList = updateCompOffRequest(setOfResponseId);
        skillsList = createSkillRecord(setOfResponseId);
        attendanceList = createAttendanceRecord(setOfResponseId);

    }

    /**
    * @description : The method is executed from FormResponseTrigger only during the updating of an compOffRequestList AND  inserting of an skillsList.
    * @param : Boolean - Contains fromStart from TriggerHandlerBase
    * @return : NA
    */
    public override void finish(Boolean fromStart) {
        if(fromStart) {
            if(!compOffRequestList.isEmpty()){
                update compOffRequestList;
            }
            if(!skillsList.isEmpty()){
                insert skillsList;
            }
            if(!attendanceList.isEmpty()){
                insert attendanceList;
            }
        }
        Diagnostics.pop();
    } 

    /**
    * @description : The method is executed from start only to Update an compOffRequest record.
    * @param : List<Form_Response__c> storeResponseNewList, Map<Id, Form_Response__c> oldMapRecord - Contains Comp_Off_Request__c object mapping from Trigger.new, Trigger.oldMap
    * @return : List<Comp_Off_Request__c> -compOffRequestList
    */
    private static List<Comp_Off_Request__c> updateCompOffRequest(Set<Id> setOfResponseId){
        List<Comp_Off_Request__c> compOffRequestList = new List<Comp_Off_Request__c>();
        List<Response__c>  compOffResponseList = getQueryRecord('Apply Comp-off', setOfResponseId);
        if(!compOffResponseList.isEmpty()){
            List<String> listOfCompoffId;
            Map<String, Date> mapOfDate = new Map<String, Date>();                       
            Date startDate;
            Date endDate;
            for(Response__c res : compOffResponseList){
                if(res.Question__r.Name == 'Available Comp-Off'){
                    if(res.Response_Message__c != null){
                        listOfCompoffId = res.Response_Message__c.split(',');
                    }
                }
                if(res.Question__r.Name == 'Start Date'){
                    if(res.Response_Message__c != null ){
                        startDate = Date.valueOf(res.Response_Message__c);
                    }
                }
                if(res.Question__r.Name == 'End Date'){
                    if(res.Response_Message__c != null){
                        endDate = Date.valueOf(res.Response_Message__c);
                    }
                }
            }
            for(Integer i = 0; i < listOfCompoffId.size(); i++){
                mapOfDate.put(listOfCompoffId[i], startDate+i);
                if(!listOfCompoffId.isEmpty() && !mapOfDate.isEmpty()){
                    Comp_Off_Request__c comp = new Comp_Off_Request__c();
                    comp.Id = listOfCompoffId[i];
                    comp.Date_of_Consumed__c = mapOfDate.get(listOfCompoffId[i]);
                    comp.Comp_Off_Leave_Status__c = 'Invalid';
                    compOffRequestList.add(comp);
                }   
            }
        }
        return compOffRequestList;
    } 

    /**
    * @description : The method is executed from start only to insert an Skills__c record.
    * @param : List<Form_Response__c> storeResponseNewList, Map<Id, Form_Response__c> oldMapRecord - Contains Comp_Off_Request__c object mapping from Trigger.new, Trigger.oldMap
    * @return : List<Skills__c> -skillsList
    */
    private static List<Skills__c> createSkillRecord(Set<Id> setOfResponseId ){
        List<Skills__c> skillsList = new List<Skills__c>();
        List<Response__c>  addSkillsResponseList = getQueryRecord('Add Skills', setOfResponseId);
        List<Skills__c> skillList = [SELECT Id, NAME FROM Skills__c WHERE Name != null];
        List<String> nameList = new List<String>();                                                    
        for(Skills__c skillsObj : skillList){
            nameList.add(skillsObj.Name);
        }
        if(!addSkillsResponseList.isEmpty()){
            for(Response__c res : addSkillsResponseList){
               if(res.Question__r.Name == 'Other Skill'){
                    if(res.Response_Message__c != null && !nameList.contains(res.Response_Message__c)){
                        Skills__c skillObj = new Skills__c();
                        skillObj.Name = res.Response_Message__c;
                        skillsList.add(skillObj);
                    }
                } 
            }
        }
        return skillsList;
    }
    
    private static List<Attendance__c> createAttendanceRecord(Set<Id> setOfResponseId){
        List<Employee__c> employeeList = [SELECT Id From Employee__c WHERE User_Associated__c =: UserInfo.getUserId()];
        List<Attendance__c> attendanceList = new List<Attendance__c>();
        Date leaveDateFrom;
        Date LeaveDateTo;
        String leaveType;

        List<Response__c>  leaveResponseList = getQueryRecord('Leave', setOfResponseId);
        if(!leaveResponseList.isEmpty()){
            for(Response__c res : leaveResponseList ){
                if(res.Question__r.Name == 'Type of Leave'){
                    if(res.Response_Message__c != null){
                        leaveType = res.Response_Message__c;
                        system.debug('leaveType'+leaveType);
                    }
                    
                }
                if(res.Question__r.Name == 'Leave Date From'){
                    if(res.Response_Message__c != null){
                        leaveDateFrom = Date.valueOf(res.Response_Message__c);
                        system.debug('leaveDateFrom'+leaveDateFrom);
                	}
                }
                if(res.Question__r.Name == 'Leave Date To'){
                    if(res.Response_Message__c != null){
                        LeaveDateTo = Date.valueOf(res.Response_Message__c);
                        system.debug('LeaveDateTo'+LeaveDateTo);

                	}
                }
                if(LeaveDateTo != null && leaveDateFrom != null){
                    Integer numberDaysDue = leaveDateFrom.daysBetween(LeaveDateTo);
                    System.debug('numberDaysDue -> '+numberDaysDue);
                    for(integer i = 0; i < numberDaysDue + 1; i++){
                        Date tempDate = leaveDateFrom.addDays(i);
                        Attendance__c obj = new Attendance__c();
                        if(leaveType == 'PL' && i==0){
                            obj.Attendance_Type__c = 'AB';
                            obj.Attendance_Sub_Type__c = 'PL';
                        }
                        if(leaveType == 'PL' && i> 0){
                            obj.Attendance_Type__c = 'AB';
                        }
                        
                        if(leaveType == 'SL'){
                            obj.Attendance_Type__c = 'AB';
                            obj.Attendance_Sub_Type__c = 'SL';
                            
                        }
                        if(leaveType == 'HD'){
                            obj.Attendance_Type__c = 'HD';
                        }
                        if(leaveType == 'FL'){
                            obj.Attendance_Type__c = 'FL';
                        }
                        obj.Attendance_Marked_Date__c = tempDate;
                        obj.Employee__c =employeeList[0].Id;
                        attendanceList.add(obj);
                    }
                }
                
            }
            
        }

        return attendanceList;
    }


    private static List<Response__c>  getQueryRecord(String responseFormName,  Set<Id> setOfResponseId){
        List<Response__c>  compOffResponseList = [SELECT Id, Response_Message__c, Question__r.Name, Form_Response__r.Name
                                                  FROM Response__c WHERE Form_Response__r.Name = : responseFormName AND  Form_Response__c
                                                  IN : setOfResponseId];

        return compOffResponseList;
    }
}