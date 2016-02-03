# admin
User.find_or_create_by(id: 1,email: "admin1@example.com") do |u|
                        u.password = "admin1234"
                        u.password_confirmation = "admin1234"
                        u.username = "AdminName1"
                        u.admin = true
end
