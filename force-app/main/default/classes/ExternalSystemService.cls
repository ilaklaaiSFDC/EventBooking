public  class ExternalSystemService {

    private String webServiceURL;

    public ExternalSystemService(){
        this.webServiceURL = 'https://th-apex-http-callout.herokuapp.com/animals';
    }
    @future (callout=true) // using @future to make a callout to the external service
    public void registerAttendees(List<Id> accountIDs){
        List<Contact> attendees = [SELECT id,name, email FROM Contact WHERE AccountId in :accountIDs];
        List<Contact> contactsToMail = new List<Contact>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(this.webServiceURL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        // request.setBody('{"name":"'+ c.name + '-' + c.email  +'}'); 
        HttpResponse response = http.send(request);

        for(Contact c : attendees){
            request.setBody('{name:'+ c.name + '-' + c.email  +'}'); 
            response = http.send(request);
            // Parse the JSON response
            if (response.getStatusCode() != 201) {
                System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
            } else {
            // Everything went as expected.
                contactsToMail.add(c);
                
            }

        }
        notifyAttendeesByEmail(contactsToMail); // adding all the contacts as opposed to "c"
        
    } 

    public void notifyAttendeeByEmail(List<Contact> contacts){ // list of contacts
      
        Task tk = new Task();
        tk.Subject = 'Send Email To' + account.name;
        tk.Status = 'Open';
        tk.Priority = 'Normal';
        tk.WhatId = account.ID;
        insert tk;
    } 


}
