import { LightningElement, track, wire, api } from 'lwc';
import projectNameList from "@salesforce/apex/EmployeeSkillMetrics.getProjectName";
import getEmployeeInf from "@salesforce/apex/EmployeeSkillMetrics.getEmployeeInf";
import employeeSkillsPackage from "@salesforce/apex/EmployeeSkillMetrics.employeeSkillsPackage";

export default class EmployeeSkillMetric extends LightningElement {
    isPartial;
    isLoading = false;
    isFullyMatchSkill;
    isShowSection;
    @track allProjectName;
    @track TypeOptions;
    @track employeeExperience;
    @track projectName;
    employeeWithProjectSkill;
    employeeName;
    employeeAndProjectSkillName = [];
    employeeWithProjectPackSkill =[];
    employeeWithProjectPackSkillAndProjectSkil = [];
    isSecondTable = false;
    isFirstTable = false;
    @wire(projectNameList, {})
    WiredObjects_Type({ error, data }) {
 
        if (data) {
            try {
                this.allProjectName = data; 
                let options = []; 
                for (var key in data) {
                    options.push({ label: data[key].Name, value: data[key].Id  });
                }
                this.TypeOptions = options;
                 
            } catch (error) {
                console.error('check error here', error);
            }
        } else if (error) {
            console.error('check error here', error);
        }
    }
    handleTypeChange(event){
        this.projectName = event.target.value
        this.isShowSection = true;
        this.handleEmployeeInfo();
    }
    handleEmployeeInfo(event) {
        this.isLoading = true;
        console.log('=event============================',event);
       if(event != null){
            this.employeeExperience = event.target.value;
            console.log('event.target.value====  this.employeeExperience ==================',this.employeeExperience);
        }
        console.log('this.employeeExperience-----53--------------------',this.employeeExperience);
        getEmployeeInf({ employeeExperince: this.employeeExperience, projectName: this.projectName})
          .then(result => {
          //  console.log('-------result--54-------------',result);
            this.employeeWithProjectSkill = result;
            this.mergeBothTableInSingleTable(true,false);
          }).catch(error => {
            this.searchData = undefined;
        })
        employeeSkillsPackage({ employeeExperince: this.employeeExperience, projectName: this.projectName
        }).then(result => {
           // console.log('-------result-68--------------',result);
            this.employeeWithProjectPackSkill = result;
            this.mergeBothTableInSingleTable(false,true);
            this.isLoading = false;
        }).catch(error => {
            this.isLoading = false;
            this.searchData = undefined;
        })
    }

    mergeBothTableInSingleTable(isFirstTable, isSecondTable){
            if(isFirstTable){
                this.isFirstTable = true;
               // console.log('this.isFirstTable ',this.isFirstTable);
            }
            if(isSecondTable){
                this.isSecondTable = true;
                //console.log('this.isSecondTable ',this.isSecondTable);
            }
            if(this.isFirstTable && this.isSecondTable){
                this.employeeWithProjectPackSkillAndProjectSkil = [];
                this.isSecondTable = false;
                this.isFirstTable = false;
                // console.log('First employeeWithProjectSkill Table Data => ',this.employeeWithProjectSkill);
                // console.log('Second employeeWithProjectPackSkill Table Data => ',this.employeeWithProjectPackSkill);
                this.employeeWithProjectPackSkillAndProjectSkil = this.employeeWithProjectPackSkillAndProjectSkil.concat(this.employeeWithProjectSkill, this.employeeWithProjectPackSkill);
               // console.log('this.employeeWithProjectPackSkillAndProjectSkil => ',this.employeeWithProjectPackSkillAndProjectSkil);
            }
    }
}