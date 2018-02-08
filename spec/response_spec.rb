describe Response do
	describe "#build" do
		it "builds a 200 OK response" do
			params = {text: "text"}
			expect(described_class.new(params).build).to eq "HTTP/1.1 200 OK\r\nConnection: close\r\nContent-type: text/html\r\n\r\ntext"
		end
	end

	
end