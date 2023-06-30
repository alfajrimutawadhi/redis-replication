class Request < Resp
  def initialize(buf)
    @@buf = buf
    @@requests = []
  end

  public
    def decode
      prefix =  @@buf[0]
      @@buf = @@buf[1..]
      case prefix
      when ARRAYS
          decode_array
      when BULK_STRINGS
          decode_bulk_strings
      end
    end

    def get_requests
      @@requests
    end

  private
    def decode_array
      num = get_number
      for _ in 1..num
        req = decode
        @@requests.append(req)
      end
    end

    def decode_bulk_strings
      num = get_number
      if num == 0
        return ""
      end
      s = @@buf[..num-1]
      # remove '\r\n'
      @@buf = @@buf[num+2..]
      s
    end

    def get_number
      number = ""
      total_slice = 0
      @@buf.split("").each do |b|
          if b == "\r"
              break
          end
          number += b
          total_slice += 1
      end
      # remove '\r\n'
      @@buf = @@buf[total_slice+2..]
      number.to_i
    end
end
