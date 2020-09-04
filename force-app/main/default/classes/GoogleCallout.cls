public with sharing class GoogleCallout {
    
	public static Http http = new Http();
    public static HTTPResponse response;
    public static HttpRequest request;

   @AuraEnabled 
    public static void createEvent(String sum, DateTime startDate, DateTime endDate) {
        
        DateTime EndDateTime = DateTime.newInstance(2020, 9, 4, 21, 30, 00);
        DateTime StartDateTime = DateTime.newInstance(2020, 9, 4, 20, 25, 00);
        
 
        
        String Summary ='{"summary": "' + sum + '",';
        
        String endform = endDate.formatGMT('yyyy-MM-dd hh:mm:ss');
        String startform = startDate.formatGMT('yyyy-MM-dd hh:mm:ss');
        endform = endform.replace(' ', 'T');
        endform = endform.replace('.000Z', '');
        startform = startform.replace(' ', 'T');
        startform = startform.replace('.000Z', '');
        
        system.debug(sum);
        system.debug(endDate);
        system.debug(startDate);
        
        //system.debug(form);
        String forendDateTime ='"end": {"dateTime": "' + endform + '-12:00"},';
        String forstartDateTime = '"start": {"dateTime": "' + startform + '-12:00"},';
        //String attend = '"attendees": [{"email": "example@gmail.com"}],';
        String confData = '"conferenceData": {"createRequest": {"requestId": "7qxalsvy0e"}}}';
        
        request = new HttpRequest();
        request.setMethod('POST');
        request.setBody(Summary + forendDateTime + forstartDateTime + confData); 
        request.setEndpoint('callout:GoogleAPI/calendar/v3/calendars/salesforceibvc@gmail.com/events?conferenceDataVersion=1');
 
        response = http.send(request); 
 
        System.debug(response.getBody());
        Map<String, Object> results;
        results = ( Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String eID = results.get('id').toString();
        
        Map<String, Object> startDT = (Map<String, Object>) results.get('start'); 
        Map<String, Object> endDT = (Map<String, Object>) results.get('end');
        
		String endTime = endDT.get('dateTime').toString();
		String startTime = startDT.get('dateTime').toString();
       // system.debug(endTime);
        System.debug(eID);
        
        
        
        Meeting__c m = new Meeting__c();
        m.name = Summary;
        m.Google_Event_Id__c = eID;
        m.Meeting_Status__c = 'Scheduled';
        m.EndDateTime__c = EndDate;
        m.StartDateTime__c = startDate;
        
    
            insert m;
    
        
        
        
    }
    
    
	@AuraEnabled    
    public static String getEvent() {
        
       String eID = [SELECT Google_Event_Id__c FROM Meeting__c LIMIT 1].Google_Event_Id__c;
        system.debug(eID);
        request = new HTTPRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:GoogleAPI/calendar/v3/calendars/salesforceibvc@gmail.com/events/' + eID);
        response = http.send(request);
        
        system.debug(response.getBody());
        
        Map<String, Object> results;
        results = ( Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String eMeet = results.get('hangoutLink').toString();
        
        system.debug(eMeet);
        return eMeet;
    }
    
    @AuraEnabled
    public static void updateEvent(String editEID, String editSum, DateTime editStartDate, DateTime editEndDate) {
        
        String userInput;
        
        String editSummary ='{"summary": "' + editSum + '",';
        
        String editEndform = editEndDate.formatGMT('yyyy-MM-dd hh:mm:ss');
        String editStartform = editStartDate.formatGMT('yyyy-MM-dd hh:mm:ss');
        
        editEndform = editEndform.replace(' ', 'T');
        editEndform = editEndform.replace('.000Z', '');
        
        editStartform = editStartform.replace(' ', 'T');
        editStartform = editStartform.replace('.000Z', '');
        
        system.debug(editEID);
        system.debug(editSum);
        system.debug(editStartform);
        system.debug(editEndform);
        
        
        String editForEndDateTime ='"end": {"dateTime": "' + editEndform + '-12:00"},';
        String editForStartDateTime = '"start": {"dateTime": "' + editStartform + '-12:00"}}';
     
        
        
        
        request = new HTTPRequest();
        request.setMethod('PUT');
        request.setBody(editSummary + editForEndDateTime + editForStartDateTime);
        request.setEndpoint('callout:GoogleAPI/calendar/v3/calendars/salesforceibvc@gmail.com/events/' + editEID);
        response = HTTP.send(request);
        
        system.debug(response.getBody());

        
    }
}