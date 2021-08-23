@IsTest
private class HM_RestServiceTest {
    static final String successToken = 'success';

    private static HM_RestMock buildAuthorizationMock(Integer statusCode, String status, HM_RestService.HM_AccessTokenWrapper body) {
        Map<String, String> headers = new Map<String, String>{
                'Content-Type' => 'application/json'
        };
        return new HM_RestMock(statusCode, status, JSON.serialize(body), headers);
    }

    private static HM_RestMock buildSuccessAuthorizationMock() {
        HM_RestService.HM_AccessTokenWrapper atw = new HM_RestService.HM_AccessTokenWrapper();
        atw.access_token = successToken;
        return buildAuthorizationMock(200, 'Ok', atw);
    }

    @IsTest
    static void shouldGetAuthToken() {
        Map<String, HttpCalloutMock> mocksMap = new Map<String, HttpCalloutMock>{
                'https://login.salesforce.com/services/oauth2/token' => buildSuccessAuthorizationMock()
        };
        HM_RestMultiMock multiMock = new HM_RestMultiMock(mocksMap);
        Test.setMock(HttpCalloutMock.class, multiMock);

        Test.startTest();
        HM_RestService restService = new HM_RestService();
        Test.stopTest();

        System.assertEquals(successToken, restService.token);
    }

    @IsTest
    static void shouldGetDoctors() {
        Map<String, String> headers = new Map<String, String>{
                'Content-Type' => 'application/json'
        };
        HM_RestService.HM_ResponseWrapper responseWrapper = new HM_RestService.HM_ResponseWrapper();
        responseWrapper.isSuccess = true;
        responseWrapper.message = successToken;
        Doctor__c doctor = new Doctor__c(Name = 'test', Last_Name__c = 'test');
        responseWrapper.doctorWrappers = new List<HM_RestService.HM_DoctorWrapper>{
                new HM_RestService.HM_DoctorWrapper(doctor)
        };
        Map<String, HttpCalloutMock> mocksMap = new Map<String, HttpCalloutMock>{
                'https://login.salesforce.com/services/oauth2/token' => buildSuccessAuthorizationMock(),
                'https://britenet-dc-dev-ed.my.salesforce.com/services/apexrest/Doctor' => new HM_RestMock(200, 'OK', JSON.serialize(responseWrapper), headers)
        };
        HM_RestMultiMock multiMock = new HM_RestMultiMock(mocksMap);
        Test.setMock(HttpCalloutMock.class, multiMock);

        Test.startTest();
        HM_RestService restService = new HM_RestService();
        HM_RestService.HM_ResponseWrapper response = restService.getDoctors(new Map<String, String>{
                'Name' => doctor.Name
        });
        Test.stopTest();

        System.assert(response.isSuccess);
        System.assertEquals(1, response.doctorWrappers.size());
        System.assertEquals(doctor.Name, response.doctorWrappers[0].name);
        System.assertEquals(doctor.Last_Name__c, response.doctorWrappers[0].lastName);
    }

    @IsTest
    static void shouldDeleteDoctor() {
        Map<String, String> headers = new Map<String, String>{
                'Content-Type' => 'application/json'
        };
        HM_RestService.HM_ResponseWrapper responseWrapper = new HM_RestService.HM_ResponseWrapper();
        responseWrapper.isSuccess = true;
        responseWrapper.message = successToken;
        responseWrapper.doctorWrappers = null;
        Map<String, HttpCalloutMock> mocksMap = new Map<String, HttpCalloutMock>{
                'https://login.salesforce.com/services/oauth2/token' => buildSuccessAuthorizationMock(),
                'https://britenet-dc-dev-ed.my.salesforce.com/services/apexrest/Doctor' => new HM_RestMock(200, 'OK', JSON.serialize(responseWrapper), headers)
        };
        HM_RestMultiMock multiMock = new HM_RestMultiMock(mocksMap);
        Test.setMock(HttpCalloutMock.class, multiMock);

        Test.startTest();
        HM_RestService restService = new HM_RestService();
        HM_RestService.HM_ResponseWrapper response = restService.deleteDoctor(new Map<String, String>{
                'Id' => '12345678'
        });
        Test.stopTest();

        System.assert(response.isSuccess);
    }

    @IsTest
    static void shouldAddDoctor() {
        Map<String, String> headers = new Map<String, String>{
                'Content-Type' => 'application/json'
        };
        HM_RestService.HM_ResponseWrapper responseWrapper = new HM_RestService.HM_ResponseWrapper();
        responseWrapper.isSuccess = true;
        responseWrapper.message = successToken;
        Doctor__c doctor = new Doctor__c(Name = 'test', Last_Name__c = 'test');
        responseWrapper.doctorWrappers = new List<HM_RestService.HM_DoctorWrapper>{
                new HM_RestService.HM_DoctorWrapper(doctor)
        };
        Map<String, HttpCalloutMock> mocksMap = new Map<String, HttpCalloutMock>{
                'https://login.salesforce.com/services/oauth2/token' => buildSuccessAuthorizationMock(),
                'https://britenet-dc-dev-ed.my.salesforce.com/services/apexrest/Doctor' => new HM_RestMock(200, 'OK', JSON.serialize(responseWrapper), headers)
        };
        HM_RestMultiMock multiMock = new HM_RestMultiMock(mocksMap);
        Test.setMock(HttpCalloutMock.class, multiMock);

        Test.startTest();
        HM_RestService restService = new HM_RestService();
        List<HM_RestService.HM_DoctorWrapper> wrappers = new List<HM_RestService.HM_DoctorWrapper>();
        HM_RestService.HM_DoctorWrapper doctorWrapper = new HM_RestService.HM_DoctorWrapper();
        doctorWrapper.name = 'test';
        doctorWrapper.lastName = 'test';
        wrappers.add(doctorWrapper);
        HM_RestService.HM_DoctorsWrappersList doctorsWrappersList = new HM_RestService.HM_DoctorsWrappersList();
        doctorsWrappersList.doctorWrappers = wrappers;
        HM_RestService.HM_ResponseWrapper response = restService.addDoctors(doctorsWrappersList);
        Test.stopTest();

        System.assert(response.isSuccess);
        System.assertEquals(1, response.doctorWrappers.size());
        System.assertEquals(doctor.Name, response.doctorWrappers[0].name);
        System.assertEquals(doctor.Last_Name__c, response.doctorWrappers[0].lastName);
    }

    @IsTest
    static void shouldEditDoctor() {
        Map<String, String> headers = new Map<String, String>{
                'Content-Type' => 'application/json'
        };
        HM_RestService.HM_ResponseWrapper responseWrapper = new HM_RestService.HM_ResponseWrapper();
        responseWrapper.isSuccess = true;
        responseWrapper.message = successToken;
        Doctor__c doctor = new Doctor__c(Name = 'test', Last_Name__c = 'test');
        responseWrapper.doctorWrappers = new List<HM_RestService.HM_DoctorWrapper>{
                new HM_RestService.HM_DoctorWrapper(doctor)
        };
        Map<String, HttpCalloutMock> mocksMap = new Map<String, HttpCalloutMock>{
                'https://login.salesforce.com/services/oauth2/token' => buildSuccessAuthorizationMock(),
                'https://britenet-dc-dev-ed.my.salesforce.com/services/apexrest/Doctor' => new HM_RestMock(200, 'OK', JSON.serialize(responseWrapper), headers)
        };
        HM_RestMultiMock multiMock = new HM_RestMultiMock(mocksMap);
        Test.setMock(HttpCalloutMock.class, multiMock);
        Test.startTest();
        HM_RestService restService = new HM_RestService();
        Doctor__c doctorTest = new Doctor__c(Name = 'test', Last_Name__c = 'test');
        HM_RestService.HM_ResponseWrapper response = restService.updateDoctor(new HM_RestService.HM_DoctorWrapper(doctorTest));
        Test.stopTest();

        System.assert(response.isSuccess);
        System.assertEquals(1, response.doctorWrappers.size());
        System.assertEquals(doctor.Name, response.doctorWrappers[0].name);
        System.assertEquals(doctor.Last_Name__c, response.doctorWrappers[0].lastName);
    }


}