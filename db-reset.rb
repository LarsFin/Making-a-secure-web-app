require_relative 'lib/db-connect'

DBConnect.clear
DBConnect.clear('development')
DBConnect.create_db
DBConnect.create_db('development')
