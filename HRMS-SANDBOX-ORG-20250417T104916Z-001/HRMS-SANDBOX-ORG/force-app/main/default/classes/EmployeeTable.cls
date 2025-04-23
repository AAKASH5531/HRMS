/** 
*@description :EmployeeTable is used by the lightning web components EmployeeTable
*@author : Aakash Mathur - HRMS 
*@created date : 20/11/2023
*@modified by: Aakash Mathur
*@modified date : 24/11/2023
*/
public class EmployeeTable {
    
    /**
    * @description : This method is responsible for geting Employee Information and it returns employee data with assigned project for showing on the custom screen.
    * @param NA
    * @return EmployeeInfoMainDto employeeInfoDto
    */
    @AuraEnabled(cacheable=true)
    public static EmployeeInfoMainDto getEmployeeList(){
        List<String> tableHeaderList = new List<String>{'Employee Name', 'Experience (Y)','Employee Bandwith'};
        List<String> allProjectName = new List<String>();
        List<Project__c> projectList = [SELECT Id, Name FROM Project__c LIMIT 1000];
        EmployeeInfoMainDto employeeInfoDto = new EmployeeInfoMainDto();
        if(projectList.size() > 0){
            for(Project__c projectObj : projectList){
                tableHeaderList.add(projectObj.Name);
                allProjectName.add(projectObj.Name);
            }
         }
        List<Employee__c> employeeList = [SELECT Id, Name, Total_Experience__c, Employee_Id__c, Total_Percentage_Consume__c,
                                          (SELECT Id, Percentage_Consuming__c, Is_Shadow__c, Is_Billable__c, Assigned_Project__r.Name,
                                           Assigned_Project__r.Total_Experience__c, Assigned_Project__r.Employee_Manager__r.Name, 
                                           Assigned_Project__r.Total_Percentage_Consume__c, Assigned_Project__r.Designation__c,
                                           Project__r.Name FROM Assigned_Project__r) FROM Employee__c LIMIT 1000];
        List<Employee> employeeDetailList = new List<Employee>();
        System.debug('----employeeList.size()----------------33----------->'+employeeList.size());
        if(employeeList.size() > 0){
            for (Employee__c employeeObj : employeeList) {
                List<AssineeProject> assineeProjectList = new List<AssineeProject>();
                Employee empDetail = new Employee();
                List<String> listOfAssineeProj = new List<String>();
                empDetail.name = employeeObj.Name;
                empDetail.experience = String.valueOf(employeeObj.Total_Experience__c);
                if(employeeObj.Total_Percentage_Consume__c != null){
                      empDetail.employeeBandwidth = String.valueOf(100 - employeeObj.Total_Percentage_Consume__c);
                }
                else{
                  empDetail.employeeBandwidth = '100';  
                }
           
             System.debug('==========employeeObj.Assigned_Projects__r.size() =====================>'+employeeObj.Assigned_Project__r.size() );
                if(employeeObj.Assigned_Project__r.size() > 0){
                    for(Assigned_Project__c assigenProObj: employeeObj.Assigned_Project__r){
                        System.debug('===============================>');
                        AssineeProject assineeProject = new AssineeProject();
                        if(assigenProObj.Project__c!= null){
                            System.debug('assigenProObj.Project__c=====54===>'+assigenProObj.Project__c);
                            assineeProject.projectName = assigenProObj.Project__r.Name;
                            if(assigenProObj.Assigned_Project__c != null && assigenProObj.Assigned_Project__r.Employee_Manager__r != null){
                                assineeProject.managerName = assigenProObj.Assigned_Project__r.Employee_Manager__r.Name;
                                assineeProject.designation =  assigenProObj.Assigned_Project__r.Designation__c;
                                if(assigenProObj.Assigned_Project__r.Total_Percentage_Consume__c != null){
                                    assineeProject.bandwidth = String.valueOf(100 - assigenProObj.Assigned_Project__r.Total_Percentage_Consume__c);
                                }
                                else{
                                    assineeProject.bandwidth = '100'; 
                                }
                            }
                            else{
                                assineeProject.bandwidth = '100'; 
                            }
                            assineeProject.percentageConsuming = assigenProObj.Percentage_Consuming__c != null ? String.valueOf(assigenProObj.Percentage_Consuming__c) : '0';
                            assineeProject.isShadow = assigenProObj.Is_Shadow__c;
                            assineeProject.isBillable = assigenProObj.Is_Billable__c;
                            assineeProjectList.add(assineeProject);        
                       }
                       if(assigenProObj.Project__r.Name == 'Training Project'){
                              empDetail.isTrainingProject = true;
                              
                       }else{
                                empDetail.isTrainingProject = false;  
                            }
                    System.debug('---- employeeObj.Name-------------------------------------------'+ employeeObj.Name);
                     if(employeeObj.Name == 'Kevin'){
                         System.debug('---- assigenProObj.Is_Billable__c-------------------------------------------'+ assigenProObj.Is_Billable__c);

                     }
                      empDetail.isShadow = assigenProObj.Is_Shadow__c;
                      empDetail.isBillable =  assigenProObj.Is_Billable__c;
                      System.debug('====empDetail.isShadow==============================>'+empDetail.isShadow);
                        System.debug('======== empDetail.isBillable ==========================>'+ empDetail.isBillable );
                          System.debug('=========== empDetail.isTrainingProject=======================>'+ empDetail.isTrainingProject);
                            
                      if(empDetail.isShadow || empDetail.isBillable || empDetail.isTrainingProject){
                                 empDetail.isNocolor = false ;
                            System.debug('========empDetail.isNocolor =========================================================>'+empDetail.isNocolor );
                      }else{
                           empDetail.isNocolor = true;
                      }
                    } 
                }  
                empDetail.listOfAssineeProject = assineeProjectList;
                employeeDetailList.add(empDetail);
             }
            employeeInfoDto.listOfAllProject = allProjectName ;
            employeeInfoDto.listOfHeader = tableHeaderList;
            employeeInfoDto.listOfEmployee = employeeDetailList;
            System.debug('employeeInfoDto---In Jshon---->'+JSON.serializePretty(employeeInfoDto)); 
        }
         return  employeeInfoDto;
    }
    public class EmployeeInfoMainDto {
        @AuraEnabled
        public List<String> listOfAllProject;
        @AuraEnabled
        public List<String> listOfHeader;
        @AuraEnabled
        public List<Employee> listOfEmployee;
    }
    public class Employee {
       @AuraEnabled
        public String name;  
        @AuraEnabled
        public String experience;   
        @AuraEnabled
        public String employeeBandwidth;  
        @AuraEnabled
        public Boolean isBillable = false;  
        @AuraEnabled
        public Boolean isShadow = false;
        @AuraEnabled
        public Boolean isTrainingProject = false;
        @AuraEnabled
        public Boolean isNocolor = true;
        @AuraEnabled
        public List<AssineeProject> listOfAssineeProject;
    }
    public class AssineeProject{
        @AuraEnabled
        public String projectName;
        @AuraEnabled
        public Boolean isShadow ;
        @AuraEnabled
        public String percentageConsuming;
        @AuraEnabled
        public String managerName;
        @AuraEnabled
        public Boolean isBillable;
        @AuraEnabled
        public String bandwidth;
        @AuraEnabled
        public String designation;
    }
}