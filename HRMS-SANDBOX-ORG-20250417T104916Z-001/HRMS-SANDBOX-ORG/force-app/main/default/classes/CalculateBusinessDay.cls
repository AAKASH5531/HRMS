/**
* @description : The CalculateBusinessDay is used for get business day after n days
* @CreatedDate  : 06th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 07th Nov 2023
*/
public class CalculateBusinessDay {
    
    /**
    * @description : Method will execute from MarkAttendanceController only check the business day
    * @param : NA
    * @return : Datetime-current date time  // eleborate one step more regarding what it will return.
    */
    public static Datetime getBusinessday(){
        try{           //Put only those line of codes into try block which may occur runtime errors.
             Datetime now = Datetime.now();
             Integer offset = UserInfo.getTimezone().getOffset(now);
             Datetime local = now.addSeconds(offset/1000); 
             Boolean isWorking = isWorkingDay(local.date());
             if(isWorking){
                return local;
             }else{
                return null;
            }
        }catch (Exception ex) {
            system.debug('An unexpected exception occurred: ' + ex.getMessage());
            return null; 
        }
    }
    
    /**
    * @description : Check if a date is a working day considering business hours and holidays
    * @param : Date dateToCheck
    * @return : Boolean - true or false // It should be little bit more delaited.
    */ 
    public static Boolean isWorkingDay(Date dateToCheck) {
        List<Holiday> holidays = [SELECT Id, ActivityDate FROM Holiday WHERE ActivityDate = :dateToCheck];
        return !isWeekend(dateToCheck) && !isHoliday(holidays, dateToCheck);
    }
    
    /**
    * @description : Check if a date falls on a weekend (Saturday or Sunday)
    * @param : Date dateToCheck
    * @return : Boolean - true or false  // It should be a bit more delaited.
    */ 
    private static Boolean isWeekend(Date dateToCheck) {
        DateTime myDateTime = (DateTime) dateToCheck;
        String dayOfWeek = myDateTime.format('EEEE');
        return dayOfWeek == 'Saturday' || dayOfWeek == 'Sunday';  // Dont pass the value hard code store it into a variable and then use that var. 
    }
     
    /**
    * @description :To check if a date is a holiday
    * @param : List<Holiday> holidays, Date dateToCheck
    * @return : Boolean - true or false  // It should be a bit more delaited.
    */ 
    private static Boolean isHoliday(List<Holiday> holidays, Date dateToCheck) {
        for (Holiday holiday : holidays) {
            if (holiday.ActivityDate == dateToCheck) {
                return true;
            }
        }
        return false;
    }
}