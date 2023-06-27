require "time"
require_relative "data"

class Storage
  def initialize
    @@data = Hash.new
  end

  TYPE_DATA_SET = ["NX", "XX"]
  ADV_EXPIRED_TIME = ["EX", "PX"]

  public
    def type_data_set_is_valid?(type)
      TYPE_DATA_SET.include?(type)
    end

    def adv_expired_time_is_valid?(adv)
      ADV_EXPIRED_TIME.include?(adv)
    end

    def set(key, value, t)
      @@data[key] = Data.new(value, t)
    end

    # type is [NX | XX]
    def set_nx_xx(key, value, type)
      _, found = get(key)
      if type == "NX" && !found
        set(key, value, nil)
        return true
      elsif type == "XX" && found
        set(key, value, nil)
        return true
      end
      return false
    end

    # adv is [EX seconds | PX milliseconds]
    def set_with_expired(key, value, adv, t)
      if adv == "EX"
        set(key, value, Time.now + t.to_i)
      else
        set(key, value, Time.now + (t.to_i/1000))
      end
    end

    def set_nx_xx_with_expired(key, value, type, adv, t)
        exp = 0
        if adv == "EX"
          exp = Time.now + t.to_i
        else
          exp = Time.now + (t.to_i/1000)
        end

        _, found = get(key)
        if type == "NX" && !found
          set(key, value, exp)
          return true
        elsif type == "XX" && found
          set(key, value, exp)
          return true
        end
        return false
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
