public with sharing class HM_SaveAndNewDoctorButtonController {
    public Doctor__c doctor;
    public HM_SaveAndNewDoctorButtonController (ApexPages.StandardController stdController){
        this.doctor = (Doctor__C)stdController.getRecord();
    }
    public PageReference SaveAndNew()
    {
        Schema.DescribeSObjectResult r = Doctor__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        upsert doctor;
        PageReference pageRef = new PageReference('/'+keyPrefix+'/e');
        return pageRef;
    }
}