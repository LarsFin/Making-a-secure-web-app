require './app'
require_relative './lib/response'

class Middleware

  def initialize(app_class, response_class = Response)
    @app = app_class.new
    @parameters = Hash.new
    @response_class = response_class
  end

  def get_response request
    params =get_response_params(build_controller_name(request), request)
    
    response_class.new(params)
    
  end

  def redirect path
    {text: "Location: #{path}\r\n", code: "303 See Other"}
  end

  private

  attr_reader :response_class, :parameters, :app

  def clean()
    parameters = Hash.new
  end

  def build_controller_name(request)
    method = request.get_method
    location = request.get_location.split("/").join("_")
    location = "_homepage" if location.empty?
    controller_name =  "#{method}#{location}".downcase
  end

  def get_response_params(method, request)
    if app.respond_to?(method) 
     res = app.public_send(method, request)
     return (res.is_a? Hash) ? res : {text: res}
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
      return File.file?(resource) ? {text: File.read(resource)} : {text: "<h1>404 Error</h1><br>Page not found", code: "404 Not Found"}
    end
  end

end
