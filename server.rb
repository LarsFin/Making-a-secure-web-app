require 'socket'

def run_server
  server = TCPServer.new(3000)
  p 'in server'
  while(true) do
    Thread.start(server.accept) do |socket|
      a = socket.gets.chomp
      p a
      puts "- Got request -"
      response = "Hello World!"
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

run_server
