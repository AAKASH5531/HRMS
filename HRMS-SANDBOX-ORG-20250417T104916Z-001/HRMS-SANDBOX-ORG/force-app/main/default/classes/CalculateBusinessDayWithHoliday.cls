/**
* @description : The CalculateBusinessDayWithHoliday is used for get business day after n days
* @author : Akash Sahani - HRMS
* @created date : 06th Nov 2023
* @modified by: Akash Sahani
* @modified date: 25th Nov 2023
*/

public class CalculateBusinessDayWithHoliday {
    
    /**
    * @description : The method is used for getting business day.
    * @param : {Date} baseDate, {Integer} workingDaysToWait - Contains given date and number of days
    * @return : Business Date
    */
    public static Date getBusinessday(Date baseDate, Integer workingDaysToWait){
        Boolean isBefore = true;
        Integer dayToadd = -1;
        Set<Date> activitySet = new Set<Date>();
        try{ // Put only those code into try block which can may occur error on runtime.
            List<Holiday> holidays = [SELECT Id, ActivityDate FROM Holiday]; // This is not the good way to make a indivisual query without any condition.  
            for(Holiday holiday: holidays){
                activitySet.add(holiday.ActivityDate);
            }
            if(baseDate == null){
                baseDate = Date.today();
                workingDaysToWait = -workingDaysToWait;
                isBefore = false;
                dayToAdd = 1;
            }
            Date dueDate = calculateDueDate(baseDate, -workingDaysToWait, isBefore, dayToAdd, activitySet);
            return dueDate;
        } catch (Exception ex) {
            system.debug('An unexpected exception occurred: ' + ex.getMessage());
            return null; 
        }
    }
    
    /**
    * @description : The method is used for getting business day.
	* @param : {Date} baseDate, {Integer} workingDaysToWait, {Boolean} isBefore, {Integer} dayToAdd, {Set<Date>} activitySet - 
	* Contains given date, number of days, boolean value to check for before or after business day, Integer value for increment or decrement, 
    * set of Holiday
    * @return : Business Date // I am not able to understand the method name and its return value
    */
    private static Date calculateDueDate(Date startDate, Integer workingDays, Boolean isBefore, Integer dayToAdd, Set<Date> activitySet) {
        while (workingDays != 0) {
            startDate = startDate.addDays(dayToAdd);
            if (isWorkingDay(startDate, activitySet)) {
                if(isBefore){
                    workingDays++;
                }else{
                    workingDays--;
                }
            }
        }
        return startDate;
    }
    
    /**
    * @description : The method is used for checking working day or not
    * @param : {Date} dateToCheck, {Date} baseDate - Contains given date
    * @return : working day or not (Boolean)
    */
    private static Boolean isWorkingDay(Date dateToCheck, Set<Date> activitySet) {
        return !isWeekend(dateToCheck) && !isHoliday(dateToCheck, activitySet);
    }
    
    /**
    * @description : The method is used for checking the day of given date is saturday or sunday 
    * @param : {Date} dateToCheck - Contains given date
    * @return : weekend or not (Boolean)
    */
    private static Boolean isWeekend(Date dateToCheck) {
        DateTime myDateTime = (DateTime) dateToCheck; 
        String dayOfWeek = myDateTime.format('EEEE');
        return dayOfWeek == 'Saturday' || dayOfWeek == 'Sunday'; // Store the week names into varialbe and then use that var. insted of using the week name directly.
    }
    
    /**
    * @description : The method is used to check whether the given date is contained in the holiday list or not 
    * @param : {Date} dateToCheck, {Date} baseDate - Contains given date
    * @return : holiday or not (Boolean)
    */
    private static Boolean isHoliday(Date dateToCheck, Set<Date> activitySet) {
        return activitySet.contains(dateToCheck);
    } 
    
}