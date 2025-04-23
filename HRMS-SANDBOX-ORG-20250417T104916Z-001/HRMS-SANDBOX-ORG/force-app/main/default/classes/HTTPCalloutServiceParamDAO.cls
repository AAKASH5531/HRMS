/**
* Created :- 08/11/2023
* Description : this class  is used for API callout
* @author : Ankita Dhamgaya
* @modified date: 25th Nov 2023 
*/
public class HTTPCalloutServiceParamDAO {
	public String endpointURL;
    public String requestMethod;
    public String requestBody;
    public String requestCertificate;
    public Map<String, String> requestURLParameters;
    public Map<String, String> requestHeaderParameters;
    public Integer requestTimeout;
    
    public HTTPCalloutServiceParamDAO(String endpointURL, String requestMethod, String requestBody, 
                                  String requestCertificate, Map<String, String> requestURLParameters, Map<String, String> requestHeaderParameters, 
                                  Integer requestTimeout){
        this.endpointURL = endpointURL;
        this.requestMethod = requestMethod;
        this.requestBody = requestBody;
        this.requestCertificate = requestCertificate;
        this.requestURLParameters = requestURLParameters;
        this.requestHeaderParameters = requestHeaderParameters;
        this.requestTimeout = requestTimeout;
    }
}