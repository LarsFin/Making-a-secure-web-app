class Response
	def initialize params
		@params = params
		@params[:code] ||= "200 OK"
		@params[:text] ||= ""
	end
	def build
		res =  "HTTP/1.1 #{@params[:code]}\r\n" +
      "Connection: close\r\n" +
      "Content-type: text/html\r\n"
    res += "Location: #{@params[:location]}\r\n" if @params[:location]
		res += "Set-Cookie: #{@params[:cookie]}\r\n" if @params[:cookie]
    res +="\r\n" +
    	@params[:text]
	end

	private
	attr_reader :text, :code

end
