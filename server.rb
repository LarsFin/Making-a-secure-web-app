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
        # http_response = formulate_response(resource)
        socket.print formulate_response(resource)
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
      "Content-type: text/html\r\n" +
      "\r\n" +
      response
  end

  def list_directory
    list = Dir.entries(".")
    newlist = []
    list.each { |item| newlist << "<a href=./#{item}>#{item}</a>"}
    newlist.join("<br>")
  end

  def find_resource resource
    return File.read("public/sign-in.html") if resource == "/users/new"
    Dir.entries(".").include?(resource[1..-1]) ? File.read(resource[1..-1]) : nil
  end

  def formulate_response(resource)
    response = list_directory unless response = find_resource(resource)
    build_http_response(response)
  end
end

Server.new.run if "server.rb" == $0
