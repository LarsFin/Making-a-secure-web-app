require_relative 'db-connect'

module DBModel

  def self.create(params)
    tablename = self.to_s.downcase + "s"
    keys = params.map{ |key, value| key.to_s }.join(',')
    data = params.map{ |key, value| dbformat(value) }.join(',')
    access_database("insert into #{tablename}(#{keys}) values(#{data});")
    self.new(params)
  end

  private
  def dbformat(param)
    param.is_a? String ? "'#{param}'" : param.to_s
  end

end
