require 'capybara/dsl'
require 'capybara/rspec'
require 'capybara/webkit'
require 'capybara/poltergeist'
require 'turnip'
require 'turnip/capybara'

Dir.glob("spec/**/*steps.rb") { |f| load f, true }

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :default_max_wait_time => 30, :timeout => 100})
end

Capybara.configure do |config|
  #config.default_driver = :selenium
  config.default_driver = :poltergeist
  config.javascript_driver = :poltergeist
  config.ignore_hidden_elements = true
  config.default_max_wait_time = 30
end
