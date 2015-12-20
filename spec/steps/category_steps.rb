# coding: utf-8
steps_for :list do
  tag = self.tag
  step 'カテゴリのデータが登録してある' do
    @sc = ScreenshotPath.new(tag)
    @categories = %w"cateogry0 category1 category2"
    create_category(title: @categories[0])
    create_category(title: @categories[1])
    create_category(title: @categories[2],image: open(Rails.root.join("test","image","100x100.png")))
  end

  step 'カテゴリページを表示する' do
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit home_forums_path
  end

  step 'カテゴリが３つ表示されていること' do
    save_screenshot(@sc.path)
    expect(page).to have_content(@categories[0])
    expect(page).to have_content(@categories[1])
    expect(page).to have_content(@categories[2])
  end

  step 'デフォルト画像が表示されていること' do
    expect(page).to have_css("img[src*='category-default.png']")
  end

  step 'オリジナル画像が表示されていること' do
    expect(page).to have_css("img[src*='100x100.png']")
  end
end

steps_for :link_category do
  tag = self.tag
  step 'カテゴリのデータが登録してある' do
    @sc = ScreenshotPath.new(tag)
    @category = create_category
    @topics = %w"topics1 topics2"
    create_topic(title: @topics[0], category: @category)
    create_topic(title: @topics[1], category: @category)
  end

  step 'カテゴリページを表示する' do
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit home_forums_path
  end

  step 'リンクをクリックする' do
    click_link @category.title
  end

  step 'カテゴリに紐付いているトピック一覧が表示される' do
    expect(page).to have_content(@topics[0])
    expect(page).to have_content(@topics[1])
  end
end

steps_for :new_category do
  tag = self.tag
  
  step '管理者権限のユーザでログインする' do
    @sc = ScreenshotPath.new(tag)
    @user = create_user(admin: true)
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/users/sign_in'
    fill_in 'user[login]', :with => @user.email
    fill_in 'user[password]', :with => @user.password
    click_button 'ログイン'
  end

  step 'カテゴリページを表示する' do
    save_screenshot(@sc.path)
    visit categories_path
  end
  step '新規作成が表示されていること' do
    expect(page).to have_css('span[class="glyphicon glyphicon-plus"]')
    save_screenshot(@sc.path)
  end

  step '新規作成をクリックする' do
    first('span[class="glyphicon glyphicon-plus"]').click
  end
  step '新規作成画面が表示されていること' do
    expect(page).to have_css('input[id="category_title"]')
  end
  step 'タイトル入力し画像を選ぶ' do
    @new_title = "new title"
    fill_in "category[title]", with: @new_title
    save_screenshot(@sc.path)
    #attach_file "category[image]", Rails.root.join("test","image","100x100.png")
  end
  step '作成ボタンを押す' do
    click_button "投稿"
  end
  step 'カテゴリが作成される' do
    c = Category.first
    expect(c.title).to eq @new_title
  end
  step '一覧に反映される' do
    visit home_forums_path
    save_screenshot(@sc.path)
    expect(page).to have_text @new_tile
  end
end

steps_for :new_only_admin do
  step '管理者権限のないユーザでログインする' do
    #normal user
    User.create(email: "test@example.com",
                username: "user1",
                password: "test1234",
                password_confirmation: "test1234",
                admin: false)

    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/users/sign_in'
    fill_in 'user[login]', :with => 'test@example.com'
    fill_in 'user[password]', :with => 'test1234'
    click_button 'ログイン'
  end

  step 'カテゴリページを表示する' do
    visit '/categories'
  end
  step '新規作成が表示されていないこと' do
    expect(page).not_to have_content('新規作成')
  end
  step '新規作成ページが表示されない' do
    visit new_category_path
    expect(page).not_to have_content('新規作成')
  end
end

steps_for :edit_category do
  tag = self.tag
  step '管理者でログインする' do
    @sc = ScreenshotPath.new(tag)
    @user = create_user(admin: true)
    @category = create_category
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/users/sign_in'
    fill_in 'user[login]', :with => @user.email
    fill_in 'user[password]', :with => @user.password
    click_button 'ログイン'
    save_screenshot(@sc.path)
  end 
  step 'カテゴリ編集ページを表示する' do
    visit edit_category_path(@category)
  end
  step '内容を変えて更新する' do
    save_screenshot(@sc.path)
    expect(page).to have_css('input[id="category_title"]')
    @change_title = "change title"
    fill_in "category[title]", with: @change_title
    click_button '更新'
  end
  step 'データが更新され、カテゴリの一覧に内容が反映されている' do
    save_screenshot(@sc.path)
    c = Category.find @category.id
    expect(c.title).to eq @change_title
    visit home_forums_path
    expect(page).to have_content(@change_title)
  end
end
steps_for :edit_category_only_admin do
  tag = self.tag

  step '登録ユーザでログインする' do
    @sc = ScreenshotPath.new(tag)
    @user = create_user(admin: false)
    @category = create_category
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/users/sign_in'
    fill_in 'user[login]', :with => @user.email
    fill_in 'user[password]', :with => @user.password
    click_button 'ログイン'
  end

  step 'カテゴリ編集ページにアクセスする' do 
    visit edit_category_path(@category)
    save_screenshot(@sc.path)
  end
  step '編集ページが表示されない' do 
    expect(page).not_to have_css('input[id="category_title"]')
  end
  step '未登録ユーザで編集ページにアクセスする' do 
    click_link 'ログアウト'
    visit edit_topic_path(@category)
  end
  step '編集ページが表示されない' do 
    save_screenshot(@sc.path)
    expect(page).not_to have_css('input[id="category_title"]')
  end
end
steps_for :delete_category do
  tag = self.tag
  step '管理者でログインする' do
    @sc = ScreenshotPath.new(tag)
    @user = create_user(admin: true)
    @category = create_category
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/users/sign_in'
    fill_in 'user[login]', :with => @user.email
    fill_in 'user[password]', :with => @user.password
    click_button 'ログイン'
  end

  step 'カテゴリ編集ページにアクセスする' do 
    visit edit_category_path(@category)
    save_screenshot(@sc.path)
  end
  step 'ステータスを削除にする' do 
    choose "category_status_deleted"
  end
  step '更新ボタンを押す' do 
    click_button "更新"
  end
  step 'データが更新され、カテゴリの一覧に表示されない' do 
    c = Category.find @category.id
    expect(c.deleted?).to eq true
    visit home_forums_path
    expect(page).not_to have_content(@category.title)
  end
end
