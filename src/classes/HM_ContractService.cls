public with sharing class HM_ContractService {
    public static void checkOverlapping(List<Contract__c> newList) {
        List<Contract__c> existingContracts = createListOfExistingContracts(newList);
        Map<String, List<Contract__c>> contractsMap = createMapOfExistingContracts(existingContracts);
        String errorMessageOverlappingList = checkIfAddedListOverlapSelf(newList);
        String errorMessage = checkIfAddedListOverlapSelf(newList) + Label.errorAddContractMessage;
        Integer i = 1;
        for (Contract__c newContract : newList) {
            String key = String.valueOf(newContract.Doctor__c) + String.valueOf(newContract.Hospital__c);
            List<Contract__c> contractsList = contractsMap.get(key);
            if (contractsList != null) {
                for (Contract__c oldContract : contractsList) {
                    if (checkIfOverlapping(newContract, oldContract)) {
                        List<String> parameters = new List<String>();
                        if (oldContract.End_Date__c == null) {
                            parameters.add(String.valueOf(i));
                            parameters.add(String.valueOf(oldContract.Start_Date__c));
                            errorMessage += String.format(Label.errorOverlappingContractsNoEndDate, parameters);
                            i++;
                        } else {
                            parameters.add(String.valueOf(i));
                            parameters.add(String.valueOf(oldContract.Start_Date__c));
                            parameters.add(String.valueOf(oldContract.End_Date__c));
                            errorMessage += String.format(Label.errorOverlappingContracts, parameters);
                            i++;
                        }
//                            newContract.addError(errorMessage);
                    }
                }
            }
            if(errorMessage == (checkIfAddedListOverlapSelf(newList) + Label.errorAddContractMessage)){
                if(checkIfAddedListOverlapSelf(newList) != ''){
                    newContract.addError(errorMessageOverlappingList);
                }
            }else {
                newContract.addError(errorMessage);
            }
        }
    }

    private static Boolean checkIfOverlapping(Contract__c newContract, Contract__c oldContract) {
        Boolean isOverlapping = false;
        if ((newContract.Start_Date__c >= oldContract.Start_Date__c && newContract.Start_Date__c <= oldContract.End_Date__c)
                || (newContract.End_Date__c >= oldContract.Start_Date__c && newContract.End_Date__c <= oldContract.End_Date__c)
                || (oldContract.Start_Date__c >= newContract.Start_Date__c && oldContract.End_Date__c <= newContract.End_Date__c)
                || (oldContract.End_Date__c == null && newContract.End_Date__c >= oldContract.Start_Date__c)
//                || (oldContract.End_Date__c == null && newContract.End_Date__c == null && newContract.Start_Date__c <= oldContract.Start_Date__c)) {
                || (oldContract.End_Date__c == null && newContract.End_Date__c == null && newContract.Start_Date__c <= oldContract.Start_Date__c)
                || (oldContract.End_Date__c == null && newContract.End_Date__c == null && newContract.Start_Date__c >= oldContract.Start_Date__c)) {
            isOverlapping = true;
        }
        return isOverlapping;
    }

    private static String checkIfAddedListOverlapSelf(List<Contract__c> newList) {
        String errorMsg = '';
        for (Integer i = 0; i < newList.size(); i++) {
            for (Integer j = 0; j < newList.size(); j++) {
                String keyI = String.valueOf(newList[i].Doctor__c) + String.valueOf(newList[i].Hospital__c);
                String keyJ = String.valueOf(newList[j].Doctor__c) + String.valueOf(newList[j].Hospital__c);
                if (i != j && keyI == keyJ) {
                    if (checkIfOverlapping(newList[i], newList[j])) {
                        errorMsg = Label.errorMessageIfContractsOverlappInAddList;
                    }
                }
            }
        }
        return errorMsg;
    }

    private static List<Contract__c> createListOfExistingContracts(List<Contract__c> newList) {
        Set<Id> doctorsId = new Set<Id>();
        Set<Id> hospitalsId = new Set<Id>();
        for (Contract__c contracts : newList) {
            doctorsId.add(contracts.Doctor__c);
            hospitalsId.add(contracts.Hospital__c);
        }
        List<Contract__c> existingContracts = [
                SELECT Hospital__c, Doctor__c, Start_Date__c, End_Date__c
                FROM Contract__c
                WHERE Doctor__c IN :doctorsId AND Hospital__c IN :hospitalsId
        ];
        return existingContracts;
    }

    private static Map<String, List<Contract__c>> createMapOfExistingContracts(List<Contract__c> existingContracts){
        Map<String, List<Contract__c>> contractsMap = new Map<String, List<Contract__c>>();
        for (Contract__c contract : existingContracts) {
            String keyString = String.valueOf(contract.Doctor__c) + String.valueOf(contract.Hospital__c);
            List<Contract__c> contractsToMap = contractsMap.get(keyString);
            if (contractsToMap == null) {
                contractsToMap = new List<Contract__c>();
                contractsMap.put(keyString, contractsToMap);
            }
            contractsToMap.add(contract);
        }
        return contractsMap;
    }
}