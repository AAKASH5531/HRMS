/**
* @description : Schema Utility Class // Description need to be more detailed like what is the use of this class.
* @author : Akash Sahani - HRMS
* @created date : 05th Nov 2023
* @modified by: Akash Sahani
* @modified date: 05th Nov 2023
*/
public class SchemaUtility {
    public static Boolean checkRecursive = true;
    
    /**
    * @description : This method receives the object API name and record type, and returns the record type ID.
    * @param : {String} objectAPIName, {String} recordTypeName - contains object api name and record type name
    * @return : recordTypeId 
    */
    public static ID getRecordTypeName(String objectAPIName, String recordTypeName){
        return Schema.getGlobalDescribe().get(objectAPIName)?.getDescribe()?.getRecordTypeInfosByName()?.get(recordTypeName)?.getRecordTypeId();
    }
}