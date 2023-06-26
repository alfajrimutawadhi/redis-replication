require "socket"

require_relative "protocol/resp"
require_relative "protocol/request"
require_relative "protocol/response"

require_relative "storage/storage"

begin
  server = TCPServer.new(6379)
rescue => e
  puts e
  exit
end

puts "Start redis server\nLogs program will appear here!\n"
storage = Storage.new

loop do
  Thread.start(server.accept) do |client|
    until client.eof?
      buf = client.readpartial(1024)
      req = Request.new(buf)
      req.decode
      requests = req.get_requests

      command = requests[0]
      args = requests[1..]
      res = Response.new(client)
      count_args = args.length
      case command.upcase
      # ref: https://redis.io/commands/ping/
      when "PING"
        if count_args == 0
          res.pong
        elsif count_args == 1
          res.echo(args[0])
        else
          res.invalid_argument(command)
        end
      # ref: https://redis.io/commands/echo/
      when "ECHO"
        if count_args == 1
          res.echo(args[0])
        else
          res.invalid_argument(command)
        end
      # ref: https://redis.io/commands/set/
      when "SET"
        if count_args == 2
          storage.set(args[0], args[1])
          res.ok
        else
          res.invalid_argument(command)
        end
      # ref: https://redis.io/commands/get/
      when "GET"
        if count_args == 1
          data, ok = storage.get(args[0])
          if ok
            res.echo(data)
          else
            res.negative_string
          end
        else
          res.invalid_argument(command)
        end
      else
        res.unknown_command(command)
      end
    end
    client.close
  end
end