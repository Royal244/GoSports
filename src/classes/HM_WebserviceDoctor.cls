global with sharing class HM_WebserviceDoctor {
    webService static List<Doctor__c> getDoctor(){
        List<Doctor__c> doctors = new List<Doctor__c>();
        doctors = [
                SELECT Id, Name, Last_Name__c
                FROM Doctor__c
        ];
        return doctors;
    }

    webService static void createDoctor(String name, String lastName, Integer birthDay, Integer birthMonth, Integer birthYear, String telNumber, String eMail, String country, String city){
        Doctor__c doctor = new Doctor__c();
        doctor.Last_Name__c = lastName;
        doctor.Name = name;
        doctor.Date_of_birth__c = Date.newInstance(birthYear, birthMonth, birthDay);
        doctor.Telephone_Number__c = telNumber;
        doctor.E_mail_Adress__c = eMail;
        doctor.Country__c = country;
        doctor.City__c = city;
        insert doctor;
    }

    webService static void deleteDoctor(String Id){
        Doctor__c doctor = [
                SELECT Id
                FROM Doctor__c
                WHERE Id = :Id
        ];
        delete doctor;
    }
}