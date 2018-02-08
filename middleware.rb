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
    location = "_homepage" if location.empty?
    controller_name =  "#{method}#{location}".downcase
    ex_method(controller_name, request)
  end

  private

  def clean()
    parameters = Hash.new
  end

  def ex_method(method, request)
    if app.respond_to?(method) 
      app.public_send(method, request)
    else
      try_find_resource(request.get_location)
    end
  end

  def list_directory(dir=".")
    dir = '.' if dir == ''
    list = Dir.entries(dir).sort
    newlist = []
    list.each { |item| newlist << "<a href=/#{dir}/#{item}>#{item}</a>"}
    newlist.join("<br>")
  end

  def try_find_resource(resource)
    resource = resource.sub(/^\/+/, "")
    is_dir = File.directory?(resource)
    if is_dir || resource == ''
      return list_directory(resource)
    else
      return File.file?(resource) ? File.read(resource) : "<h1>404 Error</h1><br>Page not found"
    end
  end

end
