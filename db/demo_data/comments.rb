# coding: utf-8

Comment.find_or_create_by(topic_id: 6, user_id: 2, value: <<V
追記です。
xxxxの型番でxxxxxのランプが点滅しています。
V
)

Comment.find_or_create_by(topic_id: 6, user_id: 2, value: <<V
修正です。
aaaaaは間違いで、bbbbbbでした。
V
)
Comment.find_or_create_by(topic_id: 6, user_id: 1, value: <<V
↑のような感じで対応してください。
V
)

Comment.find_or_create_by(topic_id: 10, user_id: 2, value: <<V
先ほどのコメントはまちがいです。
正しくは、ccccccです。
V
)
Comment.find_or_create_by(topic_id: 10, user_id: 1, value: <<V
↑のような感じで対応してください。もしくは、管理者に連絡してください。
V
)
Comment.find_or_create_by(value: "画像付きのコメントです。画像をクリックすると元画像が表示されます。",topic_id: 10,user_id: 1){|c| c.image = open "test/image/200x300.png"}

# comment
(1..20).each do |i|
  Comment.find_or_create_by(value: "これはコメントです。 #{i}",topic_id: 1,user_id: i%2+1)
end
(11..15).each do |i|
  Comment.find_or_create_by(value: "画像付きのコメントです。　#{i}",topic_id: 1,user_id: 1){|c| c.image = open "test/image/200x300.png"}
end
