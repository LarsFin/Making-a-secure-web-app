describe Middleware do

  let(:request) { double(get_method: "TRY", get_location: "/test")}
  let(:request2) { double(get_method: "TRY", get_location: "/test/test2/test3")}
  let(:app_class) { double(new: app_instance) }
  let(:app_instance) { double(try_test: "Test passed", try_test_test2_test3: "Test 2 passed") }
  subject(:middleware) { described_class.new app_class }

  it "build_controller_name should build a suitable name for a request given" do
    expect(subject.build_controller_name(request)).to eq('Test passed')
  end

  it "build_controller_name should handle multiple slashes" do
    expect(subject.build_controller_name(request2)).to eq('Test 2 passed')
  end

end
