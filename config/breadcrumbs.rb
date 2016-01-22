# coding: utf-8
crumb :root do
  link "ホーム", home_forums_path
end

crumb :admin_root do
  link "管理メニュー", forums_path
end

crumb :index_category do
  link "カテゴリ一覧", admin_categories_path
  parent :admin_root
end

crumb :new_category do
  link "カテゴリ作成", new_category_path
  parent :index_category
end

crumb :new_topic do |topic|
  link "トピック作成", new_topic_path
  parent :category, topic.category
end

crumb :index_topic do
  link "トピック一覧", admin_topics_path
  parent :admin_root
end

crumb :index_comment do
  link "コメント一覧", comments_path
  parent :admin_root
end

crumb :index_user do
  link "ユーザ一覧", admin_users_path
  parent :admin_root
end

crumb :search do
  link "検索結果", search_forums_path
  parent :root
end

crumb :category do |category|
  link category.title, category
  parent :root
end

crumb :topics do |selected_category|
  link "トピック選択", topics_path
  parent :category, selected_category
end

crumb :topic do |topic|
  link topic.title, topic
  parent :category, topic.category
end
