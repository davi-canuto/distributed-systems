require 'savon'

soap_client = Savon.client(wsdl: 'http://service.example.com/wsdl?wsdl')

# list operations
soap_client.operations

response = client.call(:find_user, message: { id: 42 })

response.body