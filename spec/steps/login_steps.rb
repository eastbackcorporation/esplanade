# coding: utf-8
steps_for :login do
  step 'ログインデータがある' do
    User.create(email: "test@example.com",
                username: "testuser",
                password: "test1234",
                password_confirmation: "test1234")
  end

  step 'サイトにアクセスする' do
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
  end

  step 'ログインページを表示する' do
    visit '/'
  end

  step '画面にログインと表示されていること' do
    expect(page).to have_content('ログイン')
  end

  step 'idとpasswordを入力する' do
    visit '/users/sign_in'
    fill_in 'user[login]', :with => 'test@example.com'
    fill_in 'user[password]', :with => 'test1234'
  end

  step 'ログインボタンをクリックする' do
    click_button 'ログイン'
  end

  step "view :user on screen" do |user|
    expect(page).to have_content(user)
  end

  step "画面にユーザ名が表示されること" do
    step "view 'testuser' on screen"
  end
end

steps_for :fail_login do
  step 'ログインデータがある' do
    User.create(email: "test@example.com",
                username: "testuser",
                password: "test1234",
                password_confirmation: "test1234")
  end

  step 'サイトにアクセスする' do
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
  end

  step 'ログインページを表示する' do
    visit '/'
  end

  step '画面にログインと表示されていること' do
    expect(page).to have_content('ログイン')
  end

  step 'idと間違いのpasswordを入力する' do
    visit '/users/sign_in'
    fill_in 'user[login]', :with => 'test@example.com'
    fill_in 'user[password]', :with => 'test123456789'
  end

  step 'ログインボタンをクリックする' do
    click_button 'ログイン'
  end

  step "not view :user on screen" do |user|
    expect(page).to_not have_content(user)
  end

  step "画面にユーザ名が表示されていないこと" do
    step "not view 'testuser' on screen"
  end
end
