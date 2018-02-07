ENV['DB_ENV'] ||= 'test'
require 'capybara/rspec'
require 'db-connect'
require_relative '../server.rb'

Thread.new{ Server.new(3001).run }

Capybara.default_driver = :selenium
Capybara.app_host = 'http://localhost:3001'

RSpec.configure do |config|
	config.around(:each) do |example|
		example.run
		DBConnect.access_database('truncate table users cascade;')
		# access_database('truncate table posts cascade;')
	end
end
