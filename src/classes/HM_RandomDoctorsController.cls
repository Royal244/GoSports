public without sharing class HM_RandomDoctorsController {
    public List<Doctor__c> doctors { set; get; }
    public List<Doctor__c> randomDoctors { set; get; }
    public Integer i = 0;
    public Integer IntrandomNumber = Integer.valueof((Math.random() * 5));
    public HM_RandomDoctorsController() {
        doctors = new List<Doctor__c>();
    }
    public void findFiveRandomDoctors() {
        doctors = [
                SELECT Name, Last_Name__c, E_mail_Adress__c, Telephone_Number__c, Country__c
                FROM Doctor__c LIMIT 5 OFFSET :IntrandomNumber
        ];
    }
}