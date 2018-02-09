require 'pg'

class DBConnect
  def self.access_database command, &block
    connection = PG.connect(dbname: "hackapp_#{ENV['DB_ENV']}")
    result =connection.exec(command) do |result|
    	yield(result) if block
    end
    connection.close
    return result
  end

  def self.create_db(name = 'test')
    conn = PG.connect(dbname: 'postgres')
    conn.exec("CREATE DATABASE hackapp_#{name};")
    conn = PG.connect(dbname: "hackapp_#{name}")
  	conn.exec("create table users(id serial, username varchar(255), password varchar(255));")
    conn.exec("create table posts(id serial, content text, user_id integer);")
    conn.close
  end

  def self.clear(name = 'test')
    conn = PG.connect(dbname: 'postgres')
    conn.exec("DROP DATABASE IF EXISTS hackapp_#{name};")
    conn.close
  end
end
