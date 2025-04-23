/**
* Created : 08/11/2023
* Description : his class is used for HTTP Callout Service
* @author : Ankita Dhamgaya
* @modified date: 25th Nov 2023 
*/
public class HTTPCalloutService {
    String endpointURL, requestMethod, requestBody, requestCertificate;
    Blob requestBodyAsBlob;
    Dom.Document requestBodyAsDocument;
    Integer requestTimeout;
    Boolean isCompressedRequest;
    Map<String, String> urlParametersMap =  new Map<String, String>();
    Map<String, String> headerParametersMap = new Map<String, String>();
    static final String TYPE_URL_PARAMETERS = 'URL_PARAMETERS';
    static final String TYPE_HEADER_PARAMETERS = 'HEADER_PARAMETERS';
    HTTPRequest request;

    /*
    * Getters and Setters - Begin
    */
	public String getEndpointURL() {
		return endpointURL;
	}

	public void setEndpointURL(String endpointURL) {
		this.endpointURL = endpointURL;
	}

	public String getRequestMethod() {
		return requestMethod;
	}

	public void setRequestMethod(String requestMethod) {
		this.requestMethod = requestMethod;
	}

	public String getRequestBody() {
		return requestBody;
	}

	public void setRequestBody(String requestBody) {
		this.requestBody = requestBody;
	}

	public Blob getRequestBodyAsBlob() {
		return requestBodyAsBlob;
	}

	public void setRequestBodyAsBlob(Blob requestBodyAsBlob) {
		this.requestBodyAsBlob = requestBodyAsBlob;
	}

	public Dom.Document getRequestBodyAsDocument() {
		return requestBodyAsDocument;
	}

	public void setRequestBodyAsDocument(Dom.Document requestBodyAsDocument) {
		this.requestBodyAsDocument = requestBodyAsDocument;
	}

	public String getRequestCertificate() {
		return requestCertificate;
	}

	public void setRequestCertificate(String requestCertificate) {
		this.requestCertificate = requestCertificate;
	}

	public Integer getRequestTimeout() {
		return requestTimeout;
	}

	public void setRequestTimeout(Integer requestTimeout) {
		this.requestTimeout = requestTimeout;
	}

	public Boolean getIsCompressedRequest() {
		return isCompressedRequest;
	}

	public void setIsCompressedRequest(Boolean isCompressedRequest) {
		this.isCompressedRequest = isCompressedRequest;
	}

    public String getHeaderParameter(String key) {
        return headerParametersMap.get(key);
    }

    public Map<String, String> getHeaderParameters() {
        return headerParametersMap;
    }

    public void setHeaderParameter(String key, String value) {
        if(String.isNotEmpty(key) && String.isNotEmpty(value)) {
            headerParametersMap.put(key, value);
        }
    }

    public void removeHeaderParameter(String key) {
        headerParametersMap.remove(key);
    }

    public String getURLParameter(String key) {
        return urlParametersMap.get(key);
    }

    public Map<String, String> getURLParameters() {
        return urlParametersMap;
    }

    public void setURLParameter(String key, String value) {
        if(String.isNotEmpty(key) && String.isNotEmpty(value)) {
            urlParametersMap.put(key, value);
        } else if(String.isNotEmpty(key)) {
            urlParametersMap.put(key, value);
        }
    }

    public void removeURLParameter(String key) {
        urlParametersMap.remove(key);
    }
    
    /*
    * Constructor
    */
    public HTTPCalloutService() {
    }

    /*
    * Constructor with Custom Metadata
    */
    public HTTPCalloutService(HTTPCalloutServiceParamDAO calloutRequest) 
    { 
        initialize(calloutRequest);
    }

    /*
    * Initialization of class variables
    */
    private void initialize(HTTPCalloutServiceParamDAO calloutRequest) {
        if(calloutRequest != null) {  
            endpointURL = calloutRequest.endpointURL;
            requestMethod = calloutRequest.requestMethod;
            requestBody = calloutRequest.requestBody;
            requestTimeout = Integer.valueOf(calloutRequest.requestTimeout);
            headerParametersMap = calloutRequest.requestHeaderParameters;
            urlParametersMap = calloutRequest.requestURLParameters;
        }
    }

    /*
    * This method is used to set URL or Header parameters from Custom Metadata
    */
    private void setUrlOrHeaderParameters(String parameterType, String parameterInfo) {
        if(String.isNotEmpty(parameterInfo)) {
            if(parameterType == TYPE_URL_PARAMETERS) {
            } else if(parameterType == TYPE_HEADER_PARAMETERS) {
               
            }
        }
    }

    /*
    * This method is used to append the URL parameters at the end of URL
    */
    private void appendURLParameters() {
        Set<String> urlParamKeys = urlParametersMap?.keySet();
        if(urlParamKeys != null && urlParamKeys.isEmpty()) {
            endpointURL += '?';
            for(String urlParamKey : urlParamKeys) {
                endpointURL += urlParamKey + '=' + urlParametersMap.get(urlParamKey) + '&';
            }
            endpointURL = endpointURL.substringBeforeLast('&');
        }
    }

    /*
    * This method is used to set Header parameters using headerParametersMap
    */
    private void addHeaderParameters() {
        for(String key : headerParametersMap.keySet()) {
            request.setHeader(key, headerParametersMap.get(key));
        }
    }

    /*
    * This method is used to form HTTP Request
    */
    public void formHTTPRequest() {
        request = new HTTPRequest();
        addHeaderParameters();
        if(String.isNotEmpty(endpointURL)) {
            endpointURL = endpointURL.substringBefore('?');
            appendURLParameters();
            request.setEndpoint(endpointURL);
        }
        if(String.isNotEmpty(requestMethod)) {
            request.setMethod(requestMethod);
        }
        if(String.isNotEmpty(requestBody)) {
            request.setBody(requestBody);
        } else if((requestBodyAsBlob != null) &&  String.isNotEmpty(requestBodyAsBlob.toString())) {
            request.setBodyAsBlob(requestBodyAsBlob);
        } else if((requestBodyAsDocument != null) && String.isNotEmpty(requestBodyAsDocument.toXmlString())) {
            request.setBodyDocument(requestBodyAsDocument);
        }
        if(requestTimeout!=null) {
            request.setTimeout(requestTimeout);
        }
        if(String.isNotEmpty(requestCertificate)) {
            request.setClientCertificateName(requestCertificate);
        }
        if(isCompressedRequest!=null) {
            request.setCompressed(isCompressedRequest);
        }
    }

    /*
    * This method forms and returns the HTTP Request without sending (for debugging purposes)
    */
    public HTTPRequest getRequest() {
        formHTTPRequest();
        return request;
    }

    /*
    * This method is used to send HTTP Request and return the response
    */
    public HTTPResponse sendRequest() {
        formHTTPRequest();
        Http http = new Http();
        return http.send(request);
    }

    /*
    * This method is used to send HTTP Request received in parameter and return the response
    */
    public HTTPResponse sendRequest(HTTPRequest request) {
        Http http = new Http();
        return http.send(request);
    }
}