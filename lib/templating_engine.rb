class TemplatingEngine

	def convert string
		("output = \"" + string)
			.delete("\n")
			.gsub("<%=", "\"\noutput +=")
		  .gsub("<%", "\"\n")
		  .gsub("%>", "\noutput += \"")
		  .+ "\"\nreturn output"
	end

end