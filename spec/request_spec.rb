describe Request do

  before(:each) do
    @request = Request.new("TEST testlocation\r\nusername=testBob&password=testpassword")
  end

  it "get_method should return the method type of the request" do
    expect(@request.get_method()).to eq("TEST")
  end

  it "get_location should return the location of the request" do
    expect(@request.get_location()).to eq("testlocation")
  end

  it "get_param returns the value of the specified key of the body" do
    expect(@request.get_param("password")).to eq("testpassword")
  end

end
