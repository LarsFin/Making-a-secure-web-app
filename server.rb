require 'socket'

class Server
  def initialize(port = 3000)
    @server = TCPServer.new(port)
  end

  def run
    while(true) do
      Thread.start(@server.accept) do |socket|
        request = get_request(socket)
        resource = get_resource_from request
        http_response = formulate_response(resource)
        socket.print http_response
        socket.close
      end
    end
  end

  private
  def get_request(socket)
    p socket.gets.chomp
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

  def get_resource_from request
    p request.split(" ")[1]
  end

  def formulate_response(resource)
    response = "Hello World!" unless response = find_resource(resource)
    build_http_response(response)
  end
end

Server.new.run if "server.rb" == $0
