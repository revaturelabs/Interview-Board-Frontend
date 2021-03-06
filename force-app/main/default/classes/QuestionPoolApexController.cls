public with sharing class QuestionPoolApexController {
        @AuraEnabled
        public static List<Question__c> getQuestionPool(){
            List<Question__c> allQuestions = new List<Question__c>();
            
            for (Question__c q : [SELECT Type__c, Stack__c, Body__c FROM Question__c]) {
                allQuestions.add(q);
                
            }
            return allQuestions;
            
        }
    
    	@AuraEnabled
    public static void deleteQuestions(Id[] idList){
        Question__c[] questionList = [SELECT Id FROM Question__c WHERE Id IN :idList];
        delete questionList;
    }
        

}