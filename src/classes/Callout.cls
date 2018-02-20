public class Callout {

    private Boolean disableResponseValidation;
    private String endpoint;
    private Map<String, String> headers;
    private Map<String, String> parameters;
    private HttpRequest request;

    public Callout(String namedCredential, String endpointPath) {
        this('callout:' + namedCredential + endpointPath);
    }

    public Callout(String endpoint) {
        this.endpoint = endpoint;

        this.headers    = new Map<String, String>();
        this.parameters = new Map<String, String>();
        this.request    = new HttpRequest();

        // Set some default values - these can be overridden
        this.disableResponseValidation = false;
        this.addHeader('Content-Type', 'application/json');
    }

    public Callout addHeader(String key, String value) {
        this.headers.put(key, value);
        return this;
    }

    public Callout addParameter(String key, String value) {
        this.parameters.put(key, value);
        return this;
    }

    public Callout setCompressed() {
        return this.setCompressed(true);
    }

    public Callout setCompressed(Boolean compress) {
        this.request.setCompressed(compress);
        return this;
    }

    public Callout setTimeout(Integer timeoutMs) {
        this.request.setTimeout(timeoutMs);
        return this;
    }

    public Callout disableResponseValidation(Boolean disableResponseValidation) {
        this.disableResponseValidation = disableResponseValidation;
        return this;
    }

    public HttpResponse del() {
        // 'DELETE' is a reserved word in Apex, so method name has been abbreviated
        return this.executeCallout('DELETE', null);
    }

    public HttpResponse get() {
        return this.executeCallout('GET', null);
    }

    public HttpResponse head() {
        return this.executeCallout('HEAD', null);
    }

    public HttpResponse patch(Object requestBody) {
        return this.executeCallout('PATCH', requestBody);
    }

    public HttpResponse post(Object requestBody) {
        return this.executeCallout('POST', requestBody);
    }

    public HttpResponse put(Object requestBody) {
        return this.executeCallout('PUT', requestBody);
    }

    public HttpResponse trace() {
        return this.executeCallout('TRACE', null);
    }

    private HttpResponse executeCallout(String httpVerb, Object requestBody) {
        // Set the method & request body
        this.request.setMethod(httpVerb);
        if(requestBody != null) this.request.setBody(JSON.serialize(requestBody));

        // Set the headers
        for(String headerKey : this.headers.keySet()) {
            this.request.setHeader(headerKey, this.headers.get(headerKey));
        }

        // Set the parameters & endpoint
        String parameterString = '';
        for(String parameterKey : this.parameters.keySet()) {
            String prefix = String.isEmpty(parameterString) && !this.endpoint.contains('?') ? '?' : '&';
            parameterString += prefix + parameterKey + '=' + this.parameters.get(parameterKey);
        }
        this.request.setEndpoint(this.endpoint + parameterString);

        // Return the response
        Http http = new Http();
        HttpResponse response = http.send(this.request);
        this.validateResponse(response);
        return response;
    }

    private void validateResponse(Httpresponse response) {
        // If validation is disabled, don't do anything
        if(this.disableResponseValidation) return;

        Integer statusCode = response.getStatusCode();
        if(statusCode >= 400 && statusCode <= 599) {
            throw new HttpResponseException('Received request status code ' + statusCode + ', status message: ' + response.getStatus());
        }
    }

    private class HttpResponseException extends Exception {}

}