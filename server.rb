ENV['DB_ENV'] ||= 'development'
require 'socket'
require_relative 'lib/server/request'
require 'pp'
require_relative 'lib/db/db-connect'
require_relative 'lib/server/middleware'

class Server

  attr_reader :middleware

  def initialize(port = 3000, app_class)
    @server = TCPServer.new(port)
    @middleware = Middleware.new(app_class)
  end

  def run
    puts "Booting up the server.."
    puts "Server booted!"
    while(true) do
      Thread.start(@server.accept) do |socket|
        begin
          request = Request.new(socket.recv(4096))
          request.generate_hashes
          #pp(request)
          # resource = request.get_location
          # post_users(request) if request.get_method == 'POST' && request.get_location
          # http_response = formulate_response(resource)
          res = middleware.get_response(request)

          socket.print(res.build)
          socket.close
        rescue Exception => error
          puts "Error: " + error.to_s
          puts error.backtrace
          socket.print middleware.error.build
          socket.close
        end
      end
    end
  end

  private
  # def post_users(request)
  #   p "in post users"
  #   p request.params
  #   DBConnect.access_database("insert into users(username) values ('#{request.get_param('username')}')")
  #   p "posted"
  # end

  # def build_http_response(response, code = '200 OK')
  #   "HTTP/1.1 #{code}\r\n" +
  #     "Connection: close\r\n" +
  #     "Content-type: text/html\r\n" +
  #     "\r\n" +
  #     response
  # end



  # def formulate_response(resource)
  #   res = try_find_resource(resource)
  #   return build_http_response(res) if res
  #   build_http_response(list_directory())
  # end
end

Server.new(App).run if "server.rb" == $0
