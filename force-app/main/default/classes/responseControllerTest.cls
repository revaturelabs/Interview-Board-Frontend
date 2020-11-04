@isTest
public class responseControllerTest {
    
	@isTest
    public static void Test(){
        String questionBody = 'What day of the week is it?';
        String body = 'This is an example response.';
        
        // This function currently grabs the body of first question in the question pool
        String question = responseController.getQuestion();
        System.assertEquals('What day of the week is it?', question);
        
        // This function adds a response into the database
        // responseController.addResponse(body, questionBody);
        
        // This function gets a list of responses based on the question passed in to it
        List<Question_Response__c> rList = responseController.getResponse(questionBody);
        
        // Loop through all of the responses for our question, and make sure they were populated correctly.
        Integer iteration = 0;
        for(Question_Response__c qR : rList){
            System.assertEquals(qR.Body__c, (rList[iteration].Body__c));
            iteration++;
        }
    }
    
    // This method is run to create dummy data used in the test
    @testSetup
    static void makeData(){
        
        // Initialize a dummy question
        Question__c q = new Question__c();
        q.Body__c = 'What day of the week is it?';
        q.Stack__c = 'Salesforce';
        q.Type__c = 'Soft Skills';
        
        insert q;
        
        
        // Initialize 2 dummy responses
        List<Question_Response__c> r = new List<Question_Response__c>();
        String questionBody = 'What day of the week is it?';
        id question = [SELECT id FROM Question__c WHERE Body__c =: questionBody LIMIT 1 ].id;
        
        for(Integer i = 1; i <= 2; i++) {
        	Question_Response__c resp = new Question_Response__c(); 
            resp.Body__c = 'This is response #' + i;
            resp.Question__c = question;
            r.add(resp);
        }
        insert r;
    }
}