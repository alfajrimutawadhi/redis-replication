class Response < Resp
  def initialize(client)
    @@client = client
  end

  public
    def pong
        @@client.write("#{SIMPLE_STRINGS}PONG\r\n")
    end

    def negative
        @@client.write("#{BULK_STRINGS}-1\r\n")
    end

    def unknown_command(command)
        @@client.write("#{ERRORS}ERR Unknown command '#{command}'\r\n")
    end

end
