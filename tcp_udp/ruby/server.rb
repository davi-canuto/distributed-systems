require 'socket'

require 'net/http'
require 'uri'
require 'json'

TCP_PORT = 2222
UDP_PORT = 3333
HOST = "localhost"

tcp_socket = TCPServer.open HOST, TCP_PORT
puts "Listening TCP connects in port :#{TCP_PORT}"

udp_socket = UDPSocket.new
udp_socket.bind(HOST, UDP_PORT)
puts "Listening UDP connects in port :#{UDP_PORT}"

puts "Waiting connections!"
QUIZ_API_KEY = "q3hAvmCF4S7Qg4qykeHChrJZG04mkptP1eResV9s"
QUIZ_URL = URI.parse("https://quizapi.io/api/v1/questions?apiKey=#{QUIZ_API_KEY}&limit=5")

# TCP
loop do
  client = tcp_socket.accept

  Thread.new do
    begin
      response = Net::HTTP.get_response(QUIZ_URL)
      quiz_data = JSON.parse(response.body)

      quiz_data.each do |quiz|
        question = quiz["question"]
        answers = quiz["answers"]
        answers.delete_if { |_, value| value.nil? }
        correct_answers = quiz["correct_answers"].map do |key, value|
          { choice: "#{key.split("_")[1]}", value: value }
        end

        client.puts "QUESTION:"
        client.puts question
        client.puts "\n"

        client.puts "ANSWERS:"
        answers.each do |key, value|
          client.puts "#{key[-1]}: #{value}\n"
        end

        client.puts "Digite sua resposta:"
        user_response = client.recvfrom( 10000 )
        res = user_response[0].to_s.strip

        if correct_answers.find { |row| row[:choice].to_s == res }[:value] == "true"
          client.puts "----------------- Correct :D ---------------"
        else
          client.puts "----------------- Wrong ;c -----------------"
        end

        if res.downcase == "exit"
          break
        end
      end
    ensure
      client.close
    end
  end
end

# UDP
loop do
  data, client_addr = udp_socket.recvfrom(1024)
  client_ip = client_addr[3]  # Obtém o IP do cliente

  response = Net::HTTP.get_response(QUIZ_URL)
  quiz_data = JSON.parse(response.body)

  quiz_data.each do |quiz|
    question = quiz["question"]
    answers = quiz["answers"]
    answers.delete_if { |_, value| value.nil? }
    correct_answers = quiz["correct_answers"].map do |key, value|
      { choice: "#{key.split("_")[1]}", value: value }
    end

    udp_socket.send("QUESTION:\n#{question}\n\n", 0, client_ip, UDP_PORT)

    answers.each do |key, value|
      udp_socket.send("#{key[-1]}: #{value}\n", 0, client_ip, UDP_PORT)
    end

    udp_socket.send("Digite sua resposta:", 0, client_ip, UDP_PORT)
    user_response, _ = udp_socket.recvfrom(1024)
    res = user_response.strip

    if correct_answers.find { |row| row[:choice] == res }[:value] == "true"
      udp_socket.send("----------------- Correct :D ---------------\n", 0, client_ip, UDP_PORT)
    else
      udp_socket.send("----------------- Wrong ;c -----------------\n", 0, client_ip, UDP_PORT)
    end

    if res.downcase == "exit"
      break
    end
  end
end
