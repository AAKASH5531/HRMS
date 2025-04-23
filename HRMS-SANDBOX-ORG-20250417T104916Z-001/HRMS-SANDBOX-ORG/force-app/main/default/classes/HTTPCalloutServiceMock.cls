/**
* Created:- 08/11/2023
* Description:- This is the mock class used for single HTTP Callout during testing
* @author : Ankita Dhamgaya
* @modified date: 25th Nov 2023 
*/
@isTest
public class HTTPCalloutServiceMock implements HTTPCalloutMock {
    private HTTPResponse response;
    private Integer responseCode;
    private String responseBody;
    private String responseStatus;
    private Blob responseBodyAsBlob;
    private Map<String, String> responseHeaders;

    /*
    * Constructor
    */
    public HTTPCalloutServiceMock() {
        responseHeaders = new Map<String, String>();
    }

    /*
    * Constructor with response code and response body
    */
    public HTTPCalloutServiceMock(Integer responseCode, String responseBody) {
        responseHeaders = new Map<String, String>();
        this.responseCode = responseCode;
        this.responseBody = responseBody;
    }

    /*
    * Getters and Setters - Begin
    */
	public Integer getResponseCode() {
        responseCode = 204;
		return responseCode;
	}

	public void setResponseCode(Integer responseCode) {
		this.responseCode = responseCode;
	}

	public String getResponseBody() {
        responseBody = '{"name" : "Company_Docs","mimeType" : "application/vnd.google-apps.folder", "parents":["1gW7GxZayP__XltGU2Vzp6WZCYvLW5QRq"]';
		return responseBody;
	}

	public void setResponseBody(String responseBody) {
		this.responseBody = responseBody;
	}

    public Map<String, String> getResponseHeaders() {
        return responseHeaders;
    }

    public void setResponseHeader(String key, String value) {
        responseHeaders.put(key, value);
    }

	public String getResponseStatus() {
		return responseStatus;
	}

	public void setResponseStatus(String responseStatus) {
        
		this.responseStatus = responseStatus;
	}

	public Blob getResponseBodyAsBlob() {
		return responseBodyAsBlob;
	}

	public void setResponseBodyAsBlob(Blob responseBodyAsBlob) {
		this.responseBodyAsBlob = responseBodyAsBlob;
	}
    /*
    * Getters and Setters - End
    */

    /*
    * This method is used to generate and send the mock HTTP Response for the incoming request
    */
    public HTTPResponse respond(HTTPRequest request) {
        response = new HTTPResponse();
        if(responseCode!=null) {
            response.setStatusCode(responseCode);
        }
        if(responseStatus!=null) {
            response.setStatus(responseStatus);
        }
        if(responseBodyAsBlob!=null) {
            response.setBodyAsBlob(responseBodyAsBlob);
        } else {
            response.setBody(responseBody);
        }
        if(responseHeaders != null) {
            for(String headerKey : responseHeaders.keySet()) {
                response.setHeader(headerKey, responseHeaders.get(headerKey));
            }
        }
        return response;
    }
}