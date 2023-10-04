require 'socket'
require 'net/http'
require 'uri'
require 'json'

TCP_PORT = 2222
UDP_PORT = 3333
HOST = "localhost"

QUIZ_API_KEY = "q3hAvmCF4S7Qg4qykeHChrJZG04mkptP1eResV9s"
QUIZ_URL = URI.parse("https://quizapi.io/api/v1/questions?apiKey=#{QUIZ_API_KEY}&limit=5")

def handle_tcp_client(client)
  response = Net::HTTP.get_response(QUIZ_URL)
  quiz_data = JSON.parse(response.body)

  hits = 0
  quiz_data.each do |quiz|
    question = quiz['question']
    answers = quiz['answers']
    answers.delete_if { |_, value| value.nil? }
    correct_answers = quiz['correct_answers'].map do |key, value|
      { choice: "#{key.split('_')[1]}", value: value }
    end

    client.puts 'QUESTION:'
    client.puts question
    client.puts "\n"

    client.puts 'ANSWERS:'
    answers.each do |key, value|
      client.puts "#{key[-1]}: #{value}\n"
    end

    client.puts 'Digite sua resposta:'
    user_response = client.gets.strip

    if correct_answers.find { |row| row[:choice].to_s == user_response }[:value] == 'true'
      client.puts "----------------- Correct :D ---------------\n"
      hits += 1
    else
      client.puts "----------------- Wrong ;c -----------------\n"
    end
    client.puts "You have #{hits} hits!"
    client.puts "\n"

    break if user_response.downcase == 'exit'
  end
ensure
  client.close
end

def handle_udp_client(udp_socket, client_ip, client_port)
  response = Net::HTTP.get_response(QUIZ_URL)
  quiz_data = JSON.parse(response.body)
  quiz_size = 0

  hits = 0
  quiz_data.each do |quiz|
    question = quiz['question']
    answers = quiz['answers']
    answers.delete_if { |_, value| value.nil? }
    correct_answers = quiz['correct_answers'].map do |key, value|
      { choice: "#{key.split('_')[1]}", value: value }
    end

    udp_socket.send("QUESTION:\n#{question}\n\n", 0, client_ip, client_port)

    answers.each do |key, value|
      udp_socket.send("#{key[-1]}: #{value}\n", 0, client_ip, client_port)
    end

    udp_socket.send("Digite sua resposta:", 0, client_ip, client_port)
    user_response, _ = udp_socket.recvfrom(1024)
    res = user_response.strip

    if correct_answers.find { |row| row[:choice] == res }[:value] == 'true'
      udp_socket.send("----------------- Correct :D ---------------\n", 0, client_ip, client_port)
      hits += 1
    else
      udp_socket.send("----------------- Wrong ;c -----------------\n", 0, client_ip, client_port)
    end

    udp_socket.send("You have #{hits} hits!\n", 0, client_ip, client_port)
    quiz_size = quiz_size + 1
    udp_socket.send("\n", 0, client_ip, client_port)

    udp_socket.send("finally", 0, client_ip, client_port) if quiz_size == 5
    break if res.downcase == 'exit'
  end
end

tcp_server = TCPServer.open(TCP_PORT)
puts "Listening TCP connects on port :#{TCP_PORT}"

udp_socket = UDPSocket.new
udp_socket.bind(HOST, UDP_PORT)
puts "Listening UDP connects on port :#{UDP_PORT}"

puts "Waiting connections!"

tcp_thread = Thread.new do
  loop do
    client = tcp_server.accept
    Thread.new { handle_tcp_client(client) }
  end
end

udp_thread = Thread.new do
  loop do
    data, client_addr = udp_socket.recvfrom(1024)
    client_ip = client_addr[3]
    client_port = client_addr[1]
    Thread.new { handle_udp_client(udp_socket, client_ip, client_port) }
  end
end

tcp_thread.join
udp_thread.join
