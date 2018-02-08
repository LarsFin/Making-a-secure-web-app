describe Request do

  before(:each) do
    @request = Request.new("POST testlocation\r\nusername=testBob&password=testpassword")
    @request.generate_hashes()
  end

  it "get_method should return the method type of the request" do
    expect(@request.get_method()).to eq("POST")
  end

  it "get_location should return the location of the request" do
    expect(@request.get_location()).to eq("testlocation")
  end

  it "get_param returns the value of the specified key of the body" do
    expect(@request.get_param("password")).to eq("testpassword")
  end

  describe("#has_cookie?") do
    it "returns false if it does not have a cookie" do
      expect(@request.has_cookie?).to be(false)
    end
  end

  describe("#get_cookie") do
    it "returns the key of a stored cookie" do
      request = Request.new("GET testlocation\r\nCookie: a=b\r\n")
      request.generate_hashes
      expect(request.get_cookie("a")).to eq("b")
    end
  end
end
