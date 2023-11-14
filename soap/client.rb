require 'savon'

wsdl_url = 'http://127.0.0.1:8000/tarot?wsdl'

client = Savon.client(
  wsdl: wsdl_url,
  endpoint: 'http://127.0.0.1:8000/tarot',
  namespaces: { 'xmlns:tns' => 'http://example.com/simple-service' },
  pretty_print_xml: true
)

puts "Operações disponíveis: #{client.operations}"
puts client.call(:get_hello_string)