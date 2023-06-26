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
end
