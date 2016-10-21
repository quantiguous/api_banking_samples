# Samples

Samples in various languages to connect to banks that provide public API's


## Yes Bank

1. You should be a customer, and should have signed up for API Banking.
1. You should have received a user-id & password
1. You should have registered on the API portal, and obtained a client key & secret
1. You should have whitelisted the ip-address from where you'll initiate the requests
1. You should have shared your public key for registration with the bank's security team 

### FundsTransferByCustomerService

1. You should have subscribed to this service in the API Portal

#### Ruby

1. The public key for Yes Bank (production) is present in the repository, in ybl/ybl.env
1. The sample code executes getStatus, so it is safe to use against a production environment (no funds will debit from your account)
1. The code uses liquid to put dynamic data in the request template
1. The code uses faraday to the http call

To execute
```
gem install liquid
gem install faraday
irb get_status.rb
```


    
    

     
     
     
