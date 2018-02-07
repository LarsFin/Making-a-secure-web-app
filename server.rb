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
        #pp(request)
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

Server.new.run if "server.rb" == $0
