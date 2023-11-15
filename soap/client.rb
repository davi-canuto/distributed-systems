require 'savon'

wsdl_url = 'http://127.0.0.1:8000/tarot?wsdl'

client = Savon.client(
  wsdl: wsdl_url,
  endpoint: 'http://127.0.0.1:8000/tarot',
  pretty_print_xml: true
)

puts 'You wanna tarot card for when?:'
puts '1) past'
puts '2) present'
puts '3) future'
puts '4) all'

print 'Enter option number: '
@choice = gets.chomp.to_i

@response = nil

case(@choice)
  when 1
    @response = client.call(:shuffle_and_deliver_cards, message: { past: true, present: false, future: false, all: false })
  when 2
    @response = client.call(:shuffle_and_deliver_cards, message: { past: false, present: true, future: false, all: false })
  when 3
    @response = client.call(:shuffle_and_deliver_cards, message: { past: false, present: false, future: true, all: false })
  when 4
    @response = client.call(:shuffle_and_deliver_cards, message: { past: false, present: false, future: false, all: true })
  else puts 'enter valid option'
end

if @response
  real_res = @response.body[:shuffle_and_deliver_cards_response][:greeting]
  if real_res.include?(",")
    arr_of_cards = real_res.split(",")

    puts "Card for represent your past is: #{arr_of_cards[0]}"
    puts "Card for represent your present is: #{arr_of_cards[1]}"
    puts "Card for represent your future is: #{arr_of_cards[2]}"
  else
    puts real_res
  end
end