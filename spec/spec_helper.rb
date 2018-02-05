require 'capybara/rspec'
require_relative '../server.rb'
Thread.new{ run_server(3001) }
Capybara.default_driver = :selenium

Capybara.app_host = 'http://localhost:3001'
