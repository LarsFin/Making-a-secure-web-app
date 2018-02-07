require_relative 'db-model'

class User
  include DBModel
  attr_reader :id
  attr_accessor :username
  def initialize(params)
    @id = params[:id]
    @username = params[:username]
  end
  
end
