require 'pg'

def create_table name

end

def insert table, command

end

def access_database command, &block
  connection = PG.connect(dbname: 'hackapp_test')
  connection.exec(command) do |result|
  	yield(result) if block
  end
end

def create_db
  conn = PG.connect(dbname: 'postgres')
  conn.exec("CREATE DATABASE hackapp_test")
	access_database("create table users(id serial, username varchar(255));")
end
