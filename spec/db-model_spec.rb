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

    it "can return a specific record in database" do
      allow(Object).to receive(:access_database).
        with("select * from testdbmodels where username = 'username';").
          and_yield([{"username" => "username"}])
      result = testdbmodel.find({'username': 'username'})
      expect(result.username).to eq "username"
    end

    it "can return all records in a table" do
      allow(Object).to receive(:access_database).
        with("select * from testdbmodels;").
          and_yield([{"username" => "username"}, {"username" => "username2"}])
      result = testdbmodel.all
      expect(result[0].username).to eq "username"
      expect(result[1].username).to eq "username2"
    end
  end

  describe "#update" do

  end
end

class TestDBModel
  include DBModel
  attr_accessor :username
  def initialize(params)
    @username = params["username"]
  end
end
