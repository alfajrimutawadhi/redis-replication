require "time"
require_relative "data"

class Storage
  def initialize
    @@data = Hash.new
  end

  public
    def set(key, value, t)
      @@data[key] = Data.new(value, t)
    end

    # adv is [EX seconds | PX milliseconds]
    def set_with_expired(key, value, adv, t)
      if adv == "EX"
        set(key, value, Time.now + t.to_i)
      else
        set(key, value, Time.now + (t.to_i/1000))
      end
    end

    def get(key)
      found = @@data.key?(key)
      if found
        if @@data[key].is_expired?
            @@data.delete(key)
            return nil, false
        end
        return @@data[key].get_value, true
      end
      return nil, false
    end

    def delete(keys)
      counter = 0
      keys.each do |key|
        _, ok = get(key)
        if ok
          @@data.delete(key)
          counter += 1
        end
      end
      counter
    end
end
