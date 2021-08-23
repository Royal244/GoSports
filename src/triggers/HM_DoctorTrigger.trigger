trigger HM_DoctorTrigger on Doctor__c (before insert, before update, after insert, after update) {
    new HM_DoctorTriggerHandler().run();
}