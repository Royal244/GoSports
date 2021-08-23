public with sharing class HM_ExternalDoctorsController {
    public HM_DoctorSoapService soapService;
    public List<HM_DoctorSoapService.HM_doctorWrapper> doctorWrappers { get; set; }
    public HM_DoctorSoapService.HM_doctorWrapper searchWrapper { get; set; }
    public HM_DoctorSoapService.HM_doctorWrapper editDoctorWrapper { get; set; }
    public HM_DoctorSoapService.HM_doctorWrapper editDoctorWrapperHolder { get; set; }
    public HM_DoctorSoapService.HM_doctorWrapper addDoctorWrapper { get; set; }
    public soapSforceComSchemasClassHmSoupser.HM_responseWrapper responseWrapper { get; set; }
    public HM_DoctorSoapService.HM_responseWrapper responseWrapperAnswer { get; set; }
    public String idToEdit { get; set; }
    public String idToDelete { get; set; }
    public Boolean isSuccess { get; set; }
    public String message { get; set; }


    public HM_ExternalDoctorsController() {
        soapService = new HM_DoctorSoapService();
        doctorWrappers = new List<HM_DoctorSoapService.HM_doctorWrapper>();
        searchWrapper = new HM_DoctorSoapService.HM_doctorWrapper();
        editDoctorWrapper = new HM_DoctorSoapService.HM_doctorWrapper();
        editDoctorWrapperHolder = new HM_DoctorSoapService.HM_doctorWrapper();
        addDoctorWrapper = new HM_DoctorSoapService.HM_doctorWrapper();
        responseWrapper = new soapSforceComSchemasClassHmSoupser.HM_responseWrapper();
        responseWrapperAnswer = new HM_DoctorSoapService.HM_responseWrapper();
        idToEdit = '';
        idToDelete = '';
        message = '';
    }

    public void getDoctors() {
        if (soapService.getDoctors(searchWrapper) != null) {
            doctorWrappers = soapService.getDoctors(searchWrapper);
        } else {
            if(doctorWrappers != null){
                doctorWrappers.clear();
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Data not found'));
        }
    }

    public void clearApexMessages(){
        ApexPages.getMessages().clear();
    }

    public void clear() {
        doctorWrappers = null;
        searchWrapper.doctorName = '';
        searchWrapper.doctorLastName = '';
        searchWrapper.doctorCountry = '';
        searchWrapper.doctorEmail = '';
    }

    public void getIdToDelete() {
        idToDelete = ApexPages.currentPage().getParameters().get('doctorId');
    }

    public void clearAddDoctorModal(){
        addDoctorWrapper.doctorName = '';
        addDoctorWrapper.doctorLastName = '';
        addDoctorWrapper.doctorCountry = '';
        addDoctorWrapper.doctorEmail = '';
        addDoctorWrapper.doctorTelephone = '';
    }

    public void deleteDoctor() {
        Integer remove = null;
        for (HM_DoctorSoapService.HM_doctorWrapper hm_doctorWrapper : doctorWrappers) {
            if (idToDelete == hm_doctorWrapper.doctorId) {
                remove = doctorWrappers.indexOf(hm_doctorWrapper);
            }
        }
        if (remove != null) {
            doctorWrappers.remove(remove);
        }
        soapService.deleteDoctor(idToDelete);
    }

    public void addDoctor() {
        responseWrapper = soapService.addDoctor(addDoctorWrapper.doctorName, addDoctorWrapper.doctorLastName, addDoctorWrapper.doctorCountry, addDoctorWrapper.doctorEmail, addDoctorWrapper.doctorTelephone);
        isSuccess = responseWrapper.isSuccess;
        message = responseWrapper.message;
        if (!isSuccess) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, message));
        }else {
            clearAddDoctorModal();
        }
    }

    public void getDoctorToEdit() {
        idToEdit = ApexPages.currentPage().getParameters().get('doctorIdToEdit');
        for (HM_DoctorSoapService.HM_doctorWrapper hm_doctorWrapper : doctorWrappers) {
            if (idToEdit == hm_doctorWrapper.doctorId) {
//                editDoctorWrapper = hm_doctorWrapper;
                editDoctorWrapper = new HM_DoctorSoapService.HM_doctorWrapper();
                editDoctorWrapper.doctorName = hm_doctorWrapper.doctorName;
                editDoctorWrapper.doctorLastName = hm_doctorWrapper.doctorLastName;
                editDoctorWrapper.doctorEmail = hm_doctorWrapper.doctorEmail;
                editDoctorWrapper.doctorCountry = hm_doctorWrapper.doctorCountry;
                editDoctorWrapper.doctorTelephone = hm_doctorWrapper.doctorTelephone;
                editDoctorWrapperHolder = hm_doctorWrapper;
            }
        }
    }

    public void editDoctor() {
        responseWrapper = soapService.updateDoctor(idToEdit, editDoctorWrapper.doctorName, editDoctorWrapper.doctorLastName, editDoctorWrapper.doctorCountry, editDoctorWrapper.doctorEmail, editDoctorWrapper.doctorTelephone);
        isSuccess = responseWrapper.isSuccess;
        message = responseWrapper.message;
        if (!isSuccess) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, message));
        }
        getDoctors();
    }

    public void leaveNotEditedDoctor(){
        editDoctorWrapper = editDoctorWrapperHolder;
    }
}