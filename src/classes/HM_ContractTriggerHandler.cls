public with sharing class HM_ContractTriggerHandler extends HM_TriggerHandler {
    private List<Contract__c> newList;
    private List<Contract__c> oldList;
    private Map<Id, Contract__c> newMap;
    private Map<Id, Contract__c> oldMap;
    public HM_ContractTriggerHandler() {
        This.newList = (List<Contract__c>) Trigger.new;
        This.oldList = (List<Contract__c>) Trigger.old;
        This.newMap = (Map<Id, Contract__c>) Trigger.newMap;
        This.oldMap = (Map<Id, Contract__c>) Trigger.oldMap;
    }

    protected override void beforeInsert() {
        HM_ContractService.checkOverlapping(newList);
    }

    protected override void beforeUpdate() {
        HM_ContractService.checkOverlapping(newList);
    }
}