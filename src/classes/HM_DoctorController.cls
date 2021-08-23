public with sharing class HM_DoctorController {
    public List<Doctor__c> doctorsList { get; set; }
    public List<Doctor__c> doctorsListToExport { get; set; }
    public Doctor__c doctor { get; set; }
    public Boolean hideButton { get; set; }
    public String csvString { get; set; }
    Public Integer size { get; set; }
    public List<SelectOption> paginationSizeOptions { get; set; }
    public String stringQuery { get; set; }
    public Integer pageNumberInteger { get; set; }
    public HM_DoctorController() {
        size = 5;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5', '5'));
        paginationSizeOptions.add(new SelectOption('10', '10'));
        paginationSizeOptions.add(new SelectOption('20', '20'));
        paginationSizeOptions.add(new SelectOption('50', '50'));
        paginationSizeOptions.add(new SelectOption('100', '100'));
        doctor = new Doctor__c();
        doctorsList = new List<Doctor__c>();
        doctorsListToExport = new List<Doctor__c>();
        hideButton = true;
        stringQuery = 'select Name, Last_Name__c, E_mail_Adress__c, Country__c ' +
                'from Doctor__c Limit 0';
        csvString = '';
    }
    public ApexPages.StandardSetController setStandardController {
        get {
            if (setStandardController == null) {
                setStandardController = new ApexPages.StandardSetController(Database.getQueryLocator(stringQuery));
            }
            return setStandardController;
        }
        set;
    }
    public void searchDoctors() {
        hideButton = false;
        String country = doctor.Country__c;
        stringQuery = '' +
                'select Name, Last_Name__c, E_mail_Adress__c, Country__c ' +
                'from Doctor__c ' +
                'where Country__c like \'%' + country + '%\'';
        if (doctor.Name != null) {
            stringQuery += ' AND Name like \'%' + doctor.Name + '%\'';
        }
        if (doctor.Last_Name__c != null) {
            stringQuery += ' AND Last_Name__c like \'%' + doctor.Last_Name__c + '%\'';
        }
        if (doctor.E_mail_Adress__c != null) {
            stringQuery += ' AND E_mail_Adress__c like \'%' + doctor.E_mail_Adress__c + '%\'';
        }
        setStandardController = new ApexPages.StandardSetController(Database.getQueryLocator(stringQuery));
        doctorsListToExport = setStandardController.getRecords();
        setStandardController.setPageSize(size);
        pageNumberInteger = 1;
        setStandardController.setPageNumber(pageNumberInteger);
        doctorsList = setStandardController.getRecords();
        if (doctorsList.size() < 1) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Data not found'));
            hideButton = true;
        }
    }
    public void nextPage() {
        setStandardController.next();
        doctorsList = setStandardController.getRecords();
    }
    public void prevPage() {
        setStandardController.previous();
        doctorsList = setStandardController.getRecords();
    }
    public void firstPage() {
        setStandardController.first();
        doctorsList = setStandardController.getRecords();
    }
    public void lastPage() {
        setStandardController.last();
        doctorsList = setStandardController.getRecords();
    }
    public void refreshPageSize() {
        setStandardController.setPageSize(size);
        doctorsList = setStandardController.getRecords();
    }
    public List<Doctor__c> getDoctors() {
        return (List<Doctor__c>) setStandardController.getRecords();
    }
    public void clear() {
        setStandardController = null;
        doctorsList = null;
        hideButton = true;
        doctorsListToExport = null;
        size = 5;
        doctor.clear();
        stringQuery = 'select Name, Last_Name__c, E_mail_Adress__c, Country__c ' +
                'from Doctor__c Limit 0';
    }
    public PageReference CreateXLS() {
        PageReference pr = new PageReference('/apex/HM_DoctorsListToXls');
        return pr;
    }
    public void createCsvString() {
        csvString = '"First Name","Last Name","E-mail","Country"\r\n';
        for (Doctor__c doc : doctorsListToExport) {
            csvString += '"' + doc.Name + '",';
            csvString += '"' + doc.Last_Name__c + '",';
            csvString += '"' + doc.E_mail_Adress__c + '",';
            csvString += '"' + doc.Country__c + '"\r\n';
        }
    }
    public PageReference CreateCSV() {
        PageReference pr = new PageReference('/apex/HM_DoctorsListToCsv');
        return pr;
    }
}