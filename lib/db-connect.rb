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
