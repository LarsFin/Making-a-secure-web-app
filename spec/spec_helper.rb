require 'capybara/rspec'
require_relative '../server.rb'
Thread.new{ Server.new(3001).run }
Capybara.default_driver = :selenium
Capybara.app_host = 'http://localhost:3001'
