public with sharing class HM_DoctorTriggerHandler extends HM_TriggerHandler{
    private List<Doctor__c> newList;
    private List<Doctor__c> oldList;
    private Map<Id, Doctor__c> newMap;
    private Map<Id, Doctor__c> oldMap;

    public HM_DoctorTriggerHandler() {
        This.newList = (List<Doctor__c>) Trigger.new;
        This.oldList = (List<Doctor__c>) Trigger.old;
        This.newMap = (Map<Id, Doctor__c>) Trigger.newMap;
        This.oldMap = (Map<Id, Doctor__c>) Trigger.oldMap;
    }

    protected override void afterInsert() {
//        HM_DoctorHandler handler = new HM_DoctorHandler();
        String serializeDoctors = JSON.serialize(newList);
        HM_DoctorHandler.addDoctorsOnExternalOrg(serializeDoctors);
    }

}