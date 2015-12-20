# coding: utf-8
steps_for :list do
  tag = self.tag
  
  step 'トピックのデータが登録してある' do
    @sc = ScreenshotPath.new(tag)
    @user = create_user
    @category = create_category
    @topics = %w"topic0 topic1 topic2"
    create_topic(title: @topics[0],category: @category, user: @user)
    create_topic(title: @topics[1],category: @category, user: @user)
    create_topic(title: @topics[2],category: @category, user: @user)
  end

  step 'カテゴリのページを表示する' do
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit home_forums_path
    save_screenshot(@sc.path)
  end

  step 'カテゴリのリンクをクリックする' do
    click_link @category.title
  end

  step 'トピックの一覧が表示されていること' do
    expect(page).to have_content @topics[0]
    expect(page).to have_content @topics[1]
    expect(page).to have_content @topics[2]
    save_screenshot(@sc.path)
  end
end

steps_for :link do
  tag = self.tag

  step 'トピックのデータが登録してある' do
    @sc = ScreenshotPath.new(tag)
    @user = create_user
    @category = create_category
    @topic = create_topic(category: @category,user: @user)
    @comment = %w"comment0 comment1"
    create_comment(value:@comment[0],topic: @topic,user: @user)
    create_comment(value:@comment[1],topic: @topic,user: @user)
  end

  step 'トピックのページを表示する' do
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit category_path(@category)
    save_screenshot(@sc.path)
  end

  step 'リンクをクリックする' do
    click_link @topic.title
    save_screenshot(@sc.path)
  end

  step 'トピックに紐付いているコメント一覧が表示される' do
    save_screenshot(@sc.path)
    expect(page).to have_content(@comment[0])
    expect(page).to have_content(@comment[1])
    save_screenshot(@sc.path)
  end
end

steps_for :new_topic do
  tag = self.tag

  step '登録ユーザでログインする' do
    @sc = ScreenshotPath.new(tag)
    @user = create_user
    @category = create_category
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/users/sign_in'
    fill_in 'user[login]', :with => @user.email
    fill_in 'user[password]', :with => @user.password
    click_button 'ログイン'
  end

  step 'トピックページを表示する' do
    visit category_path(@category)
    save_screenshot(@sc.path)
  end

  step '新規作成が表示されていること' do
    expect(page).to have_css('span[class="glyphicon glyphicon-plus"]')
    save_screenshot(@sc.path)
  end

  step '新規作成をクリックする' do
    find('span[class="glyphicon glyphicon-plus"]').click
  end

  step '新規作成画面が表示されていること' do
    expect(page).to have_css('input[id="topic_title"]')
    expect(page).to have_css('textarea[id="topic_value"]')
    save_screenshot(@sc.path)
  end
  step 'タイトルと詳細を入力する' do
    @new_title = "new title"
    @new_value = "new title"
    fill_in "topic[title]", with: @new_title
    fill_in "topic[value]", with: @new_value
    save_screenshot(@sc.path)
  end
  step '投稿ボタンを押す' do
    click_button "投稿"
  end
  step 'トピックが作成される' do
    c = Topic.first
    expect(c.title).to eq @new_title
    expect(c.value).to eq @new_value
    save_screenshot(@sc.path)
  end
  step '一覧に反映される' do
    expect(page).to have_text @new_title
    save_screenshot(@sc.path)
  end
end

steps_for :new_only_registered_user do
  tag = self.tag

  step 'トピックページを表示する' do
    @sc = ScreenshotPath.new(tag)
    @category = create_category
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit category_path(@category)
  end

  step '新規作成が表示されていないこと' do
    save_screenshot(@sc.path)
    expect(page).not_to have_css('span[class="glyphicon glyphicon-plus"]')
  end
  step '新規作成ページが表示されない' do
    visit new_topic_path
    expect(page).not_to have_content('投稿')
    save_screenshot(@sc.path)
  end
end

steps_for :edit_topic do
  tag = self.tag
  step '管理者でログインする' do
    @sc = ScreenshotPath.new(tag)
    @user = create_user(admin: true)
    @category = create_category
    @topic = create_topic(category: @category)
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/users/sign_in'
    fill_in 'user[login]', :with => @user.email
    fill_in 'user[password]', :with => @user.password
    click_button 'ログイン'
  end
  step 'トピック編集ページを表示する' do
    save_screenshot(@sc.path)
    visit edit_topic_path(@topic)
  end
  step '編集ページが表示されていること' do
    save_screenshot(@sc.path)
    expect(page).to have_css('input[id="topic_title"]')
    expect(page).to have_css('textarea[id="topic_value"]')
  end
  step '内容を変えて更新ボタンを押す' do
    save_screenshot(@sc.path)
    @change_title = "change title"
    @change_value = "cahnge value"
    fill_in "topic[title]", with: @change_title
    fill_in "topic[value]", with: @change_value
    click_button '更新'
  end
  step '内容が更新されていること' do
    save_screenshot(@sc.path)
    visit category_path(@category)
    expect(page).to have_content(@change_title)
    expect(page).to have_content(@change_value)
  end
end
steps_for:edit_only_admin do
  tag = self.tag
  step '登録ユーザで編集ページにアクセスする' do
    @sc = ScreenshotPath.new(tag)
    @user = create_user(admin: false)
    @category = create_category
    @topic = create_topic(category: @category)
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/users/sign_in'
    fill_in 'user[login]', :with => @user.email
    fill_in 'user[password]', :with => @user.password
    click_button 'ログイン'
    save_screenshot(@sc.path)
    visit edit_topic_path(@topic)
  end
  step '編集ページが表示されない' do
    save_screenshot(@sc.path)
    expect(page).not_to have_css('input[id="topic_title"]')
    expect(page).not_to have_css('textarea[id="topic_value"]')
  end
  step '未登録ユーザで編集ページにアクセスする' do
    click_link 'ログアウト'
    visit edit_topic_path(@topic)
  end
  step '編集集ページが表示されないこと' do
    save_screenshot(@sc.path)
    expect(page).not_to have_css('input[id="topic_title"]')
    expect(page).not_to have_css('textarea[id="topic_value"]')
  end
end
steps_for :delete do
  tag = self.tag
  step '管理者で編集ページにアクセスする' do
    @sc = ScreenshotPath.new(tag)
    @user = create_user(admin: true)
    @category = create_category
    @topic = create_topic(category: @category)
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/users/sign_in'
    fill_in 'user[login]', :with => @user.email
    fill_in 'user[password]', :with => @user.password
    click_button 'ログイン'
    save_screenshot(@sc.path)
    visit edit_topic_path(@topic)
  end
  step '編集ページが表示されること' do
    save_screenshot(@sc.path)
    expect(page).to have_css('input[id="topic_title"]')
    expect(page).to have_css('textarea[id="topic_value"]')
  end
  step 'ステータスを削除にして更新する' do
    choose "topic_status_deleted"
  end
  step '更新ボタンを押す' do
    click_button '更新'
  end
  step 'データベース上のトピックのステータスが削除になっていること' do
    t =  Topic.find @topic.id
    expect(t.deleted?).to eq true
  end
  step '該当のトピックがトピックの一覧から消える' do
    visit category_path(@category)
    expect(page).not_to have_css('input[id="topic_title"]')
  end
  step '登録ユーザがURLからアクセスしても見ることができない' do
    click_link 'ログアウト'
    @user = create_user(admin: false)
    visit '/users/sign_in'
    fill_in 'user[login]', :with => @user.email
    fill_in 'user[password]', :with => @user.password
    click_button 'ログイン'
    visit category_path(@category)
    expect(page).not_to have_content(@topic.title)
    save_screenshot(@sc.path)
  end
  step '未登録ユーザもURLからアクセスしても見ることができない' do
    click_link 'ログアウト'
    visit category_path(@category)
    expect(page).not_to have_content(@topic.title)
    save_screenshot(@sc.path)
  end
end


