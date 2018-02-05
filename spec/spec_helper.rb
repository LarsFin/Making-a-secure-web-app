require 'capybara/rspec'
require_relative '../server.rb'
Thread.new{ run_server }
Capybara.default_driver = :selenium

Capybara.app_host = 'http://localhost:3000'
