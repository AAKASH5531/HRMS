/**
* @description : The handler is used by the EmployeeTrigger
* @group : EmployeeTrigger
* @created By : Ankita Dhamgaya
* @created date : 03th Oct 2023
* @modified by: Akash Sahani
* @modified date: 25th Nov 2023
*/
public with sharing class EmployeeBeforeUpdateHandler extends TriggerHandlerBase{
    List<Employee__c> newRecords;
    Map<ID, Employee__c> oldRecordsMap;
    List<Employee__c> empListForUpdate;
    
    public EmployeeBeforeUpdateHandler() {
        empListForUpdate = new List<Employee__c>();
    }
        
    /**
    * @description : The method is executed from EmployeeTrigger only on BeforeUpdate of the Employee object
    * @param : List<SObject> newList - Contains Employee object mapping from Trigger.new
    * @return : NA
    */
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('EmployeeBeforeUpdateHandler qualifyStartingRecords');
        newRecords = (List<Employee__c>) newList;
        oldRecordsMap = (Map<ID, Employee__c>) oldMap;
    }
    
    /**
    * @description : The method is executed from EmployeeTrigger only in the EmployeeBeforeUpdateHandler.
    * @param : NA
    * @return : NA
    */
    public override void start() {
        empListForUpdate = validateEmployeeIdAndtotalExperienceInsert(newRecords, oldRecordsMap);
    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }
    
    /**
    * @description : The method is executed from EmployeeTrigger only to check whether the old Employee ID has changed or not in the Employee Record.
    * @param : {List<Employee__c>} empRecordList, {Map<Id, Employee__c>} oldMap contains new List of Employee, old map of Employee Id and Employee
    * @return : list of Employee (List<Employee__c>)
    */
    private static List<Employee__c> validateEmployeeIdAndtotalExperienceInsert(List<Employee__c> empRecordList, Map<Id, Employee__c> oldRecordMap){
        try{
            for (Employee__c newEmpRecord : empRecordList) {
                Employee__c oldEmpRecord = oldRecordMap.get(newEmpRecord.Id);
                if(newEmpRecord.Date_of_Joining__c != oldEmpRecord.Date_of_Joining__c){
                    Decimal formattedExperience = 0;
                    Date joiningDate = newEmpRecord.Date_of_Joining__c;
                    List<Employee__c> empListForUpdate = new List<Employee__c>();
                    Integer totalMonthsOfJoiningDate = (Date.today().year() - joiningDate.year()) * 12 + (Date.today().month() - joiningDate.month()); //calculate the total months of Joining date
                    system.debug('totalMonthsOfJoiningDate =====>   '+totalMonthsOfJoiningDate);
                    Integer totalMonthsOfPastExperience = calculateTotalMonth(oldEmpRecord.Past_Experience__c);// calculate total months of Past Experience from old past Experience value
                    system.debug('totalMonthsOfPastExperience =====>   '+totalMonthsOfPastExperience);
                    Integer totalExperienceInMonths = totalMonthsOfJoiningDate + totalMonthsOfPastExperience;  
                    system.debug('totalExperienceInMonths =====>   '+totalExperienceInMonths);
                    Integer totalYears = totalExperienceInMonths / 12;
                    system.debug('totalYears =====>   '+totalYears);
                    Integer totalMonthsRemainder = totalExperienceInMonths - (totalYears * 12);
                    system.debug('totalMonthsRemainder =====>   '+totalMonthsRemainder);
                    if (totalMonthsRemainder < 10) {
                        formattedExperience = Decimal.valueOf(totalYears + '.0' + totalMonthsRemainder);
                        system.debug('formattedExperience  <10 =====>   '+formattedExperience);
                    } else {
                        formattedExperience = Decimal.valueOf(totalYears + '.' + totalMonthsRemainder);
                        system.debug('formattedExperience =====>  >10 '+formattedExperience);
                    }
                    system.debug('Experience Before Upadte===========>   '+formattedExperience);
                    newEmpRecord.Total_Experience__c = formattedExperience;
                }
                if (newEmpRecord.EMPLOYEE_ID__c != oldEmpRecord.EMPLOYEE_ID__c) {
                    newEmpRecord.addError('Can not update Employee Id !');
                }
                if(oldEmpRecord.Employee_Activity_Status__c ==  'Active' && newEmpRecord.Employee_Activity_Status__c == 'On Notice'){
                    newEmpRecord.Before_One_Business_Day__c = CalculateBusinessDayWithHoliday.getBusinessday(newEmpRecord.Date_of_Relieving__c, 1); 
                    newEmpRecord.Before_Seven_business_Day__c = CalculateBusinessDayWithHoliday.getBusinessday(newEmpRecord.Date_of_Relieving__c, 7); 
                }
            }
            return empRecordList;
        } catch (Exception ex) {
            system.debug('An unexpected exception occurred: ' + ex.getMessage());
            return null; 
        }
    }
    
    /**
    * @description : The method is executed from beforeUpdateEmpRecord only to calculate the month.
    * @param : Decimal - Contains year in the form of decimal
    * @return : List of Employee
    */
    private static Integer calculateTotalMonth(Decimal value){
        system.debug('value====>  '+value);
        if(value != null){
            Integer years = Integer.valueOf(value);
            Decimal monthsDecimal = (value - years) * 100; 
            Integer months = Integer.valueOf(monthsDecimal);
            Integer totalMonths = (years * 12) + months;  
            return totalMonths;
        }
        return 0;
    }
}