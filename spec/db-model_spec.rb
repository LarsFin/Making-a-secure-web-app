require 'db-model'

describe DBModel do

  subject(:testdbmodel) { TestDBModel }

  describe "#create" do

    it "can input to the database" do
      expect(Object).to receive(:access_database).with "insert into testdbmodels(username) values('username');"
      testdbmodel.create({'username': 'username'})
    end
  end

  describe "#read" do
    it "can read from database" do

    end
  end
end

class TestDBModel
  include DBModel
  def initialize(params)
  end
end
