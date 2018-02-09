module TemplatingEngine

	def herb(file)
		execute(convert(File.read(file)))
	end

	private

	def convert string
		("output = \"" + string)
			.delete("\n")
			.gsub("~%=", "\"\noutput +=")
		  .gsub("~%", "\"\n")
		  .gsub("%~", "\noutput += \"")
		  .+ "\"\nreturn output"
	end

	def execute string
		eval(string)
	end

end
