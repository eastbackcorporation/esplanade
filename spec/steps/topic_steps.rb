# coding: utf-8
steps_for :list do
  step 'トピックのデータが登録してある' do
    Category.create(id: 1, title: 'category1')
    #normal user
    User.create(email: "test@example.com",
                username: "user1",
                password: "test1234",
                password_confirmation: "test1234",
                admin: false)
    Topic.create(title: 'topic1', value: 'value1', category_id: 1,user_id: 1)
    Topic.create(title: 'topic2', value: 'value2', category_id: 1,user_id: 1)
    Topic.create(title: 'topic3', value: 'value3', category_id: 1,user_id: 1)
  end

  step 'カテゴリのページを表示する' do
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/categories'
  end

  step 'カテゴリのリンクをクリックする' do
    click_link 'category1'
  end

  step 'トピックの一覧が表示されていること' do
    expect(page).to have_content 'topic1'
    expect(page).to have_content 'topic2'
    expect(page).to have_content 'topic3'
  end
end

steps_for :link do
  step 'トピックのデータが登録してある' do
    #normal user
    User.create(email: "test@example.com",
                username: "user1",
                password: "test1234",
                password_confirmation: "test1234",
                admin: false)
    @category = Category.create(id: 1, title: "category1")
    Topic.create(id: 1,title: 'topic1',category_id: 1,user_id: 1)
    Comment.create(value: 'comment1',topic_id: 1,user_id: 1)
    Comment.create(value: 'comment2',topic_id: 1,user_id: 1)
  end

  step 'トピックのページを表示する' do
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit category_path(@category)
  end

  step 'リンクをクリックする' do
    click_link "topic1"
  end

  step 'トピックに紐付いているコメント一覧が表示される' do
    expect(page).to have_content('comment1')
    expect(page).to have_content('comment2')
  end
end

steps_for :new do
  step '登録ユーザでログインする' do
    #normal user
    User.create(email: "test@example.com",
                username: "user1",
                password: "test1234",
                password_confirmation: "test1234",
                admin: false)
    @category = Category.create(id: 1, title: "category1")
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/users/sign_in'
    fill_in 'user[login]', :with => 'test@example.com'
    fill_in 'user[password]', :with => 'test1234'
    click_button 'ログイン'
  end

  step 'トピックページを表示する' do
    visit category_path(@category)
  end

  step '新規作成が表示されていること' do
    expect(page).to have_content('新規作成')
  end

  step '新規作成をクリックする' do
    click_link "新規作成"
  end
  step '新規作成画面が表示されていること' do
    expect(page).to have_content('新規作成')
  end
  step 'タイトルと詳細を入力する' do
    fill_in "topic[title]", with: "new topic"
    fill_in "topic[value]", with: "new value"
  end
  step '投稿ボタンを押す' do
    click_button "Create Category"
  end
  step 'トピックが作成される' do
    c = Topic.first
    expect(c.title).to eq "new topic"
    expect(c.value).to eq "new value"
  end
  step '一覧に反映される' do
    expect(page).to have_text "new topic"
  end
end


steps_for :new_only_registered_user do
  step 'トピックページを表示する' do
    @category = Category.create(id: 1, title: "category1")
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit category_path(@category)
  end

  step '新規作成が表示されていないこと' do
    expect(page).not_to have_content('新規作成')
  end
  step '新規作成ページが表示されない' do
    visit new_topic_path
    expect(page).not_to have_content('投稿')
  end
end
