require 'savon'

wsdl_url = 'http://127.0.0.1:8000/tarot?wsdl'

client = Savon.client(
  wsdl: wsdl_url,
  endpoint: 'http://127.0.0.1:8000/tarot',
  pretty_print_xml: true
)

response = client.call(:say_hello, message: { firstName: 'davi' })

puts response.body