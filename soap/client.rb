require 'savon'

soap_client = Savon.client(wsdl: 'http://service.example.com/wsdl?wsdl')

soap_client.operations

response = soap_client.call(:find_user, message: { id: 42 })
response.body