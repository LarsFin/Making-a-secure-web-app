require_relative 'db-model'

class User
  include DBModel

  def initialize(params)
    @id = params[:id]
    @username = params[:username]
  
  end
end
