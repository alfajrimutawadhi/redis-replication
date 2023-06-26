require "socket"
require_relative "protocol/resp"
require_relative "protocol/request"
require_relative "protocol/response"

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
      req = Request.new(buf)
      req.decode
      requests = req.get_requests
      command = requests[0]
      res = Response.new(client)
      case command.upcase
      when "PING"
        res.pong
      else
        res.unknown_command(command)
      end
    end
    client.close
  end
end