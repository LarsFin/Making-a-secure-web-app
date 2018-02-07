describe Request do

  before(:each) do
    @request = Request.new("POST testlocation\r\nusername=testBob&password=testpassword")
    @request.generate_hashes
  end

  it "get_method should return the method type of the request" do
    p @request
    expect(@request.get_method()).to eq("POST")
  end

  it "get_location should return the location of the request" do
    expect(@request.get_location()).to eq("testlocation")
  end

  it "get_param returns the value of the specified key of the body" do
    expect(@request.get_param("password")).to eq("testpassword")
  end

end
