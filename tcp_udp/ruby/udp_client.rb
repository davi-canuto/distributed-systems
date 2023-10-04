require 'socket'

HOST = 'localhost'
PORT = 3333

udp_socket = UDPSocket.new

puts "Enter 'quiz' to start quiz, and press 'exit' to exit the quiz."

loop do
  command = gets.chomp

  if command.downcase == 'exit'
    udp_socket.send('exit', 0, HOST, PORT) # Envia um comando 'exit' para encerrar o servidor UDP
    udp_socket.close
    break
  end

  if command.downcase == 'quiz'
    udp_socket.send('quiz', 0, HOST, PORT)

    while true
      data, _ = udp_socket.recvfrom(1024)
      puts data

      if data.include?('Digite sua resposta:')
        response = gets.chomp

        udp_socket.send(response, 0, HOST, PORT)
      end

      if data.include?('finally')
        udp_socket.close
        break
      end
    end
  end
end

udp_socket.close
