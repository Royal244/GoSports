public with sharing class TA_SearchAccountController {
    @AuraEnabled
    public static List<Account> getAccounts(String accName) {
        try {
            String searchText = '%' + accName + '%' ;
            List<Account> accounts = [SELECT Id, Name, BillingPostalCode, BillingCity,BillingStreet, BillingAddress FROM Account WHERE Name LIKE :searchText];
            System.debug('to jest dramat '+accName);
            return accounts;
        } catch (Exception e) {
            throw new AccountsSearchException('Cannot retrieve accounts');
        }
    }

    public class AccountsSearchException extends Exception {}
}