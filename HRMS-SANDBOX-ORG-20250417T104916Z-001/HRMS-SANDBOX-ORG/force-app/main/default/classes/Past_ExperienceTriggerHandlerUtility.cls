/**
* @description : The handler is used by the PastExperienceTrigger
* @group : PastExperienceTrigger
* @created By : Ankita Dhamgaya
* @created date : 30th Oct 2023
* @modified by: Akash Sahani
* @modified date: 25th Nov 2023
*/
public with sharing class Past_ExperienceTriggerHandlerUtility {
       
    /**
    * @description : The method is executed from the PastExperienceTrigger to calculate the experience in years and months and convert it into the 0.00 format.
    * @param : {Set<String> setOfPastExperience} setOfPastExperience - new Set of Past Experience 
    * @return : List<Employee__c>
    */
    public static List<Employee__c> calculateExperience(Set<String> setOfPastExperience){
        List<Employee__c> empListForUpdate = new List<Employee__c>();
        for(Employee__c emp : [SELECT ID, Current_Experience__c, Total_Experience__c, 
                               (SELECT Id, Relevant_Experience__c, Past_Experience__c.Employee__c FROM Past_Experiences__r)  
                               FROM Employee__c WHERE ID IN : setOfPastExperience]){
            Integer totalExperienceInMonths = 0;
            Decimal formattedExperience = 0;
            for(Past_Experience__c pastExp : emp.Past_Experiences__r){
                Decimal relevantExperienceValue = Decimal.valueOf(pastExp.Relevant_Experience__c);
                system.debug('past Exp ===> '+relevantExperienceValue);
                Integer years = Integer.valueOf(relevantExperienceValue);
                Decimal monthsDecimal = (relevantExperienceValue - years) * 100; // Multiply by 100
                Integer months = Integer.valueOf(monthsDecimal);
                Integer totalMonths = (years * 12) + months;
				totalExperienceInMonths += totalMonths;
            }
            Integer totalYears = totalExperienceInMonths / 12;
            Integer totalMonthsRemainder = totalExperienceInMonths - (totalYears * 12);
            if (totalMonthsRemainder < 10) {
                formattedExperience = Decimal.valueOf(totalYears + '.0' + totalMonthsRemainder);
            } else {
                formattedExperience = Decimal.valueOf(totalYears + '.' + totalMonthsRemainder);
			}
            emp.Past_Experience__c = formattedExperience;
            Decimal total = formattedExperience + Decimal.ValueOf(emp.Current_Experience__c);
                                   system.debug('Decimal.valueOf(total.format())-------------->  '+Decimal.valueOf(total.format()));
            emp.Total_Experience__c = Decimal.valueOf(total.format());
            empListForUpdate.add(emp);
        }
        return empListForUpdate;
    }
}