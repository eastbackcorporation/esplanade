# coding: utf-8
Category.find_or_create_by(id: 1,title: "カテゴリー関連"){|c| c.image = open "test/image/200x300.png"}
Category.find_or_create_by(id: 2,title: "トピック関連")
Category.find_or_create_by(id: 3,title: "コメント関連")
Category.find_or_create_by(id: 4,title: "ユーザ関連")

ActiveRecord::Base.connection.execute("SELECT setval('categories_id_seq', coalesce((SELECT MAX(id)+1 FROM categories), 1), false)")

5.times do |i|
  Category.find_or_create_by(title: "empty category #{i}")
end

