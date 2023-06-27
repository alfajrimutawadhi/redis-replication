class Response < Resp
  def initialize(client)
    @@client = client
  end

  public
    def pong
      @@client.write("#{SIMPLE_STRINGS}PONG\r\n")
    end

    def ok
      @@client.write("#{SIMPLE_STRINGS}OK\r\n")
    end

    def echo(msg)
      @@client.write("#{BULK_STRINGS}#{msg.length}\r\n#{msg}\r\n")
    end

    def integer(num)
      @@client.write("#{INTEGERS}#{num}\r\n")
    end

    def nil
      @@client.write("#{BULK_STRINGS}-1\r\n")
    end

    def unknown_command(command)
      @@client.write("#{ERRORS}ERR Unknown command '#{command}'\r\n")
    end

    def invalid_argument(command)
        @@client.write("#{ERRORS}ERR wrong number of arguments for '#{command}' command\r\n")
    end
end
