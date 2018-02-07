ENV['DB_ENV'] ||= 'development'
require 'socket'
require_relative './request'
require 'pp'
require_relative 'lib/db-connect'
require_relative './middleware'

class Server

  attr_reader :middleware

  def initialize(port = 3000, app_class)
    @server = TCPServer.new(port)
    @middleware = Middleware.new(app_class)
  end

  def run
    while(true) do
      Thread.start(@server.accept) do |socket|
        request = Request.new(socket.recv(4096))
        request.generate_hashes
        # middleware.build_controller_name(request)
        pp(request)
        # resource = request.get_location
        # post_users(request) if request.get_method == 'POST' && request.get_location
        # http_response = formulate_response(resource)
        res = middleware.build_controller_name(request)
        socket.print build_http_response(res)
        socket.close
      end
    end
  end

  private
  def post_users(request)
    p "in post users"
    p request.params
    DBConnect.access_database("insert into users(username) values ('#{request.get_param('username')}')")
    p "posted"
  end

  def build_http_response(response)
    "HTTP/1.1 200 OK\r\n" +
      "Connection: close\r\n" +
      "Content-type: text/html\r\n" +
      "\r\n" +
      response
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

  def formulate_response(resource)
    res = try_find_resource(resource)
    return build_http_response(res) if res
    build_http_response(list_directory())
  end
end

Server.new(App).run if "server.rb" == $0
