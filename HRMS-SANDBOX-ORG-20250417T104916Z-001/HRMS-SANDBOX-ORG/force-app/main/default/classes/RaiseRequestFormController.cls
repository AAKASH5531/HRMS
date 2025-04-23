/**
* @description : The handler is used by the lightning web components RaiseRequestForm
* @group : RaiseRequestForm
* @author : Rishabh Singh - HRMS
* @date  : 22th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 24th Nov 2023
*/
public class RaiseRequestFormController {

    /**
    * @description : Method will execute from RaiseRequestForm only send to RaiseRequestForm data
    * @param : NA
    * @return : List<Form__c> -formList
    */
    @AuraEnabled(cacheable=true)
    public Static List<Form__c> getFormRecord(){
        try{
                List<Form__c>  formList = [SELECT Id, Name , IsActive__c From Form__c WHERE IsActive__c = true AND IS_Raise_a_Request__c = true];
                if(!formList.isEmpty()){
                    return formList;
                }
        }
        catch(Exception ex){
             throw new AuraHandledException(ex.getMessage());
        }  
        return null;
    }

    /**
    * @description : Method will execute from RaiseRequestForm only send to RaiseRequestForm data
    * @param : NA
    * @return : List<Form__c> -formList
    */
    @AuraEnabled
    Public Static List<WorkingDay> checkBusinessDay(String leaveDateFrom, String leaveDateTo, Integer countDay, Date startDate, Date endDate){
        system.debug('startDate'+startDate);
        Date checkLeaveDateFrom;
        Date checkLeaveDateTo;
        List<WorkingDay> workingDayList = new List<WorkingDay>();
        WorkingDay workingDay = new WorkingDay();
        if(leaveDateFrom != null){
            checkLeaveDateFrom = Date.valueOf(leaveDateFrom);
         }
         if(leaveDateTo != null){
            checkLeaveDateTo = Date.valueOf(leaveDateTo);
         }
         if(countDay != null){
             workingDay.countDate = CalculateBusinessDayWithHoliday.getBusinessday(checkLeaveDateFrom, countDay);
            System.debug('workingDay.countDate'+workingDay.countDate);
         }
        
        if(startDate != null && endDate !=null){
            if(CalculateBusinessDay.isWorkingDay(startDate)){
            workingDay.isCheckStartDate = true;
        }
        if(CalculateBusinessDay.isWorkingDay(endDate)){
            workingDay.isCheckEndDate = true;
        }
         }

         if(checkLeaveDateFrom != null && checkLeaveDateTo !=null){
            Integer numberDaysDue = checkLeaveDateFrom.daysBetween(checkLeaveDateTo);
            Boolean flag = true;
            for(integer i = 0; i < numberDaysDue + 1; i++){
                Date tempDate = checkLeaveDateFrom.addDays(i);
                System.debug('tempDate -> '+ tempDate);
                if(!CalculateBusinessDay.isWorkingDay(tempDate))
                {
                    flag = false;
                     workingDay.isCheckLeaveDateFrom = false;
                }
            }
            if(flag){
                if(CalculateBusinessDay.isWorkingDay(checkLeaveDateFrom)){
                    workingDay.isCheckLeaveDateFrom = true;
                }
                if(CalculateBusinessDay.isWorkingDay(checkLeaveDateTo)){
                    workingDay.isCheckLeaveDateTo = true;
                }
            }
            
           
         }
        workingDayList.add(workingDay);

          return workingDayList;

    }
    
    public class WorkingDay{
        @AuraEnabled
        public  Date countDate;
        @AuraEnabled
        public  Boolean isCheckStartDate;
        @AuraEnabled
        public  Boolean isCheckEndDate;
        @AuraEnabled
        public  Boolean isCheckLeaveDateFrom;
        @AuraEnabled
        public  Boolean isCheckLeaveDateTo;
    }
    
  
}