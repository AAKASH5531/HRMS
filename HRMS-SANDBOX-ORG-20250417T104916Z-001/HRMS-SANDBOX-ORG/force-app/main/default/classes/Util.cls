// Add the author name created date as well as proper description.
/**
* 
* @description Util methods Test class Util_Test.
*/
public class Util {
    public static User currentUser;
    static {
        currentUser = [SELECT Id, Name, ProfileID, Profile.Name
                       //,Bypass_Lead_Validation__c, ByPassValidation__c, Web_User__c 
                       FROM User 
                       WHERE Id =:UserInfo.getUserId() 
                       LIMIT 1];
    }
    
    public static boolean isTestnonGethealthyCode = false;
    public static boolean isCoverageAreaReverseGeocode = false;
    private static boolean isLeadConversionContext = false;
    
    public static boolean isInContextOfLeadConversion() {
        return isLeadConversionContext;
    }
    public static void setInContextOfLeadConversion() {
        isLeadConversionContext = true;
    }
    
    public static boolean byPassValidation() {
        //  return currentUser.ByPassValidation__c;
        return null;
    }
    
    public static boolean byPassLeadValidation() {
        
        return null;//currentUser.Bypass_Lead_Validation__c;
    }
    
   // public static Set<String> usersToSkipTrigger {get;set;}
   public static boolean isSkipTrigger() {
       system.debug('========== Skip======');
       /* Process_Switches__c processSwitches = Process_Switches__c.getInstance(UserInfo.getProfileId());
        if(processSwitches.Past_Experience__c){
            system.debug('========== is Skiped======');
            return true;
        } */
        return false;      
    }
    
    public static List<RecordType> getRecordTypeForobject(String objectName) {
        return [SELECT Id, DeveloperName, Name 
                FROM RecordType 
                WHERE SobjectType = :objectName];
    }
    private static Map<String,Trigger_By_Pass__c> mapTriggerByPassCustSetting{get;set;}
    private static Map<String,String> mapTriggerPassUsersIDs{get;set;}
    private static Map<String,String> mapTriggerPassProfileIDs{get;set;}
    
    public static boolean isSkipTrigger(String handlerName, ID RecordTypeID) {
        String settingName = null;
        
        if (mapTriggerByPassCustSetting == null || mapTriggerByPassCustSetting.isEmpty()) {
            mapTriggerByPassCustSetting = new Map<String,Trigger_By_Pass__c>();
            mapTriggerPassUsersIDs = new Map<String,String>();
            mapTriggerPassProfileIDs = new Map<String,String>();
            List<Trigger_By_Pass__c> listTrigger = Trigger_By_Pass__c.getAll().values();
            for (Trigger_By_Pass__c custSettingTriggerByPass: listTrigger) {
                
                settingName = custSettingTriggerByPass.Name;
                if (custSettingTriggerByPass.Name.contains('__')) {
                    settingName = settingName.substring(0,settingName.indexOf('__'));
                }
                
                mapTriggerByPassCustSetting.put(settingName,custSettingTriggerByPass);
                if (custSettingTriggerByPass.UserIDs__c != null) {
                    if (mapTriggerPassUsersIDs.containsKey(settingName)) {
                        mapTriggerPassUsersIDs.put(settingName,mapTriggerPassUsersIDs.get(settingName)+custSettingTriggerByPass.UserIDs__c);
                    } else {
                        mapTriggerPassUsersIDs.put(settingName,custSettingTriggerByPass.UserIDs__c);
                    }
                }
                if (custSettingTriggerByPass.ProfileIDs__c != null) {
                    if (mapTriggerPassProfileIDs.containsKey(settingName)) {
                        mapTriggerPassProfileIDs.put(settingName,mapTriggerPassProfileIDs.get(settingName)+custSettingTriggerByPass.ProfileIDs__c);
                    } else {
                        mapTriggerPassProfileIDs.put(settingName,custSettingTriggerByPass.ProfileIDs__c);
                    }
                }
                
            }
        }
        
        settingName = handlerName;
        if (settingName.contains('__')) {
            settingName = settingName.substring(0,settingName.indexOf('__'));
        }
        
        if (mapTriggerByPassCustSetting.containsKey(settingName) 
            && (!mapTriggerByPassCustSetting.get(settingName).Is_Active__c || 
                (mapTriggerByPassCustSetting.get(settingName).RecrodType__c != null && mapTriggerByPassCustSetting.get(settingName).RecrodType__c.contains(RecordTypeID)))
           ) {
               return true;
           } else if (mapTriggerPassUsersIDs != null && mapTriggerPassUsersIDs.containsKey(settingName) 
                      && mapTriggerPassUsersIDs.get(settingName) != null 
                      && mapTriggerPassUsersIDs.get(settingName).contains(userinfo.getUserid())) {
                          return true;
                          
                      } else if (mapTriggerPassProfileIDs != null && mapTriggerPassProfileIDs.containsKey(settingName)
                                 && mapTriggerPassProfileIDs.get(settingName) != null 
                                 && mapTriggerPassProfileIDs.get(settingName).contains(userinfo.getprofileID())) {
                                     return true;    
                                 } else {
                                     return false;
                                 }
    }
    
    public static boolean nonGethealthyTestSwitch() {
        if (Test.isRunningTest() && ! Util.isTestnonGethealthyCode) {
            return true;
        }
        return false;
    }
    
    public static boolean gethealthyTestSwitch() {
        if (Test.isRunningTest() && Util.isTestnonGethealthyCode) {
            return true;
        }
        return false;
    }
    
    private static Map<String, Map<String, Id>> rtypesCache;
    /**
* @description Returns a map of active, user-available RecordType IDs for a given SObjectType.
* @param sObjType Sobject token
* @return  `Map<String, Id>`
*/
    public static Map<String, Id> getRecordTypeIdsByDeveloperName(Schema.SObjectType sObjType) {
        if (sObjType == null) {
            return new Map<String, Id>();
        }
        
        // Using valueOf instead of getDescribe due to performance issues.
        String sObjDeveloperName = String.valueOf(sObjType);
        
        if (rtypesCache == null) {
            rtypesCache = new Map<String, Map<String, Id>>();
            List<RecordType> recordTypes = [SELECT Id, SobjectType, DeveloperName
                                            FROM RecordType
                                            WHERE IsActive = TRUE];
            Map<String, List<RecordType>> sobjectTypeToRecordTypes = GroupBy.strings('SobjectType', recordTypes);
            
            for (String sobjectType : sobjectTypeToRecordTypes.keySet()) {
                Map<String, Id> developerNameToId = new Map<String, Id>();
                for (RecordType recordType : sobjectTypeToRecordTypes.get(sobjectType)) {
                    developerNameToId.put(recordType.DeveloperName, recordType.Id);
                }
                rtypesCache.put(sobjectType, developerNameToId);
            }
        }
        
        // Check if result is in cache.
        if (rtypesCache.containsKey(sObjDeveloperName)) {
            return rtypesCache.get(sObjDeveloperName);
        }
        
        return new Map<String, Id>();
    }
}