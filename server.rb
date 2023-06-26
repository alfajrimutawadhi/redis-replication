require "socket"

puts "Start redis server\nLogs program will appear here!\n"
server = TCPServer.new(6379)

loop do
  client = server.accept
  until client.eof?
    client.write "+PONG\r\n"
  end
  client.close
end

server.close