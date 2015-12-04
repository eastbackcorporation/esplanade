# coding: utf-8
steps_for :list do
  step 'カテゴリのデータが登録してある' do
    Category.create([{id: 1, title: "category1"},
                     {id: 2, title: "category2"},
                     {id: 3, title: "category3", image: open(Rails.root.join("test","image","100x100.png"))}])
  end

  step 'カテゴリページを表示する' do
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/categories'
  end

  step 'カテゴリが３つ表示されていること' do
    expect(page).to have_content('category1')
    expect(page).to have_content('category2')
    expect(page).to have_content('category3')
  end

  step 'デフォルト画像が表示されていること' do
    expect(page).to have_css("img[src*='category-default.png']")
  end

  step 'オリジナル画像が表示されていること' do
    expect(page).to have_css("img[src*='100x100.png']")
  end
end

steps_for :link do
  step 'カテゴリのデータが登録してある' do
    Category.create(id: 1, title: "category1")
    Topic.create(title: 'topic1',category_id: 1)
    Topic.create(title: 'topic2',category_id: 1)
  end

  step 'カテゴリページを表示する' do
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/categories'
  end

  step 'リンクをクリックする' do
    click_link "category1"
  end

  step 'カテゴリに紐付いているトピック一覧が表示される' do
    expect(page).to have_content('topic1')
    expect(page).to have_content('topic2')
  end
end

steps_for :new do
  step '管理者権限のユーザでログインする' do
    #admin
    User.create(email: "admin@example.com",
                username: "admin",
                password: "admin1234",
                password_confirmation: "admin1234",
                admin: true)
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
    visit '/users/sign_in'
    fill_in 'user[login]', :with => 'admin@example.com'
    fill_in 'user[password]', :with => 'admin1234'
    click_button 'ログイン'
  end

  step 'カテゴリページを表示する' do
    visit '/categories'
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
  step 'タイトル入力し画像を選ぶ' do
    fill_in "category[title]", with: "new category"
    attach_file "category[image]", Rails.root.join("test","image","100x100.png")
  end
  step '作成ボタンを押す' do
    click_button "Create Category"
  end
  step 'カテゴリが作成される' do
    c = Category.first
    expect(c.title).to eq "new category"
  end
  step '一覧に反映される' do
    expect(page).to have_text "new category"
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
