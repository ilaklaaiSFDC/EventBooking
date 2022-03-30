public with sharing class CaseTriggerHelper{
    public static void checkReservation(List<Case> cases){

        List<ID> accountsIDs = new List<ID>();
        for(Case c : cases){
            accountsIDs.add(c.AccountId);
        }
        // querying the database outside the for loop
        Map<ID, Account> accountsMap = new Map<ID, Account>([SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account WHERE Id IN : accountsId]);

        for (Case c : cases){
            if(c.AccountId != null){ // c cannot be null so we don't need to test on it
                Account account = accountsMap.get(c.AccountId); // account cannot be null because we JUST tested on it
                Integer contactSize = account.Contacts.size();
                if (constactSize == 0){
                    c.addError('You cannot create a request for accounts without contacts');
                }
                else if (c.Origin == 'Web' && contactSize >= 2){
                        c.addError('Web request are only allowed to have one attendee');
                    }
                else if (c.Origin == 'Phone' && contactSize >= 4){
                    c.addError('Phone request are only allowed to have three attendee');
                }
                }
                else c.addError('You cannot create a request without attaching an account');
            }
        }

    public static notifyForReservation(List <Case> updatedCases, Map<Id, Case> oldCasesMap){
        List<Id> accountsIDs = new List<Id>();
        for(Case updatedCase : updatedCases){
            Case oldCaseId = oldCasesMap.get(updatedCase.Id);
            if (oldCaseId.Status != 'Closed' && updatedCase.Status == 'Closed'){
                accountsIDs.add(updatedCase.accountId);
            }
        }
        if(accountIDs.size() > 0)
            ExternalSystemService.registerAttendees(accountIDs);
    }
    }

