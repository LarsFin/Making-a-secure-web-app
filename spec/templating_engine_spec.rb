# require 'templating_engine'
# describe TemplatingEngine do
# 	let :string1 { "<h1> head </h1>\n~% var = 'test' %~~% if var %~\nhello ~%= var %~\n~% end %~\n<br>\nthat's all" }
# 	let :string2 { "output = \"<h1> head </h1>\"\n var = 'test' \noutput += \"\"\n if var \noutput += \"hello \"\noutput += var \noutput += \"\"\n end \noutput += \"<br>that's all\"\nreturn output" }
# 	let :string3 { "<h1> head </h1>hello test<br>that's all" }
#
# 	describe "#convert" do
# 		it "takes a html style string with ruby tags and converts it into a string of ruby code" do
# 			expect(subject.convert(string1)).to eq string2
# 		end
# 	end
#
# 	describe '#execute' do
# 		it "executes a piece of ruby code given in the form of a string and returns the output" do
# 			expect(subject.execute(string2)).to eq string3
# 		end
# 	end
# end
