public class PromoteEmployeeController {
    @AuraEnabled
    public Static List<Designation> getDesignation(){
        List<Designation> designationList = new List<Designation>();
        // Describe the Account.Industry field
        Schema.DescribeFieldResult fieldDescription = Employee__c.Designation__c.getDescribe();
        // Get picklist values from field description
        List<Schema.PicklistEntry> entries = fieldDescription.getPicklistValues();
        // Do something with entries
        for (Schema.PicklistEntry entry : entries) {
            Designation designation = new Designation();
            designation.label = entry.getLabel();
            designation.value =  entry.getValue();
            designationList.add(designation);
        }
        return designationList;
    }

    @AuraEnabled
    public Static String updateEmployeeDesignation(String designation, String recordId){
        System.debug('designation'+designation);
        System.debug('recordId'+recordId);
        List<String> listOfdesignation = new List<String>();
        List<Employee__c> updateEmployeeList = new List<Employee__c>();
        if(recordId != null){
            List<Employee__c> employeeList = [SELECT Id, Name, Designation__c FROM Employee__c WHERE Id =: recordId];
            listOfdesignation.add(employeeList[0].Designation__c);
        }
        if(designation != null && !listOfdesignation.contains(designation)){
            Employee__c employeeRecord = new Employee__c();
            employeeRecord.Id = recordId;
            employeeRecord.Designation__c = designation;
            updateEmployeeList.add(employeeRecord);
        }
        if(!updateEmployeeList.isEmpty()){
            update updateEmployeeList;
            System.debug(updateEmployeeList);
            createLeavesAllocated(updateEmployeeList[0].Id);
            return updateEmployeeList[0].Designation__c;
        }else {
            return null;
        }
    }

        private Static void createLeavesAllocated(String employeeId){
            List<Leaves_Allocated__c> leavesAllocatedList = new List<Leaves_Allocated__c>();
            if(employeeId != null){
                Leaves_Allocated__c leavesAllocatedForPaidLeave = new Leaves_Allocated__c();
                leavesAllocatedForPaidLeave.Leave_Type__c = 'PL';
                leavesAllocatedForPaidLeave.Count_Of_Leave__c = 1;
                leavesAllocatedForPaidLeave.Employee__c = employeeId;
                leavesAllocatedList.add(leavesAllocatedForPaidLeave);
                Leaves_Allocated__c leavesAllocatedForFloterLeave = new Leaves_Allocated__c();
                leavesAllocatedForFloterLeave.Leave_Type__c = 'FL';
                leavesAllocatedForFloterLeave.Count_Of_Leave__c = 4;
                leavesAllocatedForFloterLeave.Employee__c = employeeId;
                leavesAllocatedList.add(leavesAllocatedForFloterLeave);
            }
            if(!leavesAllocatedList.isEmpty()){
                insert leavesAllocatedList;
            }
        }
    

    public class Designation{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
    }


}