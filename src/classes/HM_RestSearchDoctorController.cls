public with sharing class HM_RestSearchDoctorController {
    public HM_RestService restService;
    public List<HM_RestService.HM_doctorWrapper> doctorWrappers { get; set; }
    public HM_RestService.HM_doctorWrapper searchWrapper { get; set; }
    public HM_RestService.HM_doctorWrapper editDoctorWrapper { get; set; }
    public HM_RestService.HM_doctorWrapper editDoctorWrapperHolder { get; set; }
    public HM_RestService.HM_doctorWrapper addDoctorWrapper { get; set; }
    public String idToEdit { get; set; }
    public String externalIdToEdit { get; set; }
    public String idToDelete { get; set; }
    public String externalIdToDelete { get; set; }
    public Boolean isSuccess { get; set; }
    public String message { get; set; }
    public Map<String, String> parameters { get; set; }
    public Boolean rendered { get; set; }
    public Boolean disabledSearch { get; set; }
    public Boolean disabledClear { get; set; }

    public HM_RestSearchDoctorController() {
        doctorWrappers = new List<HM_RestService.HM_DoctorWrapper>();
        searchWrapper = new HM_RestService.HM_doctorWrapper();
        editDoctorWrapper = new HM_RestService.HM_doctorWrapper();
        editDoctorWrapperHolder = new HM_RestService.HM_doctorWrapper();
        addDoctorWrapper = new HM_RestService.HM_doctorWrapper();
        idToEdit = '';
        idToDelete = '';
        externalIdToEdit = '';
        externalIdToDelete = '';
        message = '';
        parameters = new Map<String, String>();
        restService = new HM_RestService();
        rendered = true;
        disabledSearch = true;
        disabledClear = true;
    }

    public void getDoctors() {
        message = '';
        try {
            if (doctorWrappers != null) {
                doctorWrappers.clear();
            }
            parameters = createMap(searchWrapper);
            String query = createQuery(parameters);
            List<HM_RestService.HM_DoctorWrapper> thisOrgDoctorWrappers = new List<HM_RestService.HM_DoctorWrapper>();
            if (query != null) {
                thisOrgDoctorWrappers = getDoctorsFromMyOrg(query);
            }
            List<HM_RestService.HM_DoctorWrapper> externalDoctorWrappers = restService.getDoctors(parameters).doctorWrappers;
//            System.debug('----------------------------');
//            System.debug(externalDoctorWrappers);
            for (HM_RestService.HM_DoctorWrapper hm_doctorWrapper : thisOrgDoctorWrappers) {
                hm_doctorWrapper.gotItOnMyOrg = true;
//                System.debug('external ID' + hm_doctorWrapper.externalId);
                if (hm_doctorWrapper.externalId != null) {
//                    System.debug('elo');
                    hm_doctorWrapper.gotItOnExternalOrg = true;
                }
            }
            if (externalDoctorWrappers != null) {
                for (HM_RestService.HM_DoctorWrapper hm_doctorWrapper : externalDoctorWrappers) {
                    hm_doctorWrapper.gotItOnExternalOrg = true;
                }
            }

            List<String> ids = new List<String>();
            for (HM_RestService.HM_DoctorWrapper wrapper : thisOrgDoctorWrappers) {
                ids.add(wrapper.id);
            }
            if (externalDoctorWrappers != null) {
                for (HM_RestService.HM_DoctorWrapper wrapper : externalDoctorWrappers) {
                    if (!ids.contains(wrapper.externalId)) {
                        thisOrgDoctorWrappers.add(wrapper);
                    }
                }
            }

            doctorWrappers = thisOrgDoctorWrappers;
            if (doctorWrappers.size() > 0) {
                rendered = false;
            }
            disabledClear = false;
        } catch (Exception e) {
//            ApexPages.getMessages()
//            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Data not found'));
        }

    }

    public void clearApexMessages() {
        ApexPages.getMessages().clear();
    }

    public void clear() {
        doctorWrappers = null;
        searchWrapper.name = '';
        searchWrapper.lastName = '';
        searchWrapper.email = '';
        searchWrapper.country = '';
        rendered = true;
        disabledSearch = true;
        disabledClear = true;
        message = '';
    }

    public void getIdToDelete() {
        idToDelete = ApexPages.currentPage().getParameters().get('doctorId');
        externalIdToDelete = ApexPages.currentPage().getParameters().get('doctorExternalId');
    }

    public void clearAddDoctorModal() {
        addDoctorWrapper.name = '';
        addDoctorWrapper.lastName = '';
        addDoctorWrapper.country = '';
        addDoctorWrapper.telephoneNumber = '';
        addDoctorWrapper.email = '';
    }

    public void deleteDoctor() {
        message = '';
        Map<String, String> deleteMap = new Map<String, String>();
        Integer indexOfDeleted = null;
        if (externalIdToDelete == null || externalIdToDelete == '') {
            externalIdToDelete = idToDelete;
//            System.debug('weszło 12313');
//            System.debug('====================');
//            System.debug(idToDelete);
//            System.debug(externalIdToDelete);
        }
        deleteMap.put('Id', externalIdToDelete);
//        System.debug('id to delete: ' + idToDelete);
//        System.debug('id external to delete: ' + externalIdToDelete);
        for (HM_RestService.HM_DoctorWrapper wrapper : doctorWrappers) {
            if (wrapper.id == idToDelete && wrapper.externalId == externalIdToDelete && wrapper.gotItOnMyOrg == true && wrapper.gotItOnExternalOrg == true) {
//                System.debug('warunek 1');
                List<Doctor__c> doctors = doctorToDelete(idToDelete);
                restService.deleteDoctor(deleteMap);
                delete doctors;
                indexOfDeleted = doctorWrappers.indexOf(wrapper);
            } else if (wrapper.gotItOnExternalOrg == true && wrapper.id == externalIdToDelete) {
//                System.debug('warunek 2');
                restService.deleteDoctor(deleteMap);
                indexOfDeleted = doctorWrappers.indexOf(wrapper);
            } else if (wrapper.gotItOnMyOrg == true && wrapper.id == idToDelete) {
//                System.debug('warunek 3');
//                System.debug('this org:   ' + wrapper.gotItOnMyOrg);
                List<Doctor__c> doctors = doctorToDelete(idToDelete);
                delete doctors;
                indexOfDeleted = doctorWrappers.indexOf(wrapper);
            }
        }
        if (indexOfDeleted != null) {
            doctorWrappers.remove(indexOfDeleted);
        }
        deleteMap.clear();
//        getDoctors();
    }

    public void addDoctor() {
        message = '';
        isSuccess = false;
        Map<String, String> mapToAdd = new Map<String, String>();
        mapToAdd.put('E_mail_Adress__c', addDoctorWrapper.email);
        List<HM_RestService.HM_DoctorWrapper> externalDoctorWrappers = restService.getDoctors(mapToAdd).doctorWrappers;
        List<HM_RestService.HM_DoctorWrapper> doctorWrappers = getDoctorsFromMyOrg(createQuery(mapToAdd));
//        System.debug('this: ' + doctorWrappers);
//        System.debug('external: ' + externalDoctorWrappers);
        try {
            if (externalDoctorWrappers == null && doctorWrappers.isEmpty()) {
//                System.debug('pusto');
                Doctor__c doctor = createDoctor(addDoctorWrapper);
                insert doctor;
                isSuccess = true;
//                System.debug('sukces: ' + isSuccess);
                if (!isSuccess) {
                    message = 'Can\'t add doctor. This e-mail already exist.';
//                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Can\'t add doctor.'));
//                    List<ApexPages.Message> listMessages = ApexPages.getMessages();
//                    for (ApexPages.Message msg : listMessages) {
//                        message += msg.getSummary() + ' ';
//                    }
                } else {
                    clearAddDoctorModal();
                }
//                isSuccess = false;
            } else {
                message = 'Can\'t add doctor. This e-mail already exist.';
//                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Can\'t add doctor.'));
//                List<ApexPages.Message> listMessages = ApexPages.getMessages();
//                for (ApexPages.Message msg : listMessages) {
//                    message += msg.getSummary() + ' ';
//                }
            }
//            restService.getDoctors(mapToAdd).doctorWrappers
//            restService.addDoctor(addDoctorWrapper);
        } catch (Exception e) {
            message = 'Can\'t add doctor. Type correct country.';
        }
    }

    public void getDoctorToEdit() {
        isSuccess = false;
        idToEdit = ApexPages.currentPage().getParameters().get('doctorIdToEdit');
        externalIdToEdit = ApexPages.currentPage().getParameters().get('doctorIdToEditExternal');
        for (HM_RestService.HM_DoctorWrapper hm_doctorWrapper : doctorWrappers) {
            if (idToEdit == hm_doctorWrapper.id) {
//                editDoctorWrapper = hm_doctorWrapper;
                editDoctorWrapper = new HM_RestService.HM_DoctorWrapper();
                editDoctorWrapper.name = hm_doctorWrapper.name;
                editDoctorWrapper.lastName = hm_doctorWrapper.lastName;
                editDoctorWrapper.email = hm_doctorWrapper.email;
                editDoctorWrapper.country = hm_doctorWrapper.country;
                editDoctorWrapper.telephoneNumber = hm_doctorWrapper.telephoneNumber;
                editDoctorWrapper.gotItOnMyOrg = hm_doctorWrapper.gotItOnMyOrg;
                editDoctorWrapper.gotItOnExternalOrg = hm_doctorWrapper.gotItOnExternalOrg;
                editDoctorWrapperHolder = hm_doctorWrapper;
            }
        }
    }

    public void editDoctor() {
        message = '';
        Map<String, String> mapOfDoctorToEdit = new Map<String, String>();
        Map<String, String> mapOfDoctorToEditThisOrg = new Map<String, String>();

        if (externalIdToEdit == null || externalIdToEdit == '') {
            externalIdToEdit = idToEdit;
        }
        mapOfDoctorToEdit.put('Id', externalIdToEdit);
        mapOfDoctorToEditThisOrg.put('Id', idToEdit);
//        System.debug('---------------------------------------------------------------------------------------------');
//        List<HM_RestService.HM_DoctorWrapper> externalDoctorWrappers = restService.getDoctors(mapOfDoctorToEdit).doctorWrappers;
//        System.debug('za tym');
//        List<HM_RestService.HM_DoctorWrapper> doctorWrappers = getDoctorsFromMyOrg(createQuery(mapOfDoctorToEdit));
//        List<Doctor__c> doctors = Database.query(createQuery(mapOfDoctorToEditThisOrg));
//        System.debug('query: ' + createQuery(mapOfDoctorToEditThisOrg));
//        System.debug('za tym 2 ' + doctors);
//        System.debug('-=-=-=-=-=-=-=-=');
//        System.debug(externalDoctorWrappers);
        try {
            if (editDoctorWrapper.gotItOnExternalOrg) {
                HM_RestService.HM_DoctorWrapper doctorWrapper = new HM_RestService.HM_DoctorWrapper();
                doctorWrapper.id = externalIdToEdit;
                doctorWrapper.name = editDoctorWrapper.name;
                doctorWrapper.lastName = editDoctorWrapper.lastName;
                doctorWrapper.email = editDoctorWrapper.email;
                doctorWrapper.country = editDoctorWrapper.country;
                doctorWrapper.telephoneNumber = editDoctorWrapper.telephoneNumber;
                HM_RestService.HM_ResponseWrapper responseWrapper = restService.updateDoctor(doctorWrapper);
                System.debug('wraper to edit: ' + doctorWrapper);
//                isSuccess = true;
                if (!responseWrapper.isSuccess) {
                    message = 'Can\'t update doctor. This e-mail already exist or country  isn\'t correct.';
//                    throw new DoctorException('Can\'t update doctor.');
                }
            }
            if (editDoctorWrapper.gotItOnMyOrg) {
                Doctor__c doctor = new Doctor__c();
                doctor.Name = editDoctorWrapper.name;
                doctor.Last_Name__c = editDoctorWrapper.lastName;
                doctor.Telephone_Number__c = editDoctorWrapper.telephoneNumber;
                doctor.E_mail_Adress__c = editDoctorWrapper.email;
                doctor.Country__c = editDoctorWrapper.country;
                doctor.Id = idToEdit;
                System.debug('doctor to edit: ' + doctor);
                update doctor;
            }
            isSuccess = true;

        } catch (Exception e) {
//            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Can\'t update doctor.'));
            message = 'Can\'t update doctor. This e-mail already exist or country  isn\'t correct.';
//            List<ApexPages.Message> listMessages = ApexPages.getMessages();
//            for (ApexPages.Message msg : listMessages) {
//                message += msg.getSummary() + ' ';
//            }
        }

    }

    public void leaveNotEditedDoctor() {
        editDoctorWrapper = editDoctorWrapperHolder;
    }

    public void isFieldCompleted() {
        if (searchWrapper.name.length() > 0 || searchWrapper.lastName.length() > 0 || searchWrapper.email.length() > 0 || searchWrapper.country.length() > 0) {
            disabledSearch = false;
        } else {
            disabledSearch = true;
        }
    }

    public static Map<String, String> createMap(HM_RestService.HM_doctorWrapper wrapper) {
        Map<String, String> filteredMap = new Map<String, String>();
        if (wrapper.name != '') {
            filteredMap.put('Name', wrapper.name);
        }
        if (wrapper.lastName != '') {
            filteredMap.put('Last_Name__c', wrapper.lastName);
        }
        if (wrapper.email != '') {
            filteredMap.put('E_mail_Adress__c', wrapper.email);
        }
        if (wrapper.country != '') {
            filteredMap.put('Country__c', wrapper.country);
        }
        return filteredMap;
    }

    public static List<HM_RestService.HM_doctorWrapper> getDoctorsFromMyOrg(String query) {
        List<HM_RestService.HM_doctorWrapper> listToReturn = new List<HM_RestService.HM_DoctorWrapper>();
        List<Doctor__c> doctors = Database.query(query);
        listToReturn = convertDoctorsToWrapper(doctors);
        return listToReturn;
    }

    public static String createQuery(Map<String, String> parameters) {
        String query = 'SELECT Id, Name, Last_Name__c, E_mail_Adress__c, Country__c, Telephone_Number__c, ExternalId__c FROM Doctor__c WHERE ';
        Iterator<String> iterator = parameters.keySet().Iterator();
        while (iterator.hasNext()) {
            String key = iterator.next();
            if (key == 'Id') {
                query += (key + ' = ' + '\'' + parameters.get(key) + '\'');
            } else {
                query += (key + ' LIKE ' + '\'%' + parameters.get(key) + '%\'');
            }
            if (iterator.hasNext()) {
                query += ' AND ';
            }
        }
        return query;
    }

    public static List <HM_RestService.HM_DoctorWrapper> convertDoctorsToWrapper(List<Doctor__c> doctors) {
        List<HM_RestService.HM_DoctorWrapper> wrappers = new List<HM_RestService.HM_DoctorWrapper>();
        for (Doctor__c doctor : doctors) {
            wrappers.add(new HM_RestService.HM_DoctorWrapper(doctor));
        }
        return wrappers;
    }

    public static List<Doctor__c> doctorToDelete(String id) {
        String query = 'SELECT Id FROM Doctor__c WHERE Id = \'' + id + '\' LIMIT 1';
//        Doctor__c doctor = Database.query(query);
        List<Doctor__c> doctors = Database.query(query);
        return doctors;
    }

    public static Doctor__c createDoctor(HM_RestService.HM_DoctorWrapper wrapper) {
        Doctor__c doctor = new Doctor__c();
        doctor.Name = wrapper.name;
        doctor.Last_Name__c = wrapper.lastName;
        doctor.E_mail_Adress__c = wrapper.email;
        doctor.Telephone_Number__c = wrapper.telephoneNumber;
        doctor.Country__c = wrapper.country;
        System.debug('external id: ' + wrapper.externalId);
        doctor.ExternalId__c = wrapper.externalId;
        return doctor;
    }

    class DoctorException extends Exception {
    }

}