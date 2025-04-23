/**
* @description : The CalculateBusinessDayTest is used by the CalculateBusinessDay
* @group : CalculateBusinessDayTest
* @author : Rishabh Singh - HRMS
* @CreatedDate  : 6th Nov 2023
* @modified by: Rishabh Singh
* @modified date: 07th Nov 2023
*/
@istest
Private class CalculateBusinessDayTest {
    
    /**
    * @description : Method will execute from CalculateBusinessDay only Cover getBusinessday Postive Scenario 
    * @param : NA
    * @return : NA
    */
    @istest
    Private static void getBusinessdayTest(){
        Datetime getResponseDate;  // Name of the variable is not pointing here to you are trying to get the business Days.
        test.startTest();
        getResponseDate =  CalculateBusinessDay.getBusinessday(); 
        test.stopTest();
        System.assertEquals(getResponseDate, getResponseDate, 'The responsedate not matching as acepected');  // This is not the right way passing the same variable name on the palce of expected and actual into the assertion. 
    }
    
    /**
    * @description : Method will execute from CalculateBusinessDay only Cover getBusinessday Negative Scenario 
    * @param : NA
    * @return : NA
    */
    @istest
    Private static void getBusinessdayTestNegative(){
        Datetime getResponseDate; // Name of the variable is not pointing here to you are trying to get the business Days.
        Date todaydate = date.today().addDays(14);
        test.startTest();
        getResponseDate =  CalculateBusinessDay.getBusinessday(); 
        test.stopTest();
        System.assertNotEquals(getResponseDate, todaydate, 'The responsedate  matching as acepected'); // I dont think you are testing here a date which not belong to business days keep it that way. 

    }
}