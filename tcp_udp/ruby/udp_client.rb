require 'socket'

HOST = 'localhost'
PORT = 3333

# Cria um socket UDP
udp_socket = UDPSocket.new

puts "Enter 'quiz' to start quiz, and 'exit' to exit the quiz."

while true
  command = gets.chomp

  if command.downcase == "exit"
    break
  end

  if command.downcase == "quiz"
    udp_socket.send("quiz", 0, HOST, PORT)

    while true
      data, _ = udp_socket.recvfrom(1024)
      puts data

      if data.include?("Digite sua resposta:")
        user_response = gets.chomp
        udp_socket.send(user_response, 0, HOST, PORT)

        response, _ = udp_socket.recvfrom(1024)
        puts response
      end
    end
  end
end

udp_socket.close
