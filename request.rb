class Request
  attr_reader :text_arr, :hash, :params

  def initialize text
    @text_arr = text.split("\r\n")
    @hash = Hash.new()
    @params = Hash.new()
    p 'end constructor'
  end

  def generate_hashes
    create_hash()
    create_params_hash() if get_method == 'POST'
  end

  def get_method()
    return hash()["method"]
  end

  def get_location()
    return hash()["location"]
  end

  def get_param(param)
    return params[param]
  end

  private

  def create_hash()
    hash()['method'], @hash['location'] = text_arr.shift().split(" ")
    text_arr().each do |item|
      key, value = item.split(":")
      if key && value
        hash()[key] = value.strip()
      else
        hash()["body"] = key
      end
    end
  end

  def create_params_hash()
    param_arr = hash()["body"].split("&")
    param_arr.each { |item|
      key, value = item.split("=")
      params[key] = value
    }
  end

end
