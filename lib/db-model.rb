require_relative 'db-connect'

module DBModel

  def self.included(base)
    # base.include DBConnect
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

  def extract_attribute_to_string attribute
    var = attribute.to_s[1..-1].to_sym
    value = method(var).call
    "#{var} = #{self.class.dbformat(value)}"
  end

end


module DBModelClass
  # extend DBConnect

  def create(params)
    separate_params(params) do |keys, data|
      DBConnect.access_database("insert into #{tablename}(#{keys}) values(#{data});")
    end
    self.find(params)
  end

  def find(params)
    query = params.map{ |key, value| "#{key} = #{dbformat(value)}"}.join(" and ")
    DBConnect.access_database("select * from #{tablename} where #{query};") do |result|
      self.new(result[0])
    end
  end

  def all
    DBConnect.access_database("select * from testdbmodels;") do |result|
      result.map{ |record| self.new(record) }
    end
  end

  # private
  def tablename
    self.to_s.downcase + "s"
  end

  def dbformat(param)
    (param.is_a?(String)) ? "'#{param}'" : param.to_s
  end

  def separate_params(params)
    keys = params.map{ |key, value| key.to_s }.join(',')
    data = params.map{ |key, value| dbformat(value) }.join(',')
    yield(keys, data)
  end
end
