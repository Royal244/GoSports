public with sharing class HM_CsvUploadController {
    public Blob csvFileBody { get; set; }
    public string csvAsString { get; set; }
    public String[] csvFileLines { get; set; }
    public List<Doctor__c> doctorsList { get; set; }
    public List<element> listOfElements { get; set; }
    public Boolean simpleTextUnderTable { get; set; }
    public String errorMsg { get; set; }
    public Integer fileSize { get; set; }
    public Boolean isDisable { get; set; }
//    public List<String> csvRecordData {get;set;}
    public HM_CsvUploadController() {
        csvFileLines = new String[]{
        };
        doctorsList = New List<Doctor__c>();
        simpleTextUnderTable = true;
        isDisable = true;
        listOfElements = new List<element>();
//        csvRecordData = new List<String>();
    }

    public void importCSVFile() {
        try {
            System.debug('rozmiar pliku' + fileSize);
//            if (csvFileBody == null) {
//                ApexPages.Message noFile = new ApexPages.Message(ApexPages.severity.ERROR, 'Select File.');
//                ApexPages.addMessage(noFile);
//            }
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\r\n');
            System.debug(JSON.serializePretty(csvFileLines));
            System.debug(csvFileLines[1]);
            listOfElements = new List<element>();
            isDisable = false;

            for (Integer i = 1; i < csvFileLines.size(); i++) {

                string[] csvRecordData = csvFileLines[i].split(',');
                System.debug(csvRecordData);
                element element = new element();
                element.index = i;
                element.doctor.Name = csvRecordData[0];
                element.doctor.Last_Name__c = csvRecordData[1] ;
                element.doctor.E_mail_Adress__c = csvRecordData[2];
                element.doctor.Country__c = csvRecordData[3];
                element.doctor.Date_of_birth__c = Date.parse(csvRecordData[4]);
                element.doctor.Telephone_Number__c = csvRecordData[5];
                element.doctor.City__c = csvRecordData[6];
                listOfElements.add(element);
            }
            System.debug(listOfElements);
            simpleTextUnderTable = false;
            //insert contractsList;
        } catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'Check your CSV file. It must meet all assumptions contained in the manual. If you do not chose file chose it.');
            ApexPages.addMessage(errorMessage);
            if (listOfElements.size() > 0) {
                listOfElements.clear();
            }
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            isDisable = true;
        }
    }

    public void clear() {
        listOfElements.clear();
        simpleTextUnderTable = true;
        isDisable = true;
        csvFileBody = null;
    }

    public void selectAll() {
        for (element element : listOfElements) {
            element.selected = true;
        }
    }

    public void noneSelect() {
        for (element element : listOfElements) {
            element.selected = false;
        }
    }

    public void reverseSelect() {
        for (element element : listOfElements) {
            if (element.selected) {
                element.selected = false;
            } else {
                element.selected = true;
            }
        }
    }

    public void importSelectedDoctors() {
        List<Doctor__c> doctorsToInsert = new List<Doctor__c>();
        List<element> selectedElements = new List<element>();
        for (element element : listOfElements) {
            if (element.selected) {
                doctorsToInsert.add(element.doctor);
                selectedElements.add(element);
            }
        }
        Database.SaveResult[] srList = Database.insert(doctorsToInsert, false);
        for (Integer i = 0; i < srList.size(); i++) {
            Integer index = selectedElements[i].index - 1;
            if (srList[i].isSuccess()) {
                listOfElements[index].status = 'Success';
                listOfElements[index].id = srList[i].getId();
                listOfElements[index].viewLink = true;
            } else {
                List<Database.Error> errors = srList[i].getErrors();
                System.debug(errors);
                errorMsg = '';
                for (Database.Error error : errors) {
                    errorMsg += (error.message + '\n');
                    System.debug(errorMsg);
                }
                listOfElements[index].status = errorMsg;
            }
        }
        System.debug(doctorsToInsert);

    }

    public class element {
        public Doctor__c doctor { get; set; }
        public Boolean selected { get; set; }
        public String status { get; set; }
        public Integer index { get; set; }
        public String id { get; set; }
        public Boolean viewLink { get; set; }

        public element() {
            this.doctor = new Doctor__c();
            this.selected = false;
            this.status = '';
            this.viewLink = false;
        }
    }
}