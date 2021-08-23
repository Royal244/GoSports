global class HM_RestMultiMock implements HttpCalloutMock {

    private Map<String, HttpCalloutMock> requests;

    global HM_RestMultiMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    global HttpResponse respond(HttpRequest request) {

        System.debug('endpoint: ' + request.getEndpoint());
        HttpCalloutMock mock = requests.get(request.getEndpoint().substringBefore('?'));
        System.debug('DS mock: ' + mock);
        System.debug('DS requests: ' + requests);
        System.debug('DS request.getEndpoint(): ' + request.getEndpoint());
        System.debug('DS request.getEndpoint().substringBe: ' + request.getEndpoint().substringBefore('?'));
        if (mock != null) {
            return mock.respond(request);
        } else {
            return null;
        }
    }
}