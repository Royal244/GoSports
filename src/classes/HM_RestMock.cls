@IsTest
global with sharing class HM_RestMock implements HttpCalloutMock{
    private Integer statusCode;
    private String status;
    private String body;
    private Map<String, String> header;

    global HM_RestMock(Integer statusCode, String status, String body, Map<String, String> header){
        this.statusCode = statusCode;
        this.status = status;
        this.body = body;
        this.header = header;
    }

    global HttpResponse respond (HttpRequest request){
        HttpResponse response = new HttpResponse();
        if (header != null) {
            for (String key : header.keySet()) {
                response.setHeader(key, header.get(key));
            }
        }
        if (String.isNotBlank(body)) {
            response.setBody(body);
        }
        response.setStatusCode(statusCode);
        response.setStatus(status);
        return response;
    }
}