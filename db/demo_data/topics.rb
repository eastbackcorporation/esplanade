# coding: utf-8

# category
Topic.find_or_create_by(id: 1, title: "カテゴリについて" , category_id: 1, user_id: 1, value: <<V
カテゴリの作成、編集、削除は管理者のみが行えます。
各トピックはいずれかひとつのトピックに紐付きます。
V
)

Topic.find_or_create_by(id: 2, title: "作成", category_id: 1, user_id: 1, value: <<V
作成は管理者のみが行えます。
カテゴリのアイコンである画像を一緒にアップロードすることができます。
画像をアップロードしない場合は、デフォルトの画像が表示されます。
あとでタイトルや画像の編集をすることが可能です。
V
)

Topic.find_or_create_by(id: 3, title: "編集", category_id: 1, user_id: 1, value: <<V
編集は管理者のみが行えます。
タイトルとアイコンの編集が行えます。
V
)

Topic.find_or_create_by(id: 4, title: "削除",category_id: 1, user_id: 1, value: <<V
削除は管理者のみが行えます。
削除された場合、紐付いているトピック、コメントは閲覧できなくなります。（未実装）
V
)

# topic
Topic.find_or_create_by(id: 5, title: "トピックについて", category_id: 2, user_id: 2,value: <<V
トピックの投稿は登録ユーザのみが行えます。
編集、削除などのステータス管理は管理者のみが行えます。
カテゴリの一覧からカテゴリを１つ選択すると、紐ついているトピックが閲覧できます。。
閲覧は未登録ユーザ（ログインなし）でも行えます。
V
)

Topic.find_or_create_by(id: 6, title: "投稿", category_id: 2, user_id: 2, value: <<V
トピックの投稿は登録ユーザのみが行えます。
一度投稿されたトピックの編集や削除は登録ユーザではできません。
追記や不備がある場合は、コメントを投稿して対応してください。もしくは管理者に連絡してください。
V
)

Topic.find_or_create_by(id: 7, title: "編集や削除", category_id: 2, user_id: 2, value: <<V
編集や削除は管理者のみが行えます。
V
)

Topic.find_or_create_by(id: 8, title: "ステータス", category_id: 2, user_id: 2, value: <<V
ステータスは、
アクティブ（デフォルト）：コメント投稿は可。閲覧も可。
ロック：コメント投稿は不可。閲覧は可
デリート：コメント投稿、閲覧ともに不可
今のところ管理者のみがステータスの操作が可能。
V
)

# comment
Topic.find_or_create_by(id: 9, title: "コメントについて", category_id: 3, user_id: 2, value: <<V
コメントの投稿は登録ユーザのみ可能。
編集、削除は管理者のみが行えます。
トピックの一覧からトピックを１つ選択すると、紐ついているコメントが閲覧できます。。
閲覧は未登録ユーザ（ログインなし）でも行えます。
V
)

Topic.find_or_create_by(id: 10, title: "投稿", category_id: 3, user_id: 2, value: <<V
コメントの投稿は登録ユーザのみが行えます。
一度投稿されたコメントの編集や削除は登録ユーザではできません。
追記や不備がある場合は、再度コメントを投稿して対応してください。もしくは管理者に連絡してください。
コメントの投稿ごとに１つの画像のアップロードすることが可能です。
V
)

Topic.find_or_create_by(id: 11, title: "編集や削除", category_id: 3, user_id: 2, value: <<V
編集や削除は管理者のみが行えます。
V
)

# user
Topic.find_or_create_by(id: 12, title: "ユーザについて", category_id: 4, user_id: 2, value: <<V
ユーザは３つのタイプがあります。
管理者：ユーザの編集やカテゴリやトピックやコメントの編集等の権限があります。
登録ユーザ：トピックとコメントの投稿の権限があります。サインアップ後にログインすることで登録ユーザになります。※
未登録ユーザ：閲覧のみが可能です。ログインする必要はありません。
※登録ユーザでも管理者により、ステータスを変更されるとログイン出来ない状態になります。
V
)

Topic.find_or_create_by(id: 13, title: "サインアップ", category_id: 4, user_id: 2, value: <<V
登録ユーザになるためには、サインアップする必要があります。
メールアドレス、ユーザ名、パスワードを入力することで登録されます。
メールアドレスによる確認はしません。現在ログインの際に用いるIDのみとして使用しています。
ユーザ名はトピックやコメント投稿の際に表示されます。また、ログイン時にも使用できます。
パスワードは、8文字以上である必要があります。
V
)

Topic.find_or_create_by(id: 14, title: "ログイン", category_id: 4, user_id: 2, value: <<V
ログインは、登録した際のメールアドレス、又はユーザ名とパスワードでログインすることができます。ログイン後は、トピックやコメントの投稿が行えます。
ユーザのステータスがロックもしくは、デリートであれば、ログインすることができません。管理者に連絡してください。
V
)

Topic.find_or_create_by(id: 15, title: "ログアウト", category_id: 4, user_id: 2, value: <<V
ログアウトすると閲覧のみが可能です。
V
)

Topic.find_or_create_by(id: 16, title: "削除", category_id: 4, user_id: 2, value: <<V
削除した場合、トピックやコメントは残ります。
現在、削除した場合は、ユーザデータが消えます。（ステータスをデリートにする必要がある。未実装）
V
)

ActiveRecord::Base.connection.execute("SELECT setval('topics_id_seq', coalesce((SELECT MAX(id)+1 FROM topics), 1), false)")

# empty
long_title="long "*30 + "title"
long_value="long "*30 + "value"
(1..20).each do |i|
  Topic.find_or_create_by(title: "#{long_title} #{i}",value: "#{long_value} #{i}",category_id: 5,user_id: i%2+1)
end

