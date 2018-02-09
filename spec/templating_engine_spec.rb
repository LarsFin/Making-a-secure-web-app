require 'templating_engine'
describe TemplatingEngine do 
	let :string1 { "<h1> head </h1>\n<% if @name %>\nhello <%= @name %>\n<% end %>\nthat's all"}
	let :string2 { "output = \"<h1> head </h1>\"\n if @name \noutput += \"hello \"\noutput += @name \noutput += \"\"\n end \noutput += \"that's all\"\nreturn output"}

	describe "#convert" do
		it "takes a html style string with ruby tags and converts it into a string of ruby code" do
			expect(subject.convert(string1)).to eq string2
		end
	end
end