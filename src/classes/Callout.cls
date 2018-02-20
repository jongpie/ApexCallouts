public class Callout {

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

        // Set JSON as the default content-type - it can be overridden
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

    public HttpResponse patch(String requestBody) {
        return this.executeCallout('PATCH', requestBody);
    }

    public HttpResponse post(String requestBody) {
        return this.executeCallout('POST', requestBody);
    }

    public HttpResponse put(String requestBody) {
        return this.executeCallout('PUT', requestBody);
    }

    public HttpResponse trace() {
        return this.executeCallout('TRACE', null);
    }

    private HttpResponse executeCallout(String httpVerb, String requestBody) {
        // Set the method & request body
        this.request.setMethod(httpVerb);
        if(requestBody != null) this.request.setBody(requestBody);

        // Set the headers
        for(String headerKey : this.headers.keySet()) {
            this.request.setHeader(headerKey, this.headers.get(headerKey));
        }

        // Set the parameters & endpoint
        String parameterString = '';
        for(String parameterKey : this.parameters.keySet()) {
            String prefix = String.isEmpty(parameterString) ? '?' : '&';
            parameterString += prefix + parameterKey + '=' + this.parameters.get(parameterKey);
        }
        this.request.setEndpoint(this.endpoint + parameterString);

        // Return the response
        Http http = new Http();
        HttpResponse response = http.send(this.request);
        return response;
    }

}