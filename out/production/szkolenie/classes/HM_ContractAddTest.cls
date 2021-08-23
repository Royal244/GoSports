@IsTest
private class HM_ContractAddTest {
    @isTest
    private static void testShouldNotInsertWhenOverlappingBeforeExisting() {
        SetupData superData = new SetupData();
        Contracts__c newContract = superData.createContract(
                superData.getDoctor(),
                superData.getHospital(),
                Date.newInstance(2021, 6, 10),
                Date.newInstance(2021, 6, 17)
        );

        Test.startTest();
        Database.insert(newContract, false);
        Test.stopTest();

        System.assert(superData.checkIfSelectedContractWasAdd(newContract) != null, 'Overlapping contract was inserted');
    }

    @isTest
    private static void testShouldNotInsertWhenOverlappingAfterExisting() {
        SetupData superData = new SetupData();

        Test.startTest();
        Contracts__c newContract = superData.createContract(
                superData.getDoctor(),
                superData.getHospital(),
                Date.newInstance(2021, 6, 19),
                Date.newInstance(2021, 6, 26)
        );
        Database.insert(newContract, false);
        Test.stopTest();

        System.assert(superData.checkIfSelectedContractWasAdd(newContract) == null, 'Overlapping contract was inserted');
    }

    @isTest
    private static void testShouldNotInsertWhenOverlappingInExisting() {
        SetupData superData = new SetupData();
        Contracts__c newContract = superData.createContract(
                superData.getDoctor(),
                superData.getHospital(),
                Date.newInstance(2021, 6, 17),
                Date.newInstance(2021, 6, 19)
        );

        Test.startTest();
        Database.insert(newContract, false);
        Test.stopTest();

        System.assert(superData.checkIfSelectedContractWasAdd(newContract) == null, 'Overlapping contract was inserted');
    }

    @isTest
    private static void testShouldNotInsertWhenOverlappingBeforeExistingWithoutEndDate() {
        SetupData superData = new SetupData();
        Contracts__c newContract = superData.createContract(
                superData.getDoctor(),
                superData.getHospital(),
                Date.newInstance(2021, 7, 10),
                Date.newInstance(2021, 7, 26)
        );

        Test.startTest();
        Database.insert(newContract, false);
        Test.stopTest();

        System.assert(superData.checkIfSelectedContractWasAdd(newContract) == null, 'Overlapping contract was inserted');
    }

    @isTest
    private static void testShouldNotInsertWhenOverlappingInAddedList() {
        SetupData superData = new SetupData();
        List<Contracts__c> testContracts = new List<Contracts__c>();
        for (Integer i = 0; i < 10; i++) {
            Contracts__c newContract = superData.createContract(
                    superData.getDoctor(),
                    superData.getHospital(),
                    Date.newInstance(2021, 7, 10),
                    Date.newInstance(2021, 7, 26)
            );
            testContracts.add(newContract);
        }

        Test.startTest();
        Database.insert(testContracts, false);
        Test.stopTest();

        System.assert(superData.checkIfSelectedContractWasAdd(testContracts[0]) == null, 'Overlapping contract was inserted');
    }

    private class SetupData {
        private Doctor__c doctor;
        private Hospital__c hospital;
        private List<Doctor__c> doctorsList = new List<Doctor__c>();
        private List<Hospital__c> hospitalsList = new List<Hospital__c>();
        Contracts__c contract = new Contracts__c();
        Contracts__c contract2 = new Contracts__c();

        public SetupData() {
            createDoctor();
            createHospital();
            contract.Start_Date__c = Date.newInstance(2021, 6, 16);
            contract.End_Date__c = Date.newInstance(2021, 6, 20);
            contract.Hospital__c = hospital.Id;
            contract.Doctor__c = doctor.Id;
            contract.Solary__c = 6543;
            insert contract;
            contract2.Start_Date__c = Date.newInstance(2021, 7, 15);
            contract2.Hospital__c = hospital.Id;
            contract2.Doctor__c = doctor.Id;
            contract2.Solary__c = 6543;
            insert contract2;
        }

        private void createDoctor() {
            doctor = new Doctor__c(
                    Last_Name__c = 'testDoctor112313',
                    Name = 'testDoctor121312321',
                    Gender__c = 'Male',
                    Date_of_birth__c = Date.today(),
                    Telephone_Number__c = '+48123456789',
                    E_mail_Adress__c = 'testt1@mail.com',
                    Country__c = 'Poland',
                    City__c = 'Wwa',
                    Zip_Postal_Code__c = '11 111',
                    Street_Address__c = 'test 1');
            insert doctor;
        }
        private Doctor__c getDoctor() {
//        if (doctorsList != null) {
            return doctor = [
                    SELECT Id
                    FROM Doctor__c
                    Limit 1
            ];
        }
        private void createHospital() {
            hospital = new Hospital__c(
                    Name = 'hospitaltest112312313',
                    Country__c = 'Poland',
                    City__c = 'Wwa',
                    Zip_Postal_Code__c = '11 111',
                    Street_Address__c = 'test 1',
                    Telephone_Number__c = '+48123456789',
                    E_mail_Adress__c = 'testtt1231311@mail.com');
            insert hospital;
        }
        private Hospital__c getHospital() {
            return hospital = [
                    SELECT Id
                    FROM Hospital__c
                    Limit 1
            ];
        }
        private Contracts__c createContract(Doctor__c doc, Hospital__c hosp, Date startDate, Date endDate) {
            Contracts__c contract = new Contracts__c();
            contract.Doctor__c = doc.Id;
            contract.Hospital__c = hosp.Id;
            contract.Start_Date__c = startDate;
            contract.End_Date__c = endDate;
            contract.Solary__c = 1234;
            return contract;
        }
        private Contracts__c checkIfSelectedContractWasAdd(Contracts__c contract) {
            List<Contracts__c> tempContracts = [
                    SELECT Id
                    FROM Contracts__c
                    WHERE Start_Date__c = :contract.Start_Date__c AND End_Date__c = :contract.End_Date__c
                    LIMIT 1
            ];
            if (tempContracts.isEmpty()) {
                return null;
            }
            return tempContracts[0];
        }
    }
}