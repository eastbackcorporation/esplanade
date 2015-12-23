require 'capybara/dsl'
require 'capybara/rspec'
require 'capybara/webkit'
require 'capybara/poltergeist'
require 'turnip'
require 'turnip/capybara'

Dir.glob("spec/**/*steps.rb") { |f| load f, true }

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :default_max_wait_time => 30, :timeout => 60})
end

Capybara.configure do |config|
  config.default_driver = :selenium
  #config.default_driver = :poltergeist
  #config.javascript_driver = :poltergeist
  config.ignore_hidden_elements = true
  config.default_max_wait_time = 3
end

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

SCREENSHOT_PATH = Rails.root.join("spec","images")
class ScreenshotPath
  attr_reader :index
  def initialize(name,path=SCREENSHOT_PATH)
    @path = path
    @name = name
    @index = 0
  end
  def path
    @index += 1
    "#{@path}/#{@name}-#{sprintf("%03d",@index)}.png"
  end
end

USER="testuser"
CATEGORY="test category"
TOPIC="test topic"
COMMENT="test comment"
def create_user(username: USER,
                admin: false,
                status: :active,
                password: "test1234")
  if User.where(username: username)
    username += User.all.count.to_s
  end
  User.create(email: username+"@test.com",
              username: username,
              password: password,
              password_confirmation: password,
              status: status,
              admin: admin)
end

def create_category(title: CATEGORY,
                    status: :active,
                    image: nil,
                    created_at: Time.now,
                    updated_at: Time.now)
  Category.create(title: title,status: Category.statuses[status],image: image, created_at: created_at, updated_at:updated_at)
end

def create_topic(user: create_user,
                 title: TOPIC,
                 value: "topic value",
                 category: create_category,
                 status: :active,
                    created_at: Time.now,
                    updated_at: Time.now)
  Topic.create(title: title,value: value,category_id: category.id, user_id: user.id, status: Topic.statuses[status], created_at: created_at, updated_at:updated_at)
end
def create_comment(user: create_user,
                   value: COMMENT,
                   topic: create_topic,
                   status: :active,
                    created_at: Time.now,
                    updated_at: Time.now)
  Comment.create(value: value, topic_id: topic.id, user_id: user.id, status: Comment.statuses[status], created_at: created_at, updated_at:updated_at)
end
# def get_user(username: USER)
#   User.where(username: username).first
# end
# 
# def get_category(title: CATEGORY)
#   Category.where(title: title).first
# end
# 
# def get_topic(title: TOPIC)
#   Topic.where(title: title).first
# end
# 
# def get_comment(value: "value")
#   Comment.where(value: value).first
# end
# 
# 
