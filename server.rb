require 'socket'

def run_server(port = 3000)
  server = TCPServer.new(port)
  p 'in server'
  while(true) do
    Thread.start(server.accept) do |socket|
      request = socket.gets.chomp
      p request
      puts "- Got request -"
      resource = get_resource_from request
      p resource
      response = "Hello World!" unless response = find_resource(resource)
      http_response = build_http_response(response)
      socket.print http_response
      socket.close
    end
  end

  p 'after server'

end

def build_http_response(response)
  "HTTP/1.1 200 OK\r\n" +
    "Connection: close\r\n" +
    "\r\n" +
    response
end

def find_resource resource
  "Sign up" if resource == "/users/new"
end

def get_resource_from request
  request.split(" ")[1]
end

run_server if "server.rb" == $0
