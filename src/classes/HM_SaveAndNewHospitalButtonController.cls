public with sharing class HM_SaveAndNewHospitalButtonController {
    public Hospital__c hospital;
    public HM_SaveAndNewHospitalButtonController(ApexPages.StandardController stdController){
        this.hospital = (Hospital__c)stdController.getRecord();
    }
    public PageReference SaveAndAddNewHospital(){
        Schema.DescribeSObjectResult r = Hospital__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        upsert hospital;
        PageReference pr = new PageReference('/'+keyPrefix+'/e');
        return pr;
    }
}