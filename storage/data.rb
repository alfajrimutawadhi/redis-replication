require "time"

class Data
  def initialize(value, expired)
    @@value = value
    @@expired = expired
  end

  public
    def get_value
      @@value
    end

    def is_expired?
      if @@expired.nil?
        return false
      end
      @@expired < Time.now
    end
end
