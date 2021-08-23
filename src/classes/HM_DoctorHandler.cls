public with sharing class HM_DoctorHandler {

    @Future(callout = true)
    public static void addDoctorsOnExternalOrg(String serializedDoctors){
        List<Doctor__c> doctors = new List<Doctor__c>();
        HM_RestService restService = new HM_RestService();
        doctors = (List<Doctor__c>) JSON.deserialize(serializedDoctors, List<Doctor__c>.class);
        HM_RestService.HM_DoctorsWrappersList doctorsWrappersList = new HM_RestService.HM_DoctorsWrappersList();
        for (Doctor__c doctor : doctors) {
            HM_RestService.HM_DoctorWrapper doctorWrapper = new HM_RestService.HM_DoctorWrapper();
            doctorWrapper.id = doctor.Id;
            doctorWrapper.name = doctor.Name;
            doctorWrapper.lastName = doctor.Last_Name__c;
            doctorWrapper.email = doctor.E_mail_Adress__c;
            doctorWrapper.telephoneNumber = doctor.Telephone_Number__c;
            doctorWrapper.country = doctor.Country__c;
            doctorsWrappersList.doctorWrappers.add(doctorWrapper);
        }
        System.debug('DS doctorsWrappersList: ' + doctorsWrappersList);

        HM_RestService.HM_ResponseWrapper responseWrapper = restService.addDoctors(doctorsWrappersList);
        List<HM_RestService.HM_DoctorWrapper> wrappersLists = responseWrapper.doctorWrappers;
        for (Doctor__c doctor : doctors) {
            for (HM_RestService.HM_DoctorWrapper hm_doctorWrapper : wrappersLists) {
                if (doctor.Id == hm_doctorWrapper.externalId) {
                    doctor.ExternalId__c = hm_doctorWrapper.id;
                }
            }
        }
        System.debug('Doctors List that is update: ' + doctors);
        update doctors;
        //insert
    }
//    @Future(callout=true)
//    public static void updateDoctorOnExternalOrg(String serializedDoctors){
//        List<Doctor__c> doctors = new List<Doctor__c>();
//        HM_RestService restService = new HM_RestService();
//        doctors = (List<Doctor__c>) JSON.deserialize(serializedDoctors, List<Doctor__c>.class);
//        HM_RestService.HM_DoctorWrapper doctorWrapper = new HM_RestService.HM_DoctorWrapper();
//        for (Doctor__c doctor : doctors) {
//            doctorWrapper.id = doctor.ExternalId__c;
//            doctorWrapper.name = doctor.Name;
//            doctorWrapper.lastName = doctor.Last_Name__c;
//            doctorWrapper.email = doctor.ExternalId__c;
//            doctorWrapper.telephoneNumber = doctor.Telephone_Number__c;
//        }
//        System.debug('wraper to edit on ex org: ' + doctorWrapper);
//        HM_RestService.HM_ResponseWrapper responseWrapper = restService.updateDoctor(doctorWrapper);
//
//    }
}