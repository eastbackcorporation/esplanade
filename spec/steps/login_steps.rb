# coding: utf-8
steps_for :login do
  tag = self.tag

  step 'ログインデータがある' do
    @sc = ScreenshotPath.new(tag)
    @user_info = create_user
  end

  step 'サイトにアクセスする' do
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
  end

  step 'ログインページを表示する' do
    visit '/'
    save_screenshot(@sc.path)
  end

  step '画面にログインと表示されていること' do
    expect(page).to have_content('ログイン')
    save_screenshot(@sc.path)
  end

  step 'idとpasswordを入力する' do
    visit '/users/sign_in'
    fill_in 'user[login]', :with => @user_info.username
    fill_in 'user[password]', :with => @user_info.password
  end

  step 'ログインボタンをクリックする' do
    click_button 'ログイン'
  end

  step "view :user on screen" do |user|
    expect(page).to have_content(user)
  end

  step "画面にユーザ名が表示されること" do
    step "view 'testuser' on screen"
    save_screenshot(@sc.path)
  end
end

steps_for :fail_login do
  tag = self.tag

  step 'ログインデータがある' do
    @sc = ScreenshotPath.new(tag)
    @user_info = create_user
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
    fill_in 'user[login]', :with => @user_info.username
    fill_in 'user[password]', :with => @user_info.password + "xxxx"
    save_screenshot(@sc.path)
  end

  step 'ログインボタンをクリックする' do
    click_button 'ログイン'
  end

  step "not view :user on screen" do |user|
    expect(page).to_not have_content(user)
  end

  step "画面にユーザ名が表示されていないこと" do
    step "not view '#{@user_info.username}' on screen"
    save_screenshot(@sc.path)
  end
end
