class Request
  attr_reader :text_arr, :hash

  def initialize text
    p text
    @text_arr = text.split("\r\n")
    @hash = Hash.new()
    create_hash()
  end

  def get_method()
    return hash()["method"]
  end

  def get_location()
    return hash()["location"]
  end
  private

  def create_hash()
    hash()['method'], @hash['location'] = text_arr.shift().split(" ")
    text_arr().each do |item|
      key, value = item.split(":")
      if !key.nil? && !value.nil?
        hash()[key] = value.strip()
      else
        hash()["body"] = key
      end
    end
  end
end
