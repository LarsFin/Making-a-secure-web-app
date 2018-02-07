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

end


module DBModelClass

  def create(params)
    separate_params(params) do |keys, data|
      access_database("insert into #{tablename}(#{keys}) values(#{data});")
    end
    self.new(params)
  end

  def find(params)
    query = params.map{ |key, value| "#{key} = #{dbformat(value)}"}.join(" and ")
    access_database("select * from #{tablename} where #{query};") do |result|
      self.new(result[0])
    end
  end

  private
  def tablename
    self.to_s.downcase + "s"
  end

  def separate_params(params)
    keys = params.map{ |key, value| key.to_s }.join(',')
    data = params.map{ |key, value| dbformat(value) }.join(',')
    yield(keys, data)
  end

  def dbformat(param)
    (param.is_a?(String)) ? "'#{param}'" : param.to_s
  end
end
