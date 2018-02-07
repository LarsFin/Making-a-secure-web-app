require 'db-model'

class TestDBModel
  include DBModel
  attr_accessor :id, :username
  def initialize(params)
    @id = params["id"]
    @username = params["username"]
  end
end

describe DBModel do

  subject(:testdbmodel) { TestDBModel }

  describe "#create" do

    it "can input to the database" do
      DBConnect.stub(access_database: nil)
      expect(DBConnect).to receive(:access_database)
        .with("insert into testdbmodels(username) values('username');")
      testdbmodel.create({'username': 'username'})
    end
  end

  describe "reading from db" do
    it "can find a specific record in database" do
      expect(DBConnect).to receive(:access_database)
        .with "select * from testdbmodels where username = 'username';"
      testdbmodel.find({'username' => 'username'})
    end

    it "can return a specific record in database" do
      allow(DBConnect).to receive(:access_database)
        .with("select * from testdbmodels where username = 'username';")
          .and_yield([{"username" => "username"}])
      result = testdbmodel.find({'username': 'username'})
      expect(result.username).to eq "username"
    end

    it "can return all records in a table" do
      allow(DBConnect).to receive(:access_database)
        .with("select * from testdbmodels;")
          .and_yield([{"username" => "username"}, {"username" => "username2"}])
      result = testdbmodel.all
      expect(result[0].username).to eq "username"
      expect(result[1].username).to eq "username2"
    end
  end

  describe "#save" do
    it "can update an existing database entry using a model object" do
      test_model = testdbmodel.new({"id" => 0, "username" => "username"})
      expect(DBConnect).to receive(:access_database)
        .with("update testdbmodels set username = 'username' where id = 0;")
      test_model.save
    end
  end

  describe "#delete" do
    it "removes the specified record from the database table" do
      expect(DBConnect).to receive(:access_database)
        .with("delete from testdbmodels where id = 0;")
      testdbmodel.delete({'id'=>0})
    end
  end

  describe "#tablename" do
    it "returns the name of the table in the database corresponding to the model" do
      expect(testdbmodel.tablename).to eq "testdbmodels"
    end
  end
end
