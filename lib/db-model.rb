require_relative 'db-connect'

module DBModel

  def self.included(base)
    base.extend DBModelClass
  end

  # def initialize(params)
  #   properties.each do |property|
  #     instance_variable_set "@#{property}", params[property.to_s]
  #   end
  # end

  def save
    data = instance_variables[1..-1]
      .map{ |var| extract_attribute_to_string(var) }.join(", ")
    DBConnect.access_database("update #{self.class.tablename} set #{data} where id = #{id};")
  end
private
  def extract_attribute_to_string attribute
    var = attribute.to_s[1..-1].to_sym
    value = method(var).call
    "#{var} = #{dbformat(value)}"
  end

  def dbformat(param)
    (param.is_a?(String)) ? "'#{param}'" : param.to_s
  end

end


module DBModelClass

  def create(params)
    separate_params(params) do |keys, data|
      DBConnect.access_database("insert into #{tablename}(#{keys}) values(#{data});")
    end
    self.find(params)
  end

  def find(params)
    DBConnect.access_database("select * from #{tablename} where #{query(params)};") do |result|
      self.new(result[0])
    end
  end

  def all
    DBConnect.access_database("select * from #{tablename};") do |result|
      result.map{ |record| self.new(record) }
    end
  end

  def delete(params)
    DBConnect.access_database("delete from #{tablename} where #{query(params)};")
  end

  def tablename
    self.to_s.downcase + "s"
  end

private
  def dbformat(param)
    (param.is_a?(String)) ? "'#{param}'" : param.to_s
  end

  def query params
    params.map{ |key, value| "#{key} = #{dbformat(value)}"}.join(" and ")
  end

  def separate_params(params)
    keys = params.map{ |key, value| key.to_s }.join(',')
    data = params.map{ |key, value| dbformat(value) }.join(',')
    yield(keys, data)
  end
end
