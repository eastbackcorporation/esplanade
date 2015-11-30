# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.find_or_create_by(id: 1,email: "admin1@example.com") do |u|
                        u.password = "admin1234"
                        u.password_confirmation = "admin1234"
                        u.username = "adminname1"
                        u.admin = true
end
User.find_or_create_by(id: 2, email: "user1@example.com") do |u|
                        u.password = "pass1234"
                        u.password_confirmation = "pass1234"
                        u.username = "username1"
end

Category.find_or_create_by(id: 1,title: "category1")
Category.find_or_create_by(id: 2,title: "category2"){|c| c.image = open "test/image/200x300.png"}
Category.find_or_create_by(id: 3,title: "none topic category")

(1..10).each do |i|
  Topic.find_or_create_by(id: i,title: "topic #{i}",value: "value #{i}",category_id: 1,user_id: i%2+1)
end

(11..15).each do |i|
  Topic.find_or_create_by(id: i,title: "topic #{i}",value: "value #{i}",category_id: 2,user_id: 1)
end

(1..10).each do |i|
  Comment.find_or_create_by(id: i,value: "comment #{i}",topic_id: 1,user_id: i%2+1)
end
(11..15).each do |i|
  Comment.find_or_create_by(id: i,value: "comment #{i}",topic_id: 11,user_id: 1){|c| c.image = open "test/image/200x300.png"}
end

