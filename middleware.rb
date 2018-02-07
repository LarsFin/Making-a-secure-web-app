require './app'

class Middleware

  attr_reader :parameters, :app

  def initialize(app_class)
    @app = app_class.new
    @parameters = Hash.new
  end

  def build_controller_name(request)
    method = request.get_method
    location = request.get_location.split("/").join("_")
    controller_name = "#{method}#{location}".downcase
    ex_method(controller_name, request)
  end

  private

  def clean()
    parameters = Hash.new
  end

  def ex_method(method, request)
    app.public_send(method, request) if app.respond_to?(method)
  end

end
