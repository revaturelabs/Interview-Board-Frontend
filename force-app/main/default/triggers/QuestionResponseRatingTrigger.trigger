trigger QuestionResponseRatingTrigger on Question_Response_Rating__c (before insert, before update, after delete) {
     if (Trigger.isDelete) {
		for (Question_Response_Rating__c rating : Trigger.old) {
            Id responseId = rating.Question_Response__c;
            Question_Response__c response = [SELECT Total_Votes__c, Upvotes__c FROM Question_Response__c
                                             WHERE Id =: responseId];
            response.Total_Votes__c--;
            if (rating.Rating__c == '1') {
                response.Upvotes__c--;
            }
            
            update response;
        }
     } else {
        for (Question_Response_Rating__c rating : Trigger.new) {
            Id responseId = rating.Question_Response__c;
            Question_Response__c response = [SELECT Total_Votes__c, Upvotes__c FROM Question_Response__c
                                             WHERE Id =: responseId];
            
            // Update the associated Question_Response__c total votes and number of upvotes fields
            // before the Question_Response_Rating__c is inserted into the database
            if (Trigger.isInsert) {
                response.Total_Votes__c++;
                if (rating.Rating__c == '1') {
                   response.Upvotes__c++;
                }
                
                update response;
            }
            
            // Update the associated response's total votes and number of upvotes
            if (Trigger.isUpdate) {
                if (rating.Rating__c == '-1') {
                    response.Upvotes__c -= 1;
                } else {
                    response.Upvotes__c += 1;
                }
                
                update response;
            }
        }
    }
}