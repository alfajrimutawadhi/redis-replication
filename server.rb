require "socket"
require_relative "protocol/resp"

begin
  server = TCPServer.new(6379)
rescue => e
  puts e
  exit
end

puts "Start redis server\nLogs program will appear here!\n"

loop do
  Thread.start(server.accept) do |client|
    until client.eof?
      buf = client.readpartial(1024)
      resp = Resp.new(buf)
      resp.decode
      requests = resp.get_requests
      command = requests[0]
      case command.upcase
      when "PING"
        client.write "+PONG\r\n"
      else
        client.write "-ERR Unknown command '#{command}'\r\n"
      end
    end
    client.close
  end
end