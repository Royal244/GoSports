public with sharing class HM_DoctorSoapService {
    public soapSforceComSchemasClassHmSoupser.HM_SoupService soapService;
    public soapSforceComSchemasClassHmSoupser.SessionHeader_element header;

    public HM_DoctorSoapService() {
        soapService = new soapSforceComSchemasClassHmSoupser.HM_SoupService();
        header = new soapSforceComSchemasClassHmSoupser.SessionHeader_element();
        header.sessionId = getSessionId();
        soapService.SessionHeader = header;
    }

    public String getSessionId() {
        partnerSoapSforceCom.Soap soap = new partnerSoapSforceCom.Soap();
//        HM_IntegrationSetting__c setting = HM_IntegrationSetting__c.getInstance('DoctorsSoapInte');
//        setting.Login;
        HM_Settings__c login =  HM_Settings__c.getInstance('Login');
        HM_Settings__c password =  HM_Settings__c.getInstance('Password');
        partnerSoapSforceCom.LoginResult loginResult = soap.login(login.Value__c, password.Value__c);
        return loginResult.sessionId;
    }

    public List<HM_doctorWrapper> getDoctors(HM_doctorWrapper wrapper) {
        soapSforceComSchemasClassHmSoupser.HM_responseWrapper responseWrapper = new soapSforceComSchemasClassHmSoupser.HM_responseWrapper();
        try {
            responseWrapper = soapService.getDoctors(wrapper.doctorName, wrapper.doctorLastName, wrapper.doctorEmail, wrapper.doctorCountry);
            System.debug('=====================================');
            System.debug(responseWrapper);
        } catch (Exception e) {
        }

        return convertSoapResponseWrappers(responseWrapper.doctorWrappersList);
    }

    public List<HM_doctorWrapper> convertSoapResponseWrappers(List<soapSforceComSchemasClassHmSoupser.HM_doctorWrapper> soapWrappers) {
        List<HM_doctorWrapper> wrappers = new List<HM_doctorWrapper>();
        if (soapWrappers == null) {
            wrappers = null;
            return wrappers;
        }
        for (soapSforceComSchemasClassHmSoupser.HM_doctorWrapper wrapper : soapWrappers) {
            HM_doctorWrapper newWrapper = new HM_doctorWrapper();
            newWrapper.doctorName = wrapper.doctorName;
            newWrapper.doctorLastName = wrapper.doctorLastName;
            newWrapper.doctorEmail = wrapper.doctorEmail;
            newWrapper.doctorCountry = wrapper.doctorCountry;
            newWrapper.doctorId = wrapper.doctorId;
            newWrapper.doctorTelephone = wrapper.doctorTelephone;
            wrappers.add(newWrapper);
        }
        return wrappers;
    }

    public void deleteDoctor(String id) {
        soapSforceComSchemasClassHmSoupser.HM_responseWrapper responseWrapper = new soapSforceComSchemasClassHmSoupser.HM_responseWrapper();
        try {
            responseWrapper = soapService.deleteDoctor(id);
        } catch (Exception e) {}
    }

    public soapSforceComSchemasClassHmSoupser.HM_responseWrapper addDoctor(String name, String lastName, String country, String email, String telephoneNumber) {
        soapSforceComSchemasClassHmSoupser.HM_responseWrapper responseWrapper = new soapSforceComSchemasClassHmSoupser.HM_responseWrapper();
        try {
            responseWrapper = soapService.addDoctor(name, lastName, country, email, telephoneNumber);
        } catch (Exception e) {}
        return responseWrapper;
    }

    public soapSforceComSchemasClassHmSoupser.HM_responseWrapper updateDoctor(String id, String name, String lastName, String country, String email, String telephoneNumber){
        soapSforceComSchemasClassHmSoupser.HM_responseWrapper responseWrapper = new soapSforceComSchemasClassHmSoupser.HM_responseWrapper();
        try {
            responseWrapper = soapService.updateDoctor(id, name, lastName, country, email, telephoneNumber);
        }catch (Exception e){}
        return responseWrapper;
    }

    public class HM_doctorWrapper {
        public String doctorName { get; set; }
        public String doctorLastName { get; set; }
        public String doctorCountry { get; set; }
        public String doctorEmail { get; set; }
        public String doctorId { get; set; }
        public String doctorTelephone { get; set; }

        public HM_doctorWrapper() {
        }

        public HM_doctorWrapper(Doctor__c doctor) {
            this.doctorName = doctor.Name != null ? doctor.Name : '';
            this.doctorLastName = doctor.Last_Name__c;
            this.doctorCountry = doctor.Country__c;
            this.doctorEmail = doctor.E_mail_Adress__c;
            this.doctorId = doctor.Id;
            this.doctorTelephone = doctor.Telephone_Number__c;
        }
    }

    public class HM_responseWrapper {
        public Boolean isSuccess;
        public List<HM_doctorWrapper> doctorWrappersList;
        public String message;
    }
}