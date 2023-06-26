class Storage
  def initialize
    @@data = Hash.new
  end

  public
    def set(key, value)
      @@data[key] = value
    end

    def get(key)
      return @@data[key], @@data.key?(key)
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
