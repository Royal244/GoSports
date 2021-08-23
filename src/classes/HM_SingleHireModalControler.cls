public with sharing class HM_SingleHireModalControler {
    public List<Hospital__c> hospitals { get; set; }
    public Doctor__c doctor { get; set; }
    public Hospital__c hospital { get; set; }
    public Contract__c contract { get; set; }
    public Boolean renderTable { get; set; }
    public String selectedHospitalId { get; set; }
    public Boolean disableButton { get; set; }
    public Boolean renderHireDates { get; set; }
    public List<element> elements { get; set; }
    public Boolean clearButton { get; set; }
    public Boolean isAdded { get; set; }
    public List<Contract__c> addedContractsList { get; set; }
    public Integer sizeOfAddedDoctors { get; set; }
    private String selectedHospital;

    public HM_SingleHireModalControler(ApexPages.StandardController stdController) {
        this.hospitals = new List<Hospital__c>();
        this.doctor = (Doctor__c) stdController.getRecord();
        this.hospital = new Hospital__c();
        this.contract = new Contract__c();
        this.renderTable = false;
        this.disableButton = false;
        this.renderHireDates = false;
        this.elements = new List<element>();
        this.clearButton = true;
//        this.isAdded = true;
        this.sizeOfAddedDoctors = 0;
    }

    public void searchHospitals() {
        elements.clear();
        String queryString = 'SELECT name, City__c, Country__c FROM Hospital__c ' +
                'WHERE Country__c like \'%' + hospital.Country__c + '%\'';
        if (hospital.Name != null) {
            queryString += 'AND Name like \'%' + hospital.Name + '%\'';
        }
        if (hospital.City__c != null) {
            queryString += 'AND City__c like \'%' + hospital.City__c + '%\'';
        }
        hospitals = Database.query(queryString);

        for (Hospital__c hospital : hospitals) {
            element element = new element();
            element.hospital = hospital;
            element.isSelected = false;
            elements.add(element);
        }
        System.debug(hospitals);
        renderTable = true;
        clearButton = false;
        if (renderHireDates) {
            renderHireDates = false;
        }
        if (contract.Start_Date__c != null || contract.End_Date__c != null || contract.Salary__c != null) {
            contract.Start_Date__c = null;
            contract.End_Date__c = null;
            contract.Salary__c = null;
        }
        if (hospitals.size() < 1) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Data not found'));
            System.debug('pusta tabela');
//            clearButton = true;
        }
    }

    public void selectHospital() {
        selectedHospitalId = System.currentPageReference().getParameters().get('hospitalId');
        System.debug(selectedHospitalId);
        System.debug(doctor);
        renderHireDates = true;
        for (element element : elements) {
            if (element.hospital.Id == selectedHospitalId) {
                element.isSelected = true;
            } else {
                element.isSelected = false;
            }
        }
    }

    public void hireDoctor() {
        System.debug('elo');
        Hospital__c hospital = [SELECT Id FROM Hospital__c WHERE Id = :selectedHospitalId];
        contract.Doctor__c = doctor.Id;
        contract.Hospital__c = hospital.Id;
        System.debug(contract);
        List<Contract__c> tempContracts = new List<Contract__c>();
        tempContracts.add(contract);
        if (contract.Salary__c <= 0) {
            contract.addError('Salary need to more then 0');
        }
        Database.SaveResult[] srList = Database.insert(tempContracts, false);
        System.debug(srList);
        for (Database.SaveResult saveResult : srList) {
            System.debug(JSON.serializePretty(saveResult));
            if (saveResult.isSuccess()) {
                isAdded = true;
            } else {
                isAdded = false;
            }

        }
        System.debug(isAdded);
    }

    public void clearModal() {
        elements.clear();
        hospitals.clear();
        hospital.Country__c = null;
        hospital.Name = null;
        if (hospital.City__c != null) {
            hospital.City__c = null;
        }
        renderTable = false;
        renderHireDates = false;
        clearButton = true;
        contract.Start_Date__c = null;
//        contract.End_Date__c = null;
        contract.Salary__c = null;
        System.debug('12312312321');
    }

    public class element {
        public Hospital__c hospital { get; set; }
        public Boolean isSelected { get; set; }
    }
}