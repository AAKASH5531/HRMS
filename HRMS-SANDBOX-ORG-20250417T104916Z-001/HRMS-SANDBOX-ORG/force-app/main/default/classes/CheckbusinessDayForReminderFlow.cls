public class CheckbusinessDayForReminderFlow {

    @InvocableMethod(label='Reminder' description='Method will update the Employee Absent status')
    public static List<Boolean> checkBusinessDay(){
        List<Boolean> listOfBoolean = new List<Boolean>();
        if(CalculateBusinessDay.getBusinessday() != null){
            listOfBoolean.add(true);
            system.debug('listOfBoolean -> '+listOfBoolean);
            return listOfBoolean;
        }
        else{
            listOfBoolean.add(false);
            system.debug('listOfBoolean -> '+listOfBoolean);
            return listOfBoolean;
        }    
    }
}