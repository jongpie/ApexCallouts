# Apex Callouts
A lightweight Apex library for making HTTP callouts <br />
<a href="https://githubsfdeploy.herokuapp.com" target="_blank">
    <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Using Callout Constructors
- **Callout(String endpoint)** - used when you have a full URL for the endpoint and you are using [remote site settings](https://help.salesforce.com/articleView?id=configuring_remoteproxy.htm&type=5)
- **Callout(String namedCredential, String endpointPath)** - used with [named credentials](https://help.salesforce.com/articleView?id=named_credentials_about.htm&type=5). To use this, the named credential's endpoint should be just the base URL of the API. The specific endpoint resource to call is then provided via the endpointPath parameter.

## Building Your Callout Request
Once you have instantiated an instance of Callout, you can setup additional options for the callout, like adding headers & parameters. Each builder method returns the current instance of Callout, allowing you to chain the builder methods.
* Callout addHeader(String key, String value)
* Callout addHeaders(Map<String, String> headers)
* Callout addParameter(String key, String value)
* Callout addParameters(Map<String, String> parameters)
* Callout setCompressed()
* Callout setCompressed(Boolean compress)
* Callout setTimeout(Integer timeoutMs)

## Making Your Callout Request
Once you have instantiated an instance of Callout and setup the headers & parameters (if needed), you can call any of the HTTP verb methods - each method returns an instance of HttpResponse.
* HttpResponse del() - 'delete' is a reserved word in Apex, so the method name has been abbreviated
* HttpResponse get()
* HttpResponse head()
* HttpResponse patch(Object requestBody)
* HttpResponse post(Object requestBody)
* HttpResponse put(Object requestBody)
* HttpResponse trace()

## PATCH, POST & PUT methods
Patch, post & put methods accept an Object as a parameter, with 3 main types supported
* **Blob**:  Callout automatically uses setBodyAsBlob(yourBlob)
* **Dom.Document**:  Callout automatically uses setBodyDocument(yourDocument)
* **Serializable Object**: Any other object types will be serialized and sent as JSON

For all 3 scenarios, the header 'Content-Type' is automatically set based on the request body if the header has not already been set

## Error Handling
When the callout is made, any status code >= 400 automatically throws an instance of Callout.HttpResponseException exception

## Example Usage
GET request with headers & parameters, using chained method calls & named credentials
```
HttpResponse myCalloutResponse = new Callout('myExampleNamedCredential', '/fakeResource')
    .addHeader('myHeader', 'myHeaderValue')
    .addParameter('myFirstParameter', 'someValue')
    .addParameter('mySecondParameter', 'anotherVomeValue')
    .get();
```

GET request with headers & parameters, using chained method calls & a full URL (remote site settings)
```
HttpResponse myCalloutResponse = new Callout('https://api.example.com/fakeResource')
    .addHeader('myHeader', 'myHeaderValue')
    .addParameter('myFirstParameter', 'someValue')
    .addParameter('mySecondParameter', 'anotherVomeValue')
    .get();
```