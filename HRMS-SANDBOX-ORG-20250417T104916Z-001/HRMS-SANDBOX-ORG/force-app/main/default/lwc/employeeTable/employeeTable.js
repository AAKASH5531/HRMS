import { LightningElement,api, wire, track } from 'lwc';
import getAccountList from '@salesforce/apex/EmployeeTable.getEmployeeList';
export default class EmployeeTable extends LightningElement {
    isSpinner = true;
    resultData = [];
    records = [];
    tableHeader;
    listOfProject;
    listOfEmployeeData;
    @track visibleRecord;
    noColor = false;

    connectedCallback(){
        getAccountList().then(result=>{
            console.log('result======>  ',result);
           if(result != null && result != undefined){
               this.tableHeader = result.listOfHeader;
               this.listOfProject = result.listOfAllProject;
               if(result.listOfEmployee != null && result.listOfEmployee.length > 0){
                let allData = [];
                let parentObj= {};
                
                    result.listOfEmployee.forEach(eachElement=>{
                        let assiProject = eachElement.listOfAssineeProject;
                        console.log('--eachElement.isBillable-------------------------------',eachElement.isBillable);
                        console.log('----eachElement.isTrainingProject-----------------------------',eachElement.isTrainingProject);
                        console.log('--eachElement.isShadow-------------------------------',eachElement.isShadow);
                         console.log('--eachElement.isNocolor-------------------------------',eachElement.isNocolor);
                        let assigneProjectName = [];
                        if(eachElement.isBillable){
                            parentObj["isBillableColorClass"] = "isBillableYellowColorClass";
                        }
                    
                        //  let prName = eachElement.isTrainingProject.toLowerCase();
                        if(eachElement.isTrainingProject){
                          parentObj["isBillableColorClass"] = "bgColorClassBlue";
                        }

                        
                        if(eachElement.isShadow){
                              parentObj["isBillableColorClass"] = "isBillableGreenColorClass";
                        }
                        if(eachElement.isNocolor){
                            parentObj["isBillableColorClass"] = "nocolor";
                        }
                         this.listOfEmployeeData = parentObj;
                        let mapOfProject = new Map();
                        if(assiProject != null && assiProject.length > 0){
                            assiProject.forEach(eachElement=>{
                               assigneProjectName.push(eachElement.projectName);
                               mapOfProject.set(eachElement.projectName,eachElement);
                            })
                        }
                        let obj = eachElement;
                        let empRecord = [];
                        this.listOfProject.forEach(tHead=>{
                         let obj1 = {};
                          if(assigneProjectName != null && assigneProjectName.length > 0 && assigneProjectName.includes(tHead)){
                                obj1["isProjectAssigned"] = true;
                                obj1["consumption"] = mapOfProject.get(tHead).percentageConsuming;
                                console.log('Percent=====>   ',mapOfProject.get(tHead).percentageConsuming);
                                if(mapOfProject.get(tHead).isShadow && mapOfProject.get(tHead).managerName ){
                                  obj1["isShadow"] = mapOfProject.get(tHead).isShadow;
                                  obj1["managerName"] = mapOfProject.get(tHead).managerName;
                                }
                                console.log('-----38---------mapOfProject.get(tHead).isBillable----------------->',mapOfProject.get(tHead).isBillable);
                                obj1["isBillable"] = mapOfProject.get(tHead).isBillable;
                                obj1["bandwidth"] = mapOfProject.get(tHead).bandwidth;
                                let prName = tHead.toLowerCase();
                                if(prName.includes('training project')){
                                    obj1["bgColorClass"] = "nothing";
                                    obj1["bgColorForBilable"] = "bgColorForBilableBlueClass";
                                }else{
                                    obj1["bgColorClass"] = assigneProjectName.length > 1 ? "bgColorClassOrange" : "nothing";
                                }
                                if(prName.includes('training project') && !mapOfProject.get(tHead).isBillable){
                                    obj1["isBillableColorClass"] = "bgColorClassBlue";
                                }else if(mapOfProject.get(tHead).isBillable){
                                    obj1["isBillableColorClass"] = "isBillableGreenColorClass";
                                }else if(mapOfProject.get(tHead).isShadow){
                                    obj1["isBillableColorClass"] = "isBillableYellowColorClass";
                                }else{
                                    obj1["isBillableColorClass"] = "nothing ";
                                }    
                            }else{
                                obj1["isProjectAssigned"] = false;
                                obj1["consumption"] = 0;
                                obj1["isShadow"] = false;
                                obj1["bgColorClass"] = "nothing";
                                obj1["isBillable"] = false;
                                obj1["bandwidth"] = 100;
                                obj1["bgColorForBilable"] = "nothing";
                            }
                            empRecord.push(obj1)
                        })
                        obj = JSON.parse(JSON.stringify(obj));
                        obj["assignedProject"] = empRecord;
                        allData.push(obj);
                        //allData.push(parentObj);
                    }) 
                    this.listOfEmployeeData = allData;     
               } 
           }
        })
        this.isSpinner = false;
    }

    updateEmployeeHandler(event){
        this.visibleRecord = [...event.detail.records]
        console.log(event.detail.records)

    }
}