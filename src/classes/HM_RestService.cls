global with sharing class HM_RestService {
    private String clientId;
    private String clientSecret;
    private String clientLogin;
    private String clientPassword;
    private String authEndPoint;
    @TestVisible private String token;
    private String mainEndPoint;
    private String authBody;

    public HM_RestService() {
        loginDefault();
        this.token = getAccessToken();
    }

    public void loginDefault() {
        this.clientId = '3MVG9SOw8KERNN0_SHqmrwFns8Z28oNlJ64uRj3npUV81OStJQcqpKpNxyMF9ZInRi_GcpzZmKi953Deolbg_';
        this.clientSecret = '717718D533A0B866B9A658D168C8D90010AA6D72F31FA9FAD5A4FC476829856A';
        this.clientLogin = 'integration@integration.com';
        this.clientPassword = 'xsw2%23EDCszXRWXu3O5jRS0aD5CBDiW5O';
        this.authEndPoint = 'https://login.salesforce.com/services/oauth2/token';
        this.mainEndPoint = 'https://britenet-dc-dev-ed.my.salesforce.com/services/apexrest/Doctor';
        this.authBody = 'grant_type=password&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + clientLogin + '&password=' + clientPassword;
    }

    private String getAccessToken() {
        if (getAccessTokenFromCache() != null) {
            token = getAccessTokenFromCache();
        } else {
            token = login();
        }
        return token;
    }

    public String login() {
        HttpResponse response;
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader(
                'Content-Type', 'application/x-www-form-urlencoded'
        );
        request.setEndpoint(authEndPoint);
        request.setBody(authBody);
        response = new Http().send(request);
        HM_AccessTokenWrapper atw = (HM_AccessTokenWrapper) JSON.deserialize(response.getBody(), HM_AccessTokenWrapper.class);
        String requestToken = atw.access_token;
        addAccessTokenToCache(requestToken);
        token = requestToken;
        return requestToken;
    }

    private void addAccessTokenToCache(String token) {
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.HMAccessTokenToIntegrationOrg');
        sessionPart.put('token', token);

    }

    @TestVisible
    private String getAccessTokenFromCache() {
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.HMAccessTokenToIntegrationOrg');
        String token = (String)sessionPart.get('token');
        if (token != null) {
            return token;
        }else {
            return null;
        }
    }

    private String endpointBuilder(Map<String, String> parameters, String mainEndpoint) {
        String requestEndpoint = mainEndpoint;
        if (!parameters.isEmpty() && parameters.isEmpty() != null) {
            Iterator<String> iterator = parameters.keySet().Iterator();
            requestEndpoint += '?';
            while (iterator.hasNext()) {
                String key = iterator.next();
                requestEndpoint += (key + '=' + parameters.get(key));
                if (iterator.hasNext())
                    requestEndpoint += '&';
            }
        }
        return requestEndpoint;
    }

    private HttpRequest createRequest(String endPoint, String methodType, HM_DoctorWrapper doctorWrapper, HM_DoctorsWrappersList wrappersList) {
        HttpRequest request = new HttpRequest();
        String accessToken = 'Bearer ' + token;
        request.setEndpoint(endPoint);
        request.setMethod(methodType);
        request.setHeader('Authorization', accessToken);
        if (methodType.equals('POST')) {
            request.setHeader('Content-Type', 'application/json');
            request.setBody(JSON.serialize(wrappersList));
        } else if (methodType.equals('PATCH')) {
            request.setHeader('Content-Type', 'application/json');
            request.setBody(JSON.serialize(doctorWrapper));
        }
        return request;
    }

    private static HttpResponse createResponse(HttpRequest request) {
        HttpResponse response = new Http().send(request);
        return response;
    }

    public HM_ResponseWrapper getDoctors(Map<String, String> parameters) {
        HM_ResponseWrapper responseWrapper = new HM_ResponseWrapper();
        try {
            responseWrapper = tryToGetDoctors(parameters);
        } catch (BadAuthorizationException e) {
            login();
            responseWrapper = tryToGetDoctors(parameters);
        }
        return responseWrapper;
    }

    public HM_ResponseWrapper tryToGetDoctors(Map<String, String> parameters) {
        HM_ResponseWrapper responseWrapper = new HM_ResponseWrapper();
        try {
            String requestEndpoint = endpointBuilder(parameters, mainEndPoint);
            HttpRequest request = createRequest(requestEndpoint, 'GET', null, null);
            HttpResponse response = createResponse(request);
            if (response.getBody().contains('Unauthorized')) {
                throw new BadAuthorizationException ('Bad authorization');
            }
            responseWrapper = (HM_ResponseWrapper) JSON.deserialize(response.getBody(), HM_ResponseWrapper.class);
        } catch (Exception e) {}
        return responseWrapper;
    }

    public HM_ResponseWrapper deleteDoctor(Map<String, String> parameters){
        HM_ResponseWrapper responseWrapper = new HM_ResponseWrapper();
        try {
            responseWrapper = tryToDeleteDoctor(parameters);
        }catch (BadAuthorizationException e) {
            login();
            responseWrapper = tryToGetDoctors(parameters);
        }
        return responseWrapper;
    }

    public HM_ResponseWrapper tryToDeleteDoctor(Map<String, String> parameters) {
        HM_ResponseWrapper responseWrapper = new HM_ResponseWrapper();
        try {
            String requestEndpoint = endpointBuilder(parameters, mainEndPoint);
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request = createRequest(requestEndpoint, 'DELETE', null, null);
            response = createResponse(request);
            if (response.getBody().contains('Unauthorized')) {
                throw new BadAuthorizationException ('Bad authorization');
            }
            responseWrapper = (HM_ResponseWrapper) JSON.deserialize(response.getBody(), HM_ResponseWrapper.class);
        } catch (Exception e) {}
        return responseWrapper;
    }

    @TestVisible
    public HM_ResponseWrapper addDoctors(HM_DoctorsWrappersList wrappersList){
        HM_ResponseWrapper responseWrapper = new HM_ResponseWrapper();
        try {
            responseWrapper = tryToAddDoctors(wrappersList);
        }catch (BadAuthorizationException e) {
            login();
            responseWrapper = tryToAddDoctors(wrappersList);
        }
        return responseWrapper;
    }

    public HM_ResponseWrapper tryToAddDoctors(HM_DoctorsWrappersList wrappersList) {
        HM_ResponseWrapper responseWrapper = new HM_ResponseWrapper();
        try {
            String requestEndpoint = mainEndPoint;
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request = createRequest(requestEndpoint, 'POST', null, wrappersList);
            response = createResponse(request);
            if (response.getBody().contains('Unauthorized')) {
                throw new BadAuthorizationException ('Bad authorization');
            }
            responseWrapper = (HM_ResponseWrapper) JSON.deserialize(response.getBody(), HM_ResponseWrapper.class);
        } catch (Exception e) {}
        return responseWrapper;
    }

    public HM_ResponseWrapper updateDoctor(HM_DoctorWrapper doctorWrapper) {
        HM_ResponseWrapper responseWrapper = new HM_ResponseWrapper();
        try {
            responseWrapper = tryToUpdateDoctor(doctorWrapper);
        }catch (BadAuthorizationException e) {
            login();
            responseWrapper = tryToUpdateDoctor(doctorWrapper);
        }
        return responseWrapper;
    }

    public HM_ResponseWrapper tryToUpdateDoctor(HM_DoctorWrapper doctorWrapper) {
        HM_ResponseWrapper responseWrapper = new HM_ResponseWrapper();
        try {
            String requestEndpoint = mainEndPoint;
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request = createRequest(requestEndpoint, 'PATCH', doctorWrapper, null);
            response = createResponse(request);
            if (response.getBody().contains('Unauthorized')) {
                throw new BadAuthorizationException ('Bad authorization');
            }
            responseWrapper = (HM_ResponseWrapper) JSON.deserialize(response.getBody(), HM_ResponseWrapper.class);
        } catch (Exception e) {}
        return responseWrapper;
    }

    global class HM_DoctorWrapper {
        public String telephoneNumber { get; set; }
        public String name { get; set; }
        public String lastName { get; set; }
        public String id { get; set; }
        public String email { get; set; }
        public String country { get; set; }
        public String externalId { get; set; }
        public Boolean gotItOnMyOrg { get; set; }
        public Boolean gotItOnExternalOrg { get; set; }

        global HM_DoctorWrapper() {
        }

        global HM_DoctorWrapper(Doctor__c doctor) {
            this.name = doctor.Name != null ? doctor.Name : '';
            this.lastName = doctor.Last_Name__c;
            this.country = doctor.Country__c;
            this.email = doctor.E_mail_Adress__c;
            this.id = doctor.Id;
            this.telephoneNumber = doctor.Telephone_Number__c;
            this.gotItOnMyOrg = false;
            this.gotItOnExternalOrg = false;
            this.externalId = doctor.ExternalId__c;
        }
    }

    global class HM_DoctorsWrappersList {
        public List<HM_DoctorWrapper> doctorWrappers;

        global HM_DoctorsWrappersList() {
            doctorWrappers = new List<HM_DoctorWrapper>();
        }
    }

    global class HM_ResponseWrapper {
        public Boolean isSuccess { get; set; }
        public String message { get; set; }
        public List <HM_DoctorWrapper> doctorWrappers { get; set; }
    }

    global class HM_AccessTokenWrapper {
        public String access_token { get; set; }
    }

    class DoctorException extends Exception {
    }

    class BadAuthorizationException extends Exception {
    }
}