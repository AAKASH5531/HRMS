/**
* @description : The EmployeeBeforeInsertHandler is used by the EmployeeTrigger
* @group : EmployeeTrigger
* @created By : Ankita Dhamgaya
* @created date : 30th Oct 2023
* @modified by: Akash Sahani
* @modified date: 25th Nov 2023
*/
public with sharing class EmployeeBeforeInsertHandler extends TriggerHandlerBase{
    List<Employee__c> newRecords;
    List<Employee__c> employee;
    
    public EmployeeBeforeInsertHandler() {
        employee = new List<Employee__c>();
    }

    /**
    * @description : The method is executed from EmployeeTrigger only on BeforeInsert of the Employee object.
    * @param : List<SObject> newList - Contains Employee object mapping from Trigger.new
    * @return : NA
    */
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('EmployeeBeforeInsertHandler qualifyStartingRecords');
        newRecords = (List<Employee__c>) newList;
    }

    /**
    * @description : The method is executed from EmployeeTrigger only in the EmployeeBeforeInsertHandler.
    * @param : NA
    * @return : NA
    */
    public override void start() {
        employee = validateEmployeeIdAndInsertBusinessDay(newRecords);
    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }
    
    /**
    * @description : The method is executed from EmployeeTrigger only to check whether the EmployeeID of the Employee Record is valid or not.
    * @param : {List<Employee__c>} empList - new List of Employee
    * @return : List<Employee__c>  // Make it more clear what you are try to return.
    */
    private static List<Employee__c> validateEmployeeIdAndInsertBusinessDay(List<Employee__c> empList){
        try{ // Don't put all the stuff into try block except that one which can occur error at runtime.
            List<Integer> employeeID = new List<Integer>();
            Integer numberOfEmployeeId;
            List<Employee__c> lastCreatedEmpRecord  = [SELECT EMPLOYEE_ID__c, Employee_Activity_Status__c FROM Employee__c ORDER BY createdDate DESC LIMIT 1];
            if(lastCreatedEmpRecord.size()>0){
                numberOfEmployeeId = Integer.ValueOf(lastCreatedEmpRecord[0].EMPLOYEE_ID__c.removeStart(HRMS_Constants.AC_STRING_FOR_EMPLOYEEID_PREFIX_FORMAT))+1;
            }
            //if we want to get n bussiness day from today then we have to pass first parameter as a null
            Date oneBusinessDay = CalculateBusinessDayWithHoliday.getBusinessday(null,1);
            Date threeBusinessDay = CalculateBusinessDayWithHoliday.getBusinessday(null,3);
            Date sevenBusinessDay = CalculateBusinessDayWithHoliday.getBusinessday(null,7);
            For(Employee__c emp :empList){
                Integer newInsertedEmpId = Integer.ValueOf(emp.EMPLOYEE_ID__c.removeStart(HRMS_Constants.AC_STRING_FOR_EMPLOYEEID_PREFIX_FORMAT));
                emp.After_One_Business_day__c = oneBusinessDay;
                emp.After_Three_Bussines_Day__c = threeBusinessDay;
                emp.After_Seven_Business_day__c = sevenBusinessDay;
                if(newInsertedEmpId > numberOfEmployeeId || newInsertedEmpId < numberOfEmployeeId){
                    emp.EMPLOYEE_ID__c.addError('Employee Id should be next '+numberOfEmployeeId);
                }
            }            
            return empList;
        }catch(Exception ex){
            system.debug('error-> '+ex);
        }
        return null;
    }
}