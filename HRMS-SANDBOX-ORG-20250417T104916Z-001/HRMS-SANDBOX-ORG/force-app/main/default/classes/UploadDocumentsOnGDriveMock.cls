/**
* @description :UploadDocumentsOnGDriveMock is The mock class use in test class
* @author : Aakash Mathur - HRMS
* @Created date  : 5th Nov 2023
* @modified by: Aakash Mathur
* @modified date: 25 Nov 2023
*/
@isTest
global class UploadDocumentsOnGDriveMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse(); // Variable name need to more clear.
        req.setEndpoint('callout:GoogleDrive/drive/v3/files');
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        String reuestBody = '{"example":"test"}';
        Integer StatusCode =  200;
        Test.setMock(HttpCalloutMock.class, new HTTPCalloutServiceMock(StatusCode, reuestBody));
        return res;
    }
}