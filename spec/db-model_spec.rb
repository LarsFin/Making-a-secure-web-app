require 'db-model'

describe DBModel do

  subject(:testdbmodel) { TestDBModel }

  describe "#create" do

    it "can input to the database" do
      expect(Object).to receive(:access_database).with "insert into testdbmodels(username) values('username');"
      testdbmodel.create({'username': 'username'})
    end
  end

  describe "reading from db" do
    it "can find a specific record in database" do
      expect(Object).to receive(:access_database).
        with "select * from testdbmodels where username = 'username';"
      testdbmodel.find({'username' => 'username'})
    end

    it "returns the value from database search" do
      allow(Object).to receive(:access_database).
        with("select * from testdbmodels where username = 'username';").
          and_yield([{"username" => "username"}])
      result = testdbmodel.find({'username': 'username'})
      expect(result.username).to eq "username"
    end
  end
end

class TestDBModel
  include DBModel
  attr_accessor :username
  def initialize(params)
    p params
    @username = params["username"]
  end
end
