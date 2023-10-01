require 'socket'

UDP_PORT = 3333

server_ip = 'localhost'

udp_socket = UDPSocket.new

message = 'Olá, servidor UDP!'

udp_socket.send(message, 0, server_ip, UDP_PORT)

udp_socket.close
