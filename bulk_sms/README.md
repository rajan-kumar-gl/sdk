# Bulk SMS GEM
- This gem can be used for sending message, using third party client like `MSG91`, etc
- 
#### Avaliable Clients
```ruby
BulkSMS::Clients::MSG91 
```
## Steps - How to work with this
### 1. Get Upstream Client
- In this method You need to pass cilent name and parameter. if rquired parameter not provided then it will throw an error. eg 
```ruby
BulkSMS::Adapter.connect( ClientName = String, options = {}) 
```
Here's the sample code for `MSG91` client
```ruby
client = BulkSMS::Adapter.connect (BulkSMS::Clients::MSG91,{'sender_id':"XXXXX",'access_token':"XXXXXXX","flow_id":"XXXXXX"})
```
### Send Message
- After step one now, you have to call one more method send_in_bulk wih the user info
```ruby 
client.send_in_bulk(ComonMSG = String ,user_info=ArrayOfObject, OtherOptions = Object)
```
Here's the sample code for the same
```ruby
client.send_in_bulk("",[{'name':'rajan kumar', 'mobile':'9540XX2XX2'}], {})
```
Author - `Rajan Kumar`
if you have any query or suggestion drop a mail to `dev@greatlearning.in`
