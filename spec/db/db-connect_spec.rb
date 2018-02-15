describe "accessing the database" do

  describe "#access_database" do

    it "can input and read from the database" do
      DBConnect.access_database("insert into users(username, password) values('Test User', 'password')")
      DBConnect.access_database("insert into users(username, password) values('Test User2', 'password')")
      DBConnect.access_database("select * from users; select * from users;") do |users|
        expect(users[0]['username']).to eq('Test User')
        expect(users[1]['username']).to eq('Test User2')
        expect(users.ntuples).to eq 2
      end
    end

    it "can update database entries" do
      DBConnect.access_database("insert into users(username, password) values('Test User', 'password')")
      DBConnect.access_database("update users set username = 'Test User modified' where username = 'Test User'")
      DBConnect.access_database("select * from users; select * from users;") do |users|
        expect(users[0]['username']).to eq('Test User modified')
      end
    end
  end
end
