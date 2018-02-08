describe Middleware do

  let(:request) { double(get_method: "TRY", get_location: "/test")}
  let(:request2) { double(get_method: "TRY", get_location: "/test/test2/test3")}
  let(:request3) { double(get_method: "TRY", get_location: "/not_a_real_route")}
  let(:response_class) {double(:response_class, new: response)}
  let(:response) {double(:response)}
  let(:app_class) { double(new: app_instance) }
  let(:app_instance) { double(try_test: "Test passed", try_test_test2_test3: "Test 2 passed") }
  subject(:middleware) { described_class.new app_class, response_class }

  it "should build a suitable name for a request given" do
    expect(response_class).to receive(:new).with({text: "Test passed"})
    subject.get_response(request)
    # expect(subject.build_controller_name(request)).to eq('Test passed')
  end

  it "should handle multiple slashes" do
    expect(response_class).to receive(:new).with({text: "Test 2 passed"})
    subject.get_response(request2)
    # expect(subject.build_controller_name(request2)).to eq('Test 2 passed')
  end

  it "correctly returns 404 errors" do
    expect(response_class).to receive(:new).with({text: "<h1>404 Error</h1><br>Page not found", code: "404 Not Found"})
    subject.get_response(request3)
  end

end
