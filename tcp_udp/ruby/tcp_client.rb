require 'socket'

HOST = 'localhost'
PORT = 2222

socket = TCPSocket.open(HOST, PORT)

puts "Enter 'quiz' to start quiz, and press 'exit' for exit quiz."

while line = socket.gets
   command = gets.chomp

   if command.downcase == "exit"
      break
   end
   if command.downcase == "quiz"
      puts line

      while true
         response = socket.gets.chomp
         puts response

         if response == "Digite sua resposta:"
            command = gets.chomp

            socket.close unless ["a","b","c","d","e","f"].include? command.to_s.strip

            socket.puts command
            socket_response = socket.recvfrom( 10000 )
            puts socket_response
         end
      end
   end
end

socket.close
