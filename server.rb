ENV['DB_ENV'] ||= 'development'
require 'socket'
require_relative './request'
require 'pp'
require_relative 'lib/db-connect'

class Server
  def initialize(port = 3000)
    @server = TCPServer.new(port)
  end

  def run
    while(true) do
      Thread.start(@server.accept) do |socket|
        request = Request.new(socket.recv(4096))
        request.generate_hashes
        pp(request)
        resource = request.get_location
        post_users(request) if request.get_method == 'POST' && request.get_location
        http_response = formulate_response(resource)
        socket.print http_response
        socket.close
      end
    end
  end

  private
  def post_users(request)
    p request.params
    access_database("insert into users(username) values ('#{request.get_param('username')}')")
  end

  def build_http_response(response)
    "HTTP/1.1 200 OK\r\n" +
      "Connection: close\r\n" +
      "\r\n" +
      response
  end

  def find_resource resource
    File.read("public/sign-in.html") if resource == "/users/new"
  end

  def formulate_response(resource)
    response = "Hello World!" unless response = find_resource(resource)
    build_http_response(response)
  end
end

Server.new.run if "server.rb" == $0
