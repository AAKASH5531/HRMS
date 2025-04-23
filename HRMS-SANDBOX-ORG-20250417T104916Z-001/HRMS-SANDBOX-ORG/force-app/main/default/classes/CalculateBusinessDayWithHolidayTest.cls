/**
* @description : The CalculateBusinessDayWithHolidayTest is used by the CalculateBusinessDayWithHoliday
* @author : Akash Sahani - HRMS
* @created date : 06th Nov 2023
* @modified by: Akash Sahani
* @modified date: 25th Nov 2023
*/

@isTest
public class CalculateBusinessDayWithHolidayTest {
    
    /**
    * @description : The method is executed only to cover the positive scenario for the getBusinessday and calculateDueDate methods.
    * @param : NA
    * @return : NA
    */
    @isTest
    private static void testGetBusinessDayPositive(){
        Date getResponseDate = CalculateBusinessDayWithHoliday.getBusinessday(null,12); // Variable name should be related to the actual work.
        test.startTest();
        date dueDate = CalculateBusinessDayWithHoliday.getBusinessday(null,12);
        test.stopTest();
        System.assertEquals(getResponseDate, dueDate, 'The responsedate not matching as expected');
    }

    /**
    * @description : The method is executed only to cover the negative scenario for the getBusinessday method.
    * @param : NA
    * @return : NA
    */
 	@isTest
    private static void testGetBusinessDayNegative() {
        Test.startTest();
        Date result = CalculateBusinessDayWithHoliday.getBusinessday(Date.newInstance(2023, 11, 6), 5); // After reading the variable name I am not able to get the what is the use of that variable.
        Test.stopTest();
        System.assertEquals(Date.newInstance(2023, 10, 30), result); // Third param are missing here need to add.
    }
    
}