# coding: utf-8
class DeviseEx::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
  before_filter :check_status, only: [:create]
  # GET /resource/sign_in
  # def new
  #   super
  # end

  def check_status
    msg =
      if current_user.try(:locked?)
        "このアカウントはロックされています。管理者に問い合わせてください。"
      elsif current_user.try(:deleted?)
        "このアカウントは削除されています。"
      end
    if msg
      sign_out(current_user)
      redirect_to root_path, notice: msg
    end
  end
  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
