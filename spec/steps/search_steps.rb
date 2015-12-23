# coding: utf-8
steps_for :searchresult do
  tag = self.tag
  step 'データが登録してある' do
    @sc = ScreenshotPath.new(tag)
    @categories = []
    @topics = []
    @comments = []
    %w"category0 category1 category2".each do |w|
      @categories << create_category(title: w)
    end
    %w"topic0 topic1 topic2".each do |w|
      @topics << create_topic(title: w,value: "value#{w}",category: @categories[0])
    end
    %w"comment0 comment1 comment2".each do |w|
      @comments << create_comment(value: w,topic: @topics[0])
    end
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit home_forums_path
  end
  step '検索ボタンを押す' do
    find('span[class="glyphicon glyphicon-search"]').click
  end
  step '登録されているデータがすべて表示されている' do
    save_screenshot(@sc.path)
    @topics.each do |t|
      expect(page).to have_content(t.title)
      expect(page).to have_content(t.value)
    end
    @comments.each do |c|
      expect(page).to have_content(c.value)
    end
  end
  step '検索ワードを入れて検索ボタンを押す' do
    @word = "1"
    fill_in "word[]", with: @word
    save_screenshot(@sc.path)
    find('span[class="glyphicon glyphicon-search"]').click
  end
  step 'ワードが含まれた検索結果が表示される' do
    save_screenshot(@sc.path)
    expect(page).to have_content(@word)
  end
end

steps_for :searchdate do

  tag = self.tag
  step 'データが登録してある' do
    @sc = ScreenshotPath.new(tag)
    @category = create_category
    @topics = []
    @comments = []
    5.times do |i|
      @topics << create_topic(title:"topic#{i}",value: "value#{i}",category: @category,created_at: Time.now - i.day,updated_at: Time.now - i.day)
    end
    5.times do |i|
      @comments << create_comment(value: "comment#{i}",topic: @topics[0],created_at: Time.now - i.day,updated_at: Time.now - i.day)
    end
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit home_forums_path
  end
  step '詳細画面で日付けを入力して検索ボタンを押す' do
    @start = (Time.now - 3.day ).to_s(:date)
    @end = (Time.now - 1.day ).to_s(:date)
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    select("期間を指定",from: 'between_datetime')
    fill_in "created_at_gteq_", with: @start
    fill_in "created_at_lteq_", with: @end
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step '日付け内の内容が検索結果に表示される' do
    save_screenshot(@sc.path)
    expect(page).not_to have_content(@topics[0].title)
    expect(page).to have_content(@topics[1].title)
    expect(page).to have_content(@topics[2].title)
    expect(page).to have_content(@topics[3].title)
    expect(page).not_to have_content(@topics[4].title)
    expect(page).not_to have_content(@comments[0].value)
    expect(page).to have_content(@comments[1].value)
    expect(page).to have_content(@comments[2].value)
    expect(page).to have_content(@comments[3].value)
    expect(page).not_to have_content(@comments[4].value)
  end
  step '開始日だけ入力して検索ボタンを押す' do
    @start = (Time.now - 3.day ).to_s(:date)
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    select("期間を指定",from: 'between_datetime')
    fill_in "created_at_gteq_", with: @start
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step '開始日から最新の内容が検索結果に表示される' do
    save_screenshot(@sc.path)
    expect(page).to have_content(@topics[0].title)
    expect(page).to have_content(@topics[1].title)
    expect(page).to have_content(@topics[2].title)
    expect(page).to have_content(@topics[3].title)
    expect(page).not_to have_content(@topics[4].title)
    expect(page).to have_content(@comments[0].value)
    expect(page).to have_content(@comments[1].value)
    expect(page).to have_content(@comments[2].value)
    expect(page).to have_content(@comments[3].value)
    expect(page).not_to have_content(@comments[4].value)
  end
  step '終了日を入力して検索ボタンを押す' do
    @end = (Time.now - 1.day ).to_s(:date)
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    select("期間を指定",from: 'between_datetime')
    fill_in "created_at_lteq_", with: @end
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step '終了日までの内容が検索結果に表示される' do
    save_screenshot(@sc.path)
    expect(page).not_to have_content(@topics[0].title)
    expect(page).to have_content(@topics[1].title)
    expect(page).to have_content(@topics[2].title)
    expect(page).to have_content(@topics[3].title)
    expect(page).to have_content(@topics[4].title)
    expect(page).not_to have_content(@comments[0].value)
    expect(page).to have_content(@comments[1].value)
    expect(page).to have_content(@comments[2].value)
    expect(page).to have_content(@comments[3].value)
    expect(page).to have_content(@comments[4].value)
  end
end
steps_for :searchcategory do
  tag = self.tag
  step 'データが登録してある' do
    @sc = ScreenshotPath.new(tag)
    @categories = []
    @topics = []
    @comments = []
    3.times do |i|
      @categories << create_category(title: "category#{i}")
    end
    (0..3).each do |i|
      @topics << create_topic(title:"topic#{i}",value: "value#{i}",category: @categories[0],created_at: Time.now - i.day,updated_at: Time.now - i.day)
    end
    (4..5).each do |i|
      @topics << create_topic(title:"topic#{i}",value: "value#{i}",category: @categories[1],created_at: Time.now - i.day,updated_at: Time.now - i.day)
    end
    (0..3).each do |i|
      @comments << create_comment(value: "comment#{i}",topic: @topics[0],created_at: Time.now - i.day,updated_at: Time.now - i.day)
    end
    (4..5).each do |i|
      @comments << create_comment(value: "comment#{i}",topic: @topics[4],created_at: Time.now - i.day,updated_at: Time.now - i.day)
    end
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit home_forums_path
  end
  step '詳細画面でカテゴリを選んで検索ボタンを押す' do
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    select(@categories[0].title,from: 'category_id')
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step '選択したカテゴリ内の内容が検索結果に表示される' do
    save_screenshot(@sc.path)
    expect(page).to have_content(@topics[0].title)
    expect(page).to have_content(@topics[1].title)
    expect(page).to have_content(@topics[2].title)
    expect(page).to have_content(@topics[3].title)
    expect(page).not_to have_content(@topics[4].title)
    expect(page).to have_content(@comments[0].value)
    expect(page).to have_content(@comments[1].value)
    expect(page).to have_content(@comments[2].value)
    expect(page).to have_content(@comments[3].value)
    expect(page).not_to have_content(@comments[4].value)
  end
end
steps_for :searchtopic do
  tag = self.tag
  step 'データが登録してある' do
    @sc = ScreenshotPath.new(tag)
    @category = create_category
    @topics = []
    @comments = []
    5.times do |i|
      @topics << create_topic(title:"topic#{i}",value: "value#{i}",category: @category,created_at: Time.now - i.day,updated_at: Time.now - i.day)
    end
    5.times do |i|
      @comments << create_comment(value: "comment#{i}",topic: @topics[0],created_at: Time.now - i.day,updated_at: Time.now - i.day)
    end
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit home_forums_path
  end
  step '詳細画面でトピックにチェックを入れて検索ボタンを押す' do
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    check "topic"
    uncheck "comment"
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step 'トピックの内容が検索結果に表示される' do
    expect(page).to have_content(@topics[0].title)
    expect(page).to have_content(@topics[1].title)
    expect(page).to have_content(@topics[2].title)
    expect(page).to have_content(@topics[3].title)
    expect(page).to have_content(@topics[4].title)
    expect(page).not_to have_content(@comments[0].value)
  end
  step '詳細画面でトピックにチェックを外して検索ボタンを押す' do
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    uncheck "topic"
    check "comment"
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step 'トピックの内容が検索結果に表示されない' do
    save_screenshot(@sc.path)
    expect(page).not_to have_content(@topics[0].title)
    expect(page).not_to have_content(@topics[1].title)
    expect(page).not_to have_content(@topics[2].title)
    expect(page).not_to have_content(@topics[3].title)
    expect(page).not_to have_content(@topics[4].title)
    expect(page).to have_content(@comments[0].value)
  end
  step '詳細画面でトピックとコメントにチェックを外して検索ボタンを押す' do
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    uncheck "topic"
    uncheck "comment"
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step 'トピックもコメントも内容が検索結果に表示される' do
    save_screenshot(@sc.path)
    expect(page).to have_content(@topics[0].title)
    expect(page).to have_content(@topics[1].title)
    expect(page).to have_content(@topics[2].title)
    expect(page).to have_content(@topics[3].title)
    expect(page).to have_content(@topics[4].title)
    expect(page).to have_content(@comments[0].value)
  end
  step '詳細画面でトピックにチェックを入れてワード入れて検索ボタンを押す' do
    @word = "0"
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    find(:css,'input[class="form-control modal-word"]').set(@word)
    check "topic"
    uncheck "comment"
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step 'ワードを限定したトピックの内容が検索結果に表示される' do
    save_screenshot(@sc.path)
    expect(page).to have_content(@topics[0].title)
    expect(page).not_to have_content(@topics[1].title)
    expect(page).not_to have_content(@comments[0].value)
  end
end

steps_for :searchcomment do
  tag = self.tag
  step 'データが登録してある' do
    @sc = ScreenshotPath.new(tag)
    @category = create_category
    @topics = []
    @comments = []
    5.times do |i|
      @topics << create_topic(title:"topic#{i}",value: "value#{i}",category: @category,created_at: Time.now - i.day,updated_at: Time.now - i.day)
    end
    5.times do |i|
      @comments << create_comment(value: "comment#{i}",topic: @topics[0],created_at: Time.now - i.day,updated_at: Time.now - i.day)
    end
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit home_forums_path
  end
  step '詳細画面でトピックにチェックを入れて検索ボタンを押す' do
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    check "topic"
    uncheck "comment"
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step '詳細画面でコメントにチェックを入れて検索ボタンを押す' do
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    uncheck "topic"
    check "comment"
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step 'コメントの内容が検索結果に表示される' do
    expect(page).not_to have_content(@topics[0].title)
    expect(page).to have_content(@comments[0].value)
    expect(page).to have_content(@comments[1].value)
    expect(page).to have_content(@comments[2].value)
    expect(page).to have_content(@comments[3].value)
    expect(page).to have_content(@comments[4].value)
  end
  step '詳細画面でコメントにチェックを入れてワード入れて検索ボタンを押す' do
    @word = "0"
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    find(:css,'input[class="form-control modal-word"]').set(@word)
    uncheck "topic"
    check "comment"
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step 'ワードを限定したコメントの内容が検索結果に表示される' do
    save_screenshot(@sc.path)
    expect(page).not_to have_content(@topics[0].title)
    expect(page).to have_content(@comments[0].value)
    expect(page).not_to have_content(@comments[1].value)
  end
end

steps_for :searchuser do
  tag = self.tag
  step 'データが登録してある' do
    @sc = ScreenshotPath.new(tag)
    @admin = create_user(admin: true)
    @user = create_user(admin: false)
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
  end
  step '管理者以外で詳細画面を開く' do
    visit home_forums_path
    find('span[class="glyphicon glyphicon-option-vertical"]').click
  end
  step 'ユーザのチェックボックスが表示されていない' do
    expect(page).not_to have_content('ユーザ')
    click_button 'キャンセル'
  end
  step '詳細画面でユーザにチェックを入れて検索ボタンを押す' do
    visit '/users/sign_in'
    fill_in 'user[login]', :with => @admin.email
    fill_in 'user[password]', :with => @admin.password
    click_button 'ログイン'
    visit home_forums_path
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    uncheck "topic"
    uncheck "comment"
    check "user"
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step 'ユーザの内容が検索結果に表示される' do
    expect(page).to have_content(@user.email)
    expect(page).to have_content(@admin.email)
  end
  step '詳細画面でユーザにチェックを外して検索ボタンを押す' do
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    check "topic"
    check "comment"
    uncheck "user"
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step 'ユーザの内容が検索結果に表示されない' do
    expect(page).not_to have_content(@user.email)
    expect(page).not_to have_content(@admin.email)
  end
end

steps_for :searchstatus do
  tag = self.tag
  step 'データが登録してある' do
    @sc = ScreenshotPath.new(tag)
    @admin = create_user(admin: true)
    @categories = {}
    @topics = {}
    @comments = {}
    @users = {}
    [:active, :deleted].each do |s|
      @categories[s] = create_category(title: s, status: s)
      @topics[s] = create_topic(title:s,value:s,status: s, category: @categories[s])
      @comments[s] = create_comment(value:s,status: s, topic: @topics[s])
      @users[s] = create_user(status: s)
    end
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
  end
  step '管理者以外で詳細画面を開くと' do
    visit home_forums_path
    find('span[class="glyphicon glyphicon-option-vertical"]').click
  end
  step 'ステータスのチェックボックスが表示されていない' do
    save_screenshot(@sc.path)
    expect(page).not_to have_content('ステータス')
    click_button 'キャンセル'
  end
  step '詳細画面でステータスにチェックを入れて検索ボタンを押す' do
    visit '/users/sign_in'
    fill_in 'user[login]', :with => @admin.email
    fill_in 'user[password]', :with => @admin.password
    click_button 'ログイン'
    visit home_forums_path
    find('span[class="glyphicon glyphicon-option-vertical"]').click
    uncheck "category_statuses_active"
    uncheck "category_statuses_archived"
    check "category_statuses_deleted"
    uncheck "topic_statuses_active"
    uncheck "topic_statuses_archived"
    check "topic_statuses_deleted"
    uncheck "comment_statuses_active"
    check "comment_statuses_deleted"
    uncheck "user_statuses_active"
    uncheck "user_statuses_locked"
    check "user_statuses_deleted"
    save_screenshot(@sc.path)
    click_button "検索"
  end
  step '該当のステータスが検索結果に表示される' do
    a = :active
    d = :deleted
    expect(page).not_to have_content(@users[a].username)
    expect(page).to have_content(@users[d].username)
    expect(page).not_to have_content(@topics[a].title)
    expect(page).to have_content(@topics[d].title)
    expect(page).not_to have_content(@comments[a].value)
    expect(page).to have_content(@comments[d].value)
  end
end
