# admin
User.find_or_create_by(id: 1,email: "admin1@example.com") do |u|
                        u.password = "admin1234"
                        u.password_confirmation = "admin1234"
                        u.username = "AdminName1"
                        u.admin = true
end

# user(not admin)
User.find_or_create_by(id: 2, email: "user1@example.com") do |u|
                        u.password = "pass1234"
                        u.password_confirmation = "pass1234"
                        u.username = "UserName1"
                        u.admin = false
end

# active user
User.find_or_create_by(id: 3, email: "active@example.com") do |u|
                        u.password = "pass1234"
                        u.password_confirmation = "pass1234"
                        u.username = "ActiveUser"
                        u.status = User.statuses[:active]
end


# locked user
User.find_or_create_by(id: 4, email: "locked@example.com") do |u|
                        u.password = "pass1234"
                        u.password_confirmation = "pass1234"
                        u.username = "LockedUser"
                        u.status = User.statuses[:locked]
end

# deleted user
User.find_or_create_by(id: 5, email: "deleted@example.com") do |u|
                        u.password = "pass1234"
                        u.password_confirmation = "pass1234"
                        u.username = "DeletedUser"
                        u.status = User.statuses[:deleted]
end

ActiveRecord::Base.connection.execute("SELECT setval('users_id_seq', coalesce((SELECT MAX(id)+1 FROM users), 1), false)")
