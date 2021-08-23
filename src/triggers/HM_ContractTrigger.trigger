trigger HM_ContractTrigger on Contract__c (before insert, before update, after insert, after update) {
    new HM_ContractTriggerHandler().run();
}