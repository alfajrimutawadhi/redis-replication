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
          storage.set(args[0], args[1], nil)
          res.ok
        elsif count_args == 3
          type = args[2].upcase
          if storage.type_data_set_is_valid?(type)
            ok = storage.set_nx_xx(args[0], args[1], type)
            ok ? res.ok : res.nil
          else
            res.syntax_error
          end
        elsif count_args == 4
          adv = args[2].upcase
          if storage.adv_expired_time_is_valid?(adv) && !!/\A\d+\z/.match(args[3])  # check is number
            storage.set_with_expired(args[0], args[1], adv, args[3])
            res.ok
          else
            res.syntax_error
          end
        elsif count_args == 5
          type = args[2].upcase
          adv = args[3].upcase
          if storage.type_data_set_is_valid?(type) && storage.adv_expired_time_is_valid?(adv) && !!/\A\d+\z/.match(args[4])
            ok = storage.set_nx_xx_with_expired(args[0], args[1], type, adv, args[4])
            ok ? res.ok : res.nil
          else
            res.syntax_error
          end
        else
          res.invalid_argument(command)
        end
      # ref: https://redis.io/commands/get/
      when "GET"
        if count_args == 1
          data, ok = storage.get(args[0])
          ok ? res.echo(data) : res.nil
        else
          res.invalid_argument(command)
        end
      # ref: https://redis.io/commands/del/
      when "DEL"
        if count_args > 0
          res.integer(storage.delete(args))
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