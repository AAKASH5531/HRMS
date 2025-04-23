/** 
*@description :EmployeeSkillMetrics is used by the lightning web components employeeSkillMetrics
*@author : Aakash Mathur - HRMS 
*@created date : 29/11/2023
*@modified by: Aakash Mathur
*@modified date : 30/11/2023
*/
public class EmployeeSkillMetrics {
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjectName(){
        try {
            List<Project__c> projectNameList = [SELECT Id, Name, Is_Active__c FROM Project__c  LIMIT 1000]; 
            return projectNameList;
        } catch (Exception e) {
            System.debug('Exception: '+e.getMessage());
            return null;
        }
    }
 
    @AuraEnabled
    public Static List<EmployeeInfoWithSkill> getEmployeeInf( Decimal employeeExperince, String projectName){   
        List<Skills__c> skillList  = new  List<Skills__c>();
        System.debug('employeeExperince=======>'+employeeExperince);
        
        if(employeeExperince == null){
              skillList = [SELECT Id,  Name, LastReferencedDate, Parent_Skill__c, (SELECT Id, Name, Skills__r.Name,  Employee__c, Employee__r.Name, Employee__r.Total_Experience__c, Skills__c FROM Employee_Skills__r),(SELECT Id, Name, Project__c, Project__r.Name, Skills__c, Project__r.Assigned_Project__r.Percentage_Consuming__c, Project__r.Assigned_Project__r.Is_Billable__c FROM Project_Skills__r WHERE Project__c =:projectName) FROM Skills__c];
           System.debug('skillList=======>'+skillList);
        }else{
              skillList = [SELECT Id,  Name, LastReferencedDate, Parent_Skill__c, (SELECT Id, Name, Skills__r.Name,  Employee__c, Employee__r.Name, Employee__r.Total_Experience__c, Skills__c FROM Employee_Skills__r WHERE Employee__r.Total_Experience__c =:employeeExperince),(SELECT Id, Name, Project__c, Project__r.Name, Skills__c, Project__r.Assigned_Project__r.Percentage_Consuming__c, Project__r.Assigned_Project__r.Is_Billable__c FROM Project_Skills__r WHERE Project__c =:projectName) FROM Skills__c];
         System.debug('skillList===ELSE====>'+skillList);
        }
       List<EmployeeInfoWithSkill> demoList = new  List<EmployeeInfoWithSkill>();
        Map<String, List<List<ProjectSkill>>> mapOfEmployeeIdAndProjectSkill = new Map<String, List<List<ProjectSkill>>>();
        Map<String, String> mapEmployeeNamePercentageConsuming = new Map<String, String>(); 
        Set<String> empIDSet = new Set<String>();
        for(Skills__c skillRec : skillList){
            List<List<ProjectSkill>> ineerLsit = new List<List<ProjectSkill>>();
            Set<String> allSkills = new Set<String>();
            String  key = '';
            for(Employee_Skills__c empSkill : skillRec.Employee_Skills__r){
               empIDSet.add(empSkill.Employee__c);
                key = empSkill.Employee__c+'~~'+empSkill.Employee__r.Name;

                allSkills.add(empSkill.Skills__r.Name.toUpperCase());
                System.debug('--allSkills--42--->'+allSkills);
            }
            List<ProjectSkill> dlst = new List<ProjectSkill>();
            System.debug('skillRec.Project_Skills__r========>'+skillRec.Project_Skills__r);
            if(skillRec.Project_Skills__r.size() == 0){
                key = '';
            }
            for(Project_Skills__c  projectSkillRec : skillRec.Project_Skills__r){
                System.debug('=----projectSkillRec.Name.-----IN Loop'+projectSkillRec.Name);
                
                ProjectSkill ds = new ProjectSkill();
                if(allSkills.contains(projectSkillRec.Name.toUpperCase()) ){
                    ds.isMatchSkill = true;
                }
                ds.skillsName = projectSkillRec.Name;
                allSkills.add(projectSkillRec.Name);
                if(!allSkills.contains(projectSkillRec.Name)){
                key = '';                    
                }
                dlst.add(ds);
            } 
            if(key != '' && key != null){
                if(mapOfEmployeeIdAndProjectSkill.containsKey(key)){
                   ineerLsit  =  mapOfEmployeeIdAndProjectSkill.get(key);
                }
                ineerLsit.add(dlst);
                mapOfEmployeeIdAndProjectSkill.put(key, ineerLsit); 
            }
          }
        for(String str : mapOfEmployeeIdAndProjectSkill.keySet()){
            System.debug('STR in Map 69------->'+str);
            EmployeeInfoWithSkill employeeInfoWithSkill = new EmployeeInfoWithSkill();
            employeeInfoWithSkill.empName = str.split('~~')[1];
            employeeInfoWithSkill.skills = mapOfEmployeeIdAndProjectSkill.get(str);
            System.debug('- mapOfEmployeeIdAndProjectSkill.get(str)--------------------------->'+ mapOfEmployeeIdAndProjectSkill.get(str));
             employeeInfoWithSkill.empId = str.split('~~')[0];
            demoList.add(employeeInfoWithSkill);
        }
        if(!empIDSet.isEmpty()){
           for(Assigned_Project__c assProj : [SELECT Id, Is_Billable__c, Percentage_Consuming__c , Assigned_Project__c, Project__r.Name FROM Assigned_Project__c WHERE Assigned_Project__c  =:empIDSet AND Project__c =:projectName AND Is_Billable__c = true]){
               System.debug('assProj==95==='+assProj);
                String totalConsumption = assProj.Percentage_Consuming__c != null ? String.valueOf(assProj.Percentage_Consuming__c) : '0';
                mapEmployeeNamePercentageConsuming.put(assProj.Assigned_Project__c,totalConsumption );
                System.debug('==mapEmployeeNamePercentageConsuming=====97=====================>'+mapEmployeeNamePercentageConsuming);
           }
        }
         if(!mapEmployeeNamePercentageConsuming.isEmpty()){
            for(EmployeeInfoWithSkill dm : demoList){
                if(dm.empId != null){
                    dm.percentageConsuming = mapEmployeeNamePercentageConsuming.containsKey(dm.empId) ? mapEmployeeNamePercentageConsuming.get(dm.empId) : '0';
                }
            }
        }
        System.debug('demoList---In Jshon---->'+JSON.serializePretty(demoList)); 
        return demoList;
    }
    
/***************************************************************/    
   @AuraEnabled 
    public static List<EmployeeInfoWithSkill>  employeeSkillsPackage(Decimal employeeExperince, String projectName){
        System.debug('---Second method call----------------------------');
           List<Skills_Package__c> skillsPackageList = new  List<Skills_Package__c>();
        if(employeeExperince == null){
           skillsPackageList = [SELECT Id, Name, (SELECT Id, Name, Skills_Package__r.Name,  Employee__c, Employee__r.Name, Skills_Package__c FROM Employee_Skills_Packages__r),(SELECT Id, Name, Project__c, Project__r.Name, Skills_Package__c, Skills_Package__r.Name, Project__r.Assigned_Project__r.Percentage_Consuming__c, Project__r.Assigned_Project__r.Is_Billable__c  FROM Project_Skills_Packages__r  WHERE Project__c =:projectName) FROM Skills_Package__c];

        }else{
           skillsPackageList = [SELECT Id, Name, (SELECT Id, Name, Skills_Package__r.Name,  Employee__c, Employee__r.Name, Skills_Package__c FROM Employee_Skills_Packages__r WHERE Employee__r.Total_Experience__c =:employeeExperince),(SELECT Id, Name, Project__c, Project__r.Name, Skills_Package__c, Skills_Package__r.Name, Project__r.Assigned_Project__r.Percentage_Consuming__c, Project__r.Assigned_Project__r.Is_Billable__c  FROM Project_Skills_Packages__r  WHERE Project__c =:projectName) FROM Skills_Package__c];
          }
        
        
         List<EmployeeInfoWithSkill> demoList = new  List<EmployeeInfoWithSkill>();
        Map<String, List<List<ProjectSkill>>> mapOfEmployeeIdAndProjectSkill = new Map<String, List<List<ProjectSkill>>>();
        Map<String, String> mapEmployeeNamePercentageConsuming = new Map<String, String>();       
        Set<String> empIDSet = new Set<String>();
        for(Skills_Package__c skillPackRec : skillsPackageList){
            List<List<ProjectSkill>> ineerLsit = new List<List<ProjectSkill>>();
            Set<String> allSkills = new Set<String>();
            String  key = '';
            for(Employee_Skills_Package__c empSkillPack : skillPackRec.Employee_Skills_Packages__r){
                 empIDSet.add(empSkillPack.Employee__c);
                key = empSkillPack.Employee__c+'~~'+empSkillPack.Employee__r.Name;
                allSkills.add(empSkillPack.Skills_Package__r.Name.toUpperCase());
            }
            List<ProjectSkill> dlst = new List<ProjectSkill>();
              if(skillPackRec.Project_Skills_Packages__r.size() == 0){
                key = '';
            }
            for(Project_Skills_Package__c  projectSkillRec : skillPackRec.Project_Skills_Packages__r){
                ProjectSkill ds = new ProjectSkill();
                if(allSkills.contains(projectSkillRec.Name.toUpperCase()) ){
                    ds.isMatchSkill = true;
                }
                
                ds.skillsName = projectSkillRec.Name;
                allSkills.add(projectSkillRec.Name);
                dlst.add(ds);
            } 
            if(key != '' && key != null){
                if(mapOfEmployeeIdAndProjectSkill.containsKey(key)){
                   ineerLsit  =  mapOfEmployeeIdAndProjectSkill.get(key);
                }
                ineerLsit.add(dlst);
                mapOfEmployeeIdAndProjectSkill.put(key, ineerLsit); 
            }
          }
        System.debug('demoList---In Jshon---->'+JSON.serializePretty(demoList)); 
        for(String str : mapOfEmployeeIdAndProjectSkill.keySet()){
            EmployeeInfoWithSkill d = new EmployeeInfoWithSkill();
            d.empName = str.split('~~')[1];
            d.empId = str.split('~~')[0];
            d.skills = mapOfEmployeeIdAndProjectSkill.get(str);
            demoList.add(d);
        }
        System.debug('---empIDSet-------156-------->'+empIDSet);
        if(!empIDSet.isEmpty()){
           for(Assigned_Project__c assProj : [SELECT Id, Is_Billable__c, Percentage_Consuming__c , Assigned_Project__c, Project__r.Name FROM Assigned_Project__c WHERE Assigned_Project__c  =:empIDSet AND Project__c =:projectName AND Is_Billable__c = true]){
               System.debug('assProj==95==='+assProj);
                String totalConsumption = assProj.Percentage_Consuming__c != null ? String.valueOf(assProj.Percentage_Consuming__c) : '0';
                mapEmployeeNamePercentageConsuming.put(assProj.Assigned_Project__c,totalConsumption );
                System.debug('==mapEmployeeNamePercentageConsuming=====161=====================>'+mapEmployeeNamePercentageConsuming);
           }
        }
        if(!mapEmployeeNamePercentageConsuming.isEmpty()){
            for(EmployeeInfoWithSkill dm : demoList){
                if(dm.empId != null){
                    dm.percentageConsuming = mapEmployeeNamePercentageConsuming.containsKey(dm.empId) ? mapEmployeeNamePercentageConsuming.get(dm.empId) : '0';
                }
            }
        }
        System.debug('map---->'+mapOfEmployeeIdAndProjectSkill);
        System.debug('demoList---In Jshon---->'+JSON.serializePretty(demoList)); 
        return demoList;
        
   }  
    public class EmployeeInfoWithSkill {
        @AuraEnabled
        public String percentageConsuming;	
        @AuraEnabled
        public String empName; 
        @AuraEnabled
        public String empId;   
        @AuraEnabled
        public List<List<ProjectSkill>> skills;
    }
    public class ProjectSkill {
        @AuraEnabled
        public string skillsName;	
       	@AuraEnabled
        public Boolean isMatchSkill = false;
    }
    
}