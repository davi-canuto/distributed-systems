require 'socket'

HOST = 'localhost'
PORT = 3333

udp_socket = UDPSocket.new
udp_socket.connect(HOST, PORT)

puts "Enter 'quiz' to start quiz, and press 'exit' for exit quiz."

while true
  command = gets.chomp

  if command.downcase == 'exit'
    break
  end

  if command.downcase == 'quiz'
    puts 'chegou aq'
    udp_socket.send('quiz', 0)

    data, _ = udp_socket.recvfrom(1024)
    puts data

    # while true
    #   data, _ = udp_socket.recvfrom(1024)
    #   puts data

    #   if data.include?('Digite sua resposta:')
    #     response = gets.chomp

    #     udp_socket.send(response, 0)

    #     data, _ = udp_socket.recvfrom(1024)
    #     puts data
    #   end
    # end
  end
end

udp_socket.close





