# coding: utf-8
RSpec.configure do |config|
  config.before(:each, type: :feature) do
    User.create(email: "test@example.com",
                password: "test1234",
                password_confirmation: "test1234")
  end
end
steps_for :login do
  step 'サイトにアクセスする' do
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
  end

  step 'ログインページを表示する' do
    visit '/'
  end

  step '画面にログインと表示されていること' do
    expect(page).to have_content('ログイン')
  end

  step 'id と password を入力する' do
    visit '/users/sign_in'
    fill_in 'user[email]', :with => 'test@example.com'
    fill_in 'user[password]', :with => 'test1234'
  end

  step 'ログインボタンをクリックする' do
    click_button 'ログイン'
  end

  step "view :user on screen" do |user|
    expect(page).to have_content(user)
  end

  step "画面にユーザ名test@example.comが表示されること" do
    step "view 'test@example' on screen"
  end
end

steps_for :fail_login do
  step 'サイトにアクセスする' do
    Capybara.app_host = "http://localhost:3333"
  end

  step 'ログインページを表示する' do
    visit '/'
  end

  step '画面にログインと表示されていること' do
    expect(page).to have_content('ログイン')
  end

  step 'id と 間違いのpassword を入力する' do
    visit '/users/sign_in'
    fill_in 'user[email]', :with => 'test@example.com'
    fill_in 'user[password]', :with => 'test123456789'
  end

  step 'ログインボタンをクリックする' do
    click_button 'ログイン'
  end

  step "not view :user on screen" do |user|
    expect(page).to_not have_content(user)
  end

  step "画面にユーザ名test@example.comが表示されていないこと" do
    step "not view 'test@example' on screen"
  end
end
