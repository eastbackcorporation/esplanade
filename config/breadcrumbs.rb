# coding: utf-8
crumb :root do
  link "ホーム", forums_home_path
end

crumb :categories do
  link "カテゴリ選択", categories_path
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

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
